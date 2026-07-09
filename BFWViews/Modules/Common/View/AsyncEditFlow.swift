//
//  AsyncEditFlow.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 8/7/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

/// Loads a `Loaded` envelope, then hands it plus a state-owned draft `Model` to a chrome-free form. Wraps `AsyncView` around an `EditFlow`, so the loading/error/retry surface and the saveBar/next-button chrome are both delegated. Callers supply how to load, how to compute the initial draft from the loaded data, how to render the form, and how to commit — everything else is done by the composition.
public struct AsyncEditFlow<Loaded, Model: Equatable, Form: View> {
    let loaded: () async throws -> Loaded
    let initialModel: (Loaded) -> Model
    let form: (Loaded, Binding<Model>) -> Form
    let onCommit: (Loaded, Model) async throws -> Void
    let style: EditFlow<Form, Model>.Style
    let isChanged: Binding<Bool>?
    
    public init(
        loaded: @escaping () async throws -> Loaded,
        initialModel: @escaping (Loaded) -> Model,
        style: EditFlow<Form, Model>.Style = .save,
        @ViewBuilder form: @escaping (Loaded, Binding<Model>) -> Form,
        onCommit: @escaping (Loaded, Model) async throws -> Void,
        isChanged: Binding<Bool>? = nil
    ) {
        self.loaded = loaded
        self.initialModel = initialModel
        self.style = style
        self.form = form
        self.onCommit = onCommit
        self.isChanged = isChanged
    }
}

// MARK: - Views

extension AsyncEditFlow: View {
    public var body: some View {
        AsyncView {
            let loaded = try await loaded()
            return EditFlow(
                model: initialModel(loaded),
                style: style,
                form: { modelBinding in
                    form(loaded, modelBinding)
                },
                onCommit: { model in
                    try await onCommit(loaded, model)
                },
                isChanged: isChanged
            )
        }
    }
}

// MARK: - Previews

private enum Preview {
    
    struct Loaded {
        let options: [String]
    }
    
    struct Draft: Equatable {
        var pick: String
    }
    
    struct DraftForm: View {
        let loaded: Loaded
        @Binding var draft: Draft
        
        var body: some View {
            Form {
                Picker("Pick", selection: $draft.pick) {
                    ForEach(loaded.options, id: \.self) { Text($0) }
                }
            }
            .navigationTitle("Draft")
        }
    }
    
}

#Preview {
    NavigationStack {
        AsyncEditFlow(
            loaded: {
                Preview.Loaded(options: ["One", "Two", "Three"])
            },
            initialModel: { loaded in
                Preview.Draft(pick: loaded.options.first ?? "")
            },
            form: { loaded, draft in
                Preview.DraftForm(loaded: loaded, draft: draft)
            },
            onCommit: { _, _ in }
        )
    }
}
