//
//  AsyncNavigationLink.swift
//
//  Created by Tom Brodhurst-Hill on 1/2/21.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

import SwiftUI

/**
 Facilitates:
 1. The cell shows a `>` disclosure indicator.
 2. The user taps the cell. Tap anywhere on the cell.
 3. The cell indicator changes to a ProgressView.
 4. The app performs the action, such as a fetch.
 5. When the action completes, the indicator changes back to a disclosure indicator.
 6. If isActive changes to true (eg if the action was successful), the app moves forward to the destination scene.
 7. If isActive does not change to false (eg if the action failed), it does not move forward. No error shown yet.
 */
public struct AsyncNavigationLink<Destination: View, Label: View> {
    let destination: Destination
    var hasDisclosureIndicator: Bool
    @Binding var isActive: Bool
    @Binding var isInProgress: Bool
    let action: () -> Void
    let label: () -> Label
    
    public init(
        destination: Destination,
        hasDisclosureIndicator: Bool = true,
        isActive: Binding<Bool>,
        isInProgress: Binding<Bool>,
        action: @escaping () -> Void,
        label: @escaping () -> Label
    ) {
        self.destination = destination
        self.hasDisclosureIndicator = hasDisclosureIndicator
        self._isActive = isActive
        self._isInProgress = isInProgress
        self.action = action
        self.label = label
    }
    
    // TODO: Add an init for Button, incorporating the action.
}

private extension AsyncNavigationLink {
    
    var isOverlayedProgress: Bool {
        !hasDisclosureIndicator && isInProgress
    }
    
}

extension AsyncNavigationLink: View {
    public var body: some View {
        HStack {
            label()
                .brightness(isOverlayedProgress ? 0.3 : 0)
                .disabled(isOverlayedProgress)
                .overlay(isOverlayedProgress ? ProgressView() : nil)
            if hasDisclosureIndicator {
                CompressibleSpacer()
                if isInProgress {
                    ProgressView()
                } else {
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .foregroundColor(.secondary)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isInProgress = true
            action()
        }
        .background(
            NavigationLink(
                destination: destination,
                isActive: $isActive,
                label: { Text("Hidden") }
            )
            .hidden()
            .disabled(true)
        )
    }
}

struct AsyncNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section(header: Text("Not yet started")
                ) {
                    AsyncNavigationLink(
                        destination: Text("Destination"),
                        hasDisclosureIndicator: true,
                        isActive: .constant(false),
                        isInProgress: .constant(false),
                        action: {},
                        label: { Text("Disclosure") }
                    )
                    AsyncNavigationLink(
                        destination: Text("Destination"),
                        hasDisclosureIndicator: false,
                        isActive: .constant(false),
                        isInProgress: .constant(false),
                        action: {},
                        label: {
                            Text("Action")
                                .foregroundColor(.accentColor)
                        }
                    )
                }
                Section(header: Text("In Progress")
                ) {
                    AsyncNavigationLink(
                        destination: Text("Destination"),
                        hasDisclosureIndicator: true,
                        isActive: .constant(false),
                        isInProgress: .constant(true),
                        action: {},
                        label: { Text("Disclosure") }
                    )
                    AsyncNavigationLink(
                        destination: Text("Destination"),
                        hasDisclosureIndicator: false,
                        isActive: .constant(false),
                        isInProgress: .constant(true),
                        action: {},
                        label: {
                            Text("Action")
                                .foregroundColor(.accentColor)
                        }
                    )
                }
            }
            .navigationBarItems(
                trailing: AsyncNavigationLink(
                    destination: Text("Next"),
                    hasDisclosureIndicator: false,
                    isActive: .constant(false),
                    isInProgress: .constant(false),
                    action: {},
                    label: {
                        Text("Next")
                            .foregroundColor(.accentColor)
                    }
                )
            )
        }
    }
}
