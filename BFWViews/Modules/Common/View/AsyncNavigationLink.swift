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
    @Binding var isActive: Bool
    let destination: () -> Destination
    let label: () -> Label
    let action: (() -> Void)?
    @State private var isInProgress = false
    
    public init(
        isActive: Binding<Bool>,
        destination: @escaping () -> Destination,
        label: @escaping () -> Label,
        action: (() -> Void)?
    ) {
        self._isActive = isActive
        self.destination = destination
        self.label = label
        self.action = action
    }
    
}

extension AsyncNavigationLink: View {
    public var body: some View {
        Group {
            if let action = action {
                Button {
                    isInProgress = true
                    action()
                } label: {
                    ZStack {
                        HStack {
                            label()
                            Spacer()
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        .opacity(isInProgress ? 1 : 0)
                        NavigationLink(
                            isActive: $isActive,
                            destination: destination,
                            label: label
                        )
                        .opacity(isInProgress ? 0 : 1)
                    }
                }
            } else {
                label()
            }
        }
        .foregroundColor(.primary)
        .onChange(of: isActive) { isActive in
            if isActive {
                isInProgress = false
            }
        }
    }
}

struct AsyncNavigationLink_Previews: PreviewProvider {
    
    struct PreviewScene: View {
        
        @State private var isActive = false
        
        var body: some View {
            NavigationView {
                List {
                    AsyncNavigationLink(
                        isActive: $isActive,
                        destination: { Text("Destination") },
                        label: { Text("Async") },
                        action: {
                            DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(1))) {
                                isActive = true
                            }
                        }
                    )
                }
            }
        }
    }
    
    static var previews: some View {
        PreviewScene()
    }
}
