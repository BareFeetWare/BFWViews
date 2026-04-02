//
//  View+NavigationToolbarTitle.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 2/4/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import SwiftUI

public extension View {

    /// Sets the navigation bar title using a toolbar item with `.title` placement.
    ///
    /// SwiftUI's `.navigationTitle(_:)` only communicates with SwiftUI's own
    /// `NavigationStack`. When a view is hosted inside a UIKit
    /// `UINavigationController` — such as the `UIMoreNavigationController`
    /// that `UITabBarController` creates for overflow tabs — `.navigationTitle`
    /// has no effect and the title is blank.
    ///
    /// `.toolbar` items *do* bridge correctly to UIKit navigation controllers.
    /// This modifier uses `ToolbarItem(placement: .title)` to place a `Text`
    /// view in the inline title area, which works in both `NavigationStack`
    /// and UIKit navigation controllers.
    ///
    /// Use this modifier in place of `.navigationTitle(_:)` on any view that
    /// may appear inside a UIKit navigation controller without a SwiftUI
    /// `NavigationStack` ancestor.
    ///
    /// - Parameter title: The string to display in the navigation bar.
    func navigationToolbarTitle(_ title: String) -> some View {
        toolbar {
            ToolbarItem(placement: .title) {
                Text(title)
            }
        }
    }

}

// MARK: - Previews

#Preview("In NavigationStack") {
    NavigationStack {
        List {
            Text("Content with navigationToolbarTitle")
        }
        .navigationToolbarTitle("NavigationStack Title")
    }
}

#Preview("TabView with More overflow") {
    TabView {
        NavigationStack {
            List { Text("First tab") }
                .navigationToolbarTitle("First")
        }
        .tabItem { Label("First", systemImage: "1.circle") }

        NavigationStack {
            List { Text("Second tab") }
                .navigationToolbarTitle("Second")
        }
        .tabItem { Label("Second", systemImage: "2.circle") }

        NavigationStack {
            List { Text("Third tab") }
                .navigationToolbarTitle("Third")
        }
        .tabItem { Label("Third", systemImage: "3.circle") }

        NavigationStack {
            List { Text("Fourth tab") }
                .navigationToolbarTitle("Fourth")
        }
        .tabItem { Label("Fourth", systemImage: "4.circle") }

        // These overflow into the More tab on iPhone.
        // .navigationTitle would show a blank title here,
        // but .navigationToolbarTitle works correctly.

        List {
            NavigationLink("Push detail") {
                Text("Detail from Fifth")
                    .navigationToolbarTitle("Fifth Detail")
            }
        }
        .navigationToolbarTitle("Fifth")
        .tabItem { Label("Fifth", systemImage: "5.circle") }

        List {
            NavigationLink("Push detail") {
                Text("Detail from Sixth")
                    .navigationToolbarTitle("Sixth Detail")
            }
        }
        .navigationToolbarTitle("Sixth")
        .tabItem { Label("Sixth", systemImage: "6.circle") }
    }
}
