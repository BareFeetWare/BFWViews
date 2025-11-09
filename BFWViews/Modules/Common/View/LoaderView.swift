//
//  LoaderView.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 7/11/2025.
//  Copyright © 2025 BareFeetWare. All rights reserved.
//

import SwiftUI

public struct LoaderView<Content: View> {
    public let content: () async throws -> Content
    public let timelineModifier: ((Content) -> Content)?
    @State private var status: Status = .loading
    @State private var alert: Plan.Alert?
    
    public init(
        status: Status = .loading,
        content: @escaping () async throws -> Content,
        timelineModifier: ((Content) -> Content)? = nil
    ) {
        self.status = status
        self.content = content
        self.timelineModifier = timelineModifier
    }
}

// MARK: - Types

public extension LoaderView {
    
    enum Status {
        case loading
        case success(Content)
    }
    
}

// MARK: - Functions

extension LoaderView {
    
    func loadContent() async {
        do {
            status = .success(try await content())
        } catch {
            presentError(error)
        }
    }
    
    func onTask() async {
        await loadContent()
    }
    
    func onRefresh() async {
        await loadContent()
    }
    
    func presentError(_ error: Error) {
        alert = .init(error: error)
    }
    
}

// MARK: - Views

extension LoaderView: View {
    public var body: some View {
        statusView
            .refreshable { await onRefresh() }
            .task { await onTask() }
            .alert($alert)
    }
    
    @ViewBuilder
    var statusView: some View {
        switch status {
        case .loading:
            ProgressView()
        case .success(let content):
            if let timelineModifier {
                TimelineView(.periodic(from: .now, by: 1)) { context in
                    timelineModifier(content)
                }
            } else {
                content
            }
        }
    }
}

// MARK: - Previews

#Preview {
    LoaderView {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return Text("Date: \(Date.now)")
    }
}
