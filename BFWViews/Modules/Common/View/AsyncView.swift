//
//  AsyncView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 7/11/2025.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

/// A view that asynchronously loads and displays content, with built-in loading and error states.
///
/// The simplest usage just provides an async-throwing closure that returns a `View`:
/// ```swift
/// AsyncView {
///     let users = try await api.fetchUsers()
///     return List(users) { user in Text(user.name) }
/// }
/// ```
///
/// Custom placeholder and failure views:
/// ```swift
/// AsyncView(
///     content: { try await fetchData(); return DataView(data: data) },
///     placeholder: { Text("Loading...") },
///     failure: { error, retry in Button("Retry", action: retry) }
/// )
/// ```
public struct AsyncView<Content: View, Placeholder: View, Failure: View, ID: Equatable> {
    let id: ID
    let content: @Sendable () async throws -> Content
    let placeholder: () -> Placeholder
    let failure: (Error, _ retry: @escaping () -> Void) -> Failure
    @State private var phase: Phase = .loading
    @State private var loadedID = 0
    
    /// Creates an `AsyncView` with custom placeholder and failure views that reloads when `id` changes.
    public init(
        id: ID,
        @ViewBuilder content: @Sendable @escaping () async throws -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder failure: @escaping (_ error: Error, _ retry: @escaping () -> Void) -> Failure
    ) {
        self.id = id
        self.content = content
        self.placeholder = placeholder
        self.failure = failure
    }
}

// MARK: - Inits

public extension AsyncView where ID == Int {
    
    /// Creates an `AsyncView` with custom placeholder and failure views.
    init(
        @ViewBuilder content: @Sendable @escaping () async throws -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder failure: @escaping (_ error: Error, _ retry: @escaping () -> Void) -> Failure
    ) {
        self.init(id: 0, content: content, placeholder: placeholder, failure: failure)
    }
}

public extension AsyncView where Failure == ContentUnavailableView<Plan.Button> {
    
    /// Creates an `AsyncView` with a custom placeholder and default failure view that reloads when `id` changes.
    init(
        id: ID,
        @ViewBuilder content: @Sendable @escaping () async throws -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.init(
            id: id,
            content: content,
            placeholder: placeholder,
            failure: { error, retry in
                ContentUnavailableView(error: error) {
                    Plan.Button("Retry", action: retry)
                }
            }
        )
    }
}

public extension AsyncView
where Failure == ContentUnavailableView<Plan.Button>,
      ID == Int
{
    /// Creates an `AsyncView` with a custom placeholder and default failure view.
    init(
        @ViewBuilder content: @Sendable @escaping () async throws -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.init(id: 0, content: content, placeholder: placeholder)
    }
}

public extension AsyncView
where Placeholder == ProgressView<EmptyView, EmptyView>,
      Failure == ContentUnavailableView<Plan.Button>
{
    /// Creates an `AsyncView` with default placeholder and failure views that reloads when `id` changes.
    init(
        id: ID,
        @ViewBuilder content: @Sendable @escaping () async throws -> Content
    ) {
        self.init(id: id, content: content, placeholder: { ProgressView() })
    }
}

public extension AsyncView
where Placeholder == ProgressView<EmptyView, EmptyView>,
      Failure == ContentUnavailableView<Plan.Button>,
      ID == Int
{
    /// Creates an `AsyncView` with default placeholder and failure views.
    init(
        @ViewBuilder content: @Sendable @escaping () async throws -> Content
    ) {
        self.init(id: 0, content: content)
    }
}

// MARK: - Types

private extension AsyncView {
    
    enum Phase {
        case loading
        case success(Content)
        case failure(Error)
    }
}

/// Combines the external `id` with the internal `loadID` for `.task(id:)`.
private struct TaskID<ID: Equatable>: Equatable {
    let id: ID
    let loadedID: Int
}

// MARK: - Functions

private extension AsyncView {
    
    var taskID: TaskID<ID> {
        TaskID(id: id, loadedID: loadedID)
    }
    
    func load() async {
        // Show placeholder on initial load and retry from error,
        // but keep existing content visible during refresh.
        if case .success = phase {} else {
            phase = .loading
        }
        do {
            let view = try await content()
            phase = .success(view)
        } catch is CancellationError {
            // Don't update phase on cancellation.
        } catch {
            phase = .failure(error)
        }
    }
    
    func retry() {
        loadedID += 1
    }
    
    func onRefresh() {
        retry()
    }
    
}

// MARK: - View

extension AsyncView: View {
    public var body: some View {
        Group {
            switch phase {
            case .loading:
                placeholder()
            case .success(let loadedContent):
                loadedContent
                    .refreshable { onRefresh() }
            case .failure(let error):
                failure(error, retry)
            }
        }
        .task(id: taskID) { await load() }
    }
}

// MARK: - Previews

#Preview("Success") {
    AsyncView {
        try await Task.sleep(seconds: 1)
        return Text("Hello, World!")
    }
}

#Preview("Failure") {
    AsyncView {
        try await Task.sleep(seconds: 1)
        throw URLError(.notConnectedToInternet)
        return Text("Unreachable")
    }
}

#Preview("Custom placeholder") {
    AsyncView(
        content: {
            try await Task.sleep(seconds: 2)
            return Text("Loaded!")
        },
        placeholder: {
            VStack {
                ProgressView()
                Text("Custom placeholder...")
                    .foregroundStyle(.secondary)
            }
        }
    )
}

#Preview("Custom failure") {
    AsyncView(
        content: {
            try await Task.sleep(seconds: 1)
            throw URLError(.notConnectedToInternet)
            return Text("Unreachable")
        },
        placeholder: {
            ProgressView()
        },
        failure: { error, retry in
            VStack(spacing: 12) {
                Image(systemName: "wifi.slash")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
                Text(error.localizedDescription)
                    .multilineTextAlignment(.center)
                Button("Try Again", action: retry)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    )
}
#Preview("List (pull to refresh)") {
    AsyncView {
        try await Task.sleep(seconds: 1)
        let items = (1...10).map { "Item \($0) — \(Date.now.formatted(date: .omitted, time: .standard))" }
        return List(items, id: \.self) { item in
            Text(item)
        }
    }
}

#Preview("List (failure then retry)") {
    AsyncView {
        try await Task.sleep(seconds: 1)
        if Bool.random() {
            throw URLError(.notConnectedToInternet)
        }
        let items = (1...5).map { "Row \($0)" }
        return List(items, id: \.self) { item in
            Text(item)
        }
    }
}
