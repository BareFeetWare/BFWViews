//
//  PropertyList.swift
//
//  Created by Tom Brodhurst-Hill on 18/6/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI

public class PropertyList: ObservableObject {
    
    public init(dictionary: [String : any Hashable & Equatable] = [:]) {
        self.dictionary = dictionary
    }
    
    @Published var dictionary: [String: any Hashable & Equatable]
}

public extension PropertyList {
    
    func binding<T: Hashable & Equatable>(
        id: String
    ) -> Binding<T?> {
        .init {
            self.dictionary[id] as? T
        } set: {
            self.dictionary[id] = $0
        }
    }
    
    func binding<T: Hashable & Equatable>(
        id: String, default: T
    ) -> Binding<T> {
        .init {
            self.dictionary[id] as? T ?? `default`
        } set: {
            self.dictionary[id] = $0
        }
    }
    
    /// Stores true or nil in dictionary. False is stored as nil.
    func trueBinding(
        id: String
    ) -> Binding<Bool> {
        .init {
            self.dictionary[id] as? Bool ?? false
        } set: {
            self.dictionary[id] = ($0 == true) ? true : nil
        }
    }
    
    func isNotNilBinding(id: String) -> Binding<Bool> {
        .init {
            self.dictionary[id] != nil
        } set: {
            self.dictionary[id] = $0 ? "not nil" : nil
        }
    }
    
    func isAllNotNilBinding(ids: [String]) -> Binding<Bool> {
        .init {
            ids.reduce(true) { partialResult, id in
                partialResult && self.dictionary[id] != nil
            }
        } set: { newValue in
            ids.forEach { id in
                self.dictionary[id] = newValue ? "not nil" : nil
            }
        }
    }
}
