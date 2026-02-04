//
//  ShareLink.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 28/1/2026.
//

import SwiftUI
import UIKit

/// Backward compatibility implementation.
public struct ShareLink<Label: View> {
    public let items: [URL]
    public let label: () -> Label
    @State private var isPresented = false
    
    public init(items: [URL], @ViewBuilder label: @escaping () -> Label) {
        self.items = items
        self.label = label
    }
}

// MARK: - Views

extension ShareLink: View {
    public var body: some View {
        if #available(iOS 16.0, *) {
            SwiftUI.ShareLink(items: items, label: label)
        } else {
            Button(
                action: {
                    isPresented = true
                },
                label: label
            )
            .sheet(isPresented: $isPresented) {
                ShareSheet(items: items)
            }
        }
    }
}

// MARK: - Share Sheet (iOS 15.6 fallback)

private struct ShareSheet: UIViewControllerRepresentable {
    let items: [URL]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
