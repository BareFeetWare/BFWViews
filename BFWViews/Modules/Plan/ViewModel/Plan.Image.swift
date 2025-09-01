//
//  Plan.Image.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 4/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import Foundation
import SwiftUI
import AVKit

extension Plan {
    public struct Image {
        
        public init(
            source: Source,
            width: CGFloat? = nil,
            foregroundColor: Color? = nil,
            backgroundColor: Color? = nil,
            cornerRadius: CGFloat = 0,
            zoomedURL: URL? = nil
        ) {
            self.source = source
            self.width = width
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.zoomedURL = zoomedURL
        }
        
        public let source: Source
        public let width: CGFloat?
        public let foregroundColor: Color?
        public let backgroundColor: Color?
        public let cornerRadius: CGFloat
        public let zoomedURL: URL?
        
        public enum Source {
            case space
            case uiImage(UIImage)
            case url(URL, caching: Fetch.Caching)
            case system(
                symbol: ImageSymbol,
                variants: SymbolVariants = .none,
                scale: SwiftUI.Image.Scale = .medium
            )
        }
    }
}

public extension Plan.Image {
    
    static func space(
        width: CGFloat? = nil
    ) -> Self {
        self.init(
            source: .space,
            width: width,
            zoomedURL: nil
        )
    }
    
    static func url(
        _ url: URL,
        caching: Fetch.Caching,
        width: CGFloat? = nil,
        foregroundColor: Color? = nil,
        cornerRadius: CGFloat = 0,
        zoomedURL: URL? = nil
    ) -> Self {
        self.init(
            source: .url(url, caching: caching),
            width: width,
            foregroundColor: foregroundColor,
            cornerRadius: cornerRadius,
            zoomedURL: zoomedURL
        )
    }
    
    static func system(
        symbol: ImageSymbol,
        variants: SymbolVariants = .none,
        scale: SwiftUI.Image.Scale = .medium,
        width: CGFloat? = nil,
        foregroundColor: Color? = nil
    ) -> Self {
        .init(
            source: .system(
                symbol: symbol,
                variants: variants,
                scale: scale
            ),
            width: width,
            foregroundColor: foregroundColor,
            zoomedURL: nil
        )
    }
    
    func withWidth(_ width: CGFloat?) -> Self {
        .init(
            source: source,
            width: width,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            zoomedURL: zoomedURL
        )
    }
    
}

// MARK - For the view.

extension Plan.Image {
    
    var isZoomedVideo: Bool {
        // TODO: More robust test.
        zoomedURL?.pathExtension == "mp4"
    }
    
    var playImage: Plan.Image? {
        guard isZoomedVideo else { return nil }
        return Plan.Image(source: .system(symbol: .play, variants: .circle.fill, scale: .large))
    }
    
    var avPlayer: AVPlayer? {
        guard isZoomedVideo else { return nil }
        return zoomedURL.map {
            AVPlayer(url: $0)
        }
    }
    
    func onAppearVideoPlayer() {
        DispatchQueue.main.async {
            avPlayer?.play()
        }
    }

}

extension Plan.Image {
    static let preview = Plan.Image(
        source: .url(
            URL(string: "https://www.barefeetware.com/logo.png")!,
            caching: .file
        ),
        // TODO: Add video URL.
        zoomedURL: URL(string: "https://www.barefeetware.com/logo.png")
    )
}
