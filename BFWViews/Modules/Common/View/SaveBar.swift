//
//  SaveBar.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 18/2/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {
    func saveBar<Model: Equatable>(
        model: Binding<Model?>,
        isChanged: Binding<Bool>? = nil,
        onSave: @escaping (Model) async throws -> Void,
    ) -> some View {
        modifier(
            SaveBarModifier(
                model: model,
                externalIsChanged: isChanged,
                onSave: onSave,
            )
        )
    }
}

struct SaveBarModifier<Model: Equatable> {
    @Binding var model: Model?
    let externalIsChanged: Binding<Bool>?
    let onSave: (Model) async throws -> Void
    @State var savedModel: Model?
}

// MARK: - Functions

extension SaveBarModifier {
    
    var isChanged: Bool {
        model != savedModel
    }
    
    func onAppear() {
        // Sync `savedModel` to the loaded `model` on first appear so that
        // edit-existing scenes (model passed in pre-populated) start with
        // `isChanged == false`. Without this, `savedModel` stays nil and any
        // non-nil `model` reads as dirty, showing Cancel/Save immediately.
        if savedModel == nil, model != nil {
            savedModel = model
        }
        externalIsChanged?.wrappedValue = isChanged
    }
    
    func onChange(isChanged: Bool) {
        externalIsChanged?.wrappedValue = isChanged
    }
    
    func onTapCancel() {
        model = savedModel
    }
    
    var saveButton: Plan.Button? {
        guard isChanged else { return nil }
        return .init("Save", systemImage: "checkmark") {
            guard let model else { return }
            try await onSave(model)
            savedModel = model
        }
    }
    
    var cancelButton: Plan.Button? {
        guard isChanged else { return nil }
        return .init("Cancel", systemImage: "xmark", role: .cancel) {
            onTapCancel()
        }
    }
    
}

// MARK: - Views

extension SaveBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
            }
            .navigationBarBackButtonHidden(isChanged)
            .interactiveDismissDisabled(isChanged)
            .onAppear { onAppear() }
            .onChange(of: isChanged) { onChange(isChanged: $0) }
    }
    
}

// MARK: - Previews

#Preview("SaveBar") {
    NavigationStack {
        Preview(person: .tomBH)
    }
}

private struct Preview: View {
    @State var id: String
    @State var firstName: String
    @State var lastName: String
    @State var email: String
    @State var salutation: Person.Salutation?
}

extension Preview {
    
    init(person: Person) {
        self.init(
            id: String(person.id),
            firstName: person.firstName,
            lastName: person.lastName,
            email: person.email ?? "",
            salutation: person.salutation
        )
    }
    
    var person: Person {
        .init(
            id: Int(id)!,
            firstName: firstName,
            lastName: lastName,
            email: email.nilIfEmpty,
            salutation: salutation
        )
    }
    
    var personBinding: Binding<Person?> {
        .init {
            person
        } set: { person in
            id = person.map { String($0.id) } ?? ""
            firstName = person?.firstName ?? ""
            lastName = person?.lastName ?? ""
            email = person?.email ?? ""
            salutation = person?.salutation
        }
    }
    
    struct Person: Equatable {
        let id: Int
        let firstName: String
        let lastName: String
        let email: String?
        let salutation: Salutation?
        
        enum Salutation: String, CaseIterable, Identifiable {
            case mr, mrs, miss
            
            var id: Self { self }
        }
        
        static let tomBH = Person(
            id: 1,
            firstName: "Tom",
            lastName: "Brodhurst-Hill",
            email: "tom@example.com",
            salutation: nil
        )
    }
    
    var body: some View {
        List {
            Picker(
                "Salutation",
                selection: $salutation,
            ) {
                ForEach(Person.Salutation.allCases) {
                    Text($0.rawValue.capitalized)
                        .tag($0)
                }
            }
            TextField("ID", text: $id)
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Email", text: $email)
        }
        .saveBar(model: personBinding) { _ in }
    }
}
