//
//  EditFlow.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 26/5/2026.
//

import SwiftUI

/// Owns a draft `Model` and wraps a chrome-free form view with commit chrome (saveBar's Save / Cancel, or a single Next toolbar button). Lets one form definition serve multiple containers without each container duplicating its own state-ownership boilerplate.
public struct EditFlow<Form: View, Model: Equatable>: View {
    @State var model: Model
    let style: Style
    let form: (Binding<Model>) -> Form
    let onCommit: (Model) async throws -> Void
    
    public init(
        model: Model,
        style: Style = .save,
        @ViewBuilder form: @escaping (Binding<Model>) -> Form,
        onCommit: @escaping (Model) async throws -> Void
    ) {
        _model = State(wrappedValue: model)
        self.style = style
        self.form = form
        self.onCommit = onCommit
    }
}

// MARK: - Types

extension EditFlow {
    
    public enum Style {
        case next
        case save
    }
    
}

// MARK: - Functions

extension EditFlow {
    
    /// Bridges `Model` to saveBar's `Binding<Model?>` API. Always non-nil; the setter ignores nil so saveBar's revert path lands cleanly back into `@State`.
    var savableBinding: Binding<Model?> {
        Binding {
            model
        } set: { newValue in
            if let newValue {
                model = newValue
            }
        }
    }
    
    var nextButton: Plan.Button {
        .init("Next", systemImage: "arrow.forward") {
            try await onCommit(model)
        }
    }
    
}

// MARK: - Views

extension EditFlow {
    
    @ViewBuilder
    public var body: some View {
        switch style {
        case .next:
            form($model)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        nextButton
                    }
                }
        case .save:
            form($model)
                .saveBar(savableBinding, onSave: onCommit)
        }
    }
    
}

// MARK: - Previews

private enum Preview {
    
    struct Item: Equatable {
        var name: String
        var detail: String
    }
    
    
    struct ItemForm: View {
        @Binding var item: Item
        
        var body: some View {
            Form {
                TextField("Name", text: $item.name)
                TextField("Detail", text: $item.detail)
            }
            .navigationTitle("Item")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview("Save") {
    NavigationStack {
        EditFlow(
            model: Preview.Item(name: "", detail: ""),
            style: .save,
            form: { Preview.ItemForm(item: $0) },
            onCommit: { _ in }
        )
    }
}

#Preview("Next") {
    NavigationStack {
        EditFlow(
            model: Preview.Item(name: "", detail: ""),
            style: .next,
            form: { Preview.ItemForm(item: $0) },
            onCommit: { _ in }
        )
    }
}
