//
//  Plan.Image.swift
//  BFWViews
//
//  Created by Tom Brodhurst-Hill on 8/5/2023.
//  Copyright © 2023 BareFeetWare. All rights reserved.
//

import SwiftUI
import AVKit

extension Plan {
    public struct Image {
        public let source: Source
        public let width: CGFloat?
        public let foregroundColor: Color?
        public let backgroundColor: Color?
        public let cornerRadius: CGFloat
        public let zoomedURL: URL?
        
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
        
        public enum Source {
            case space
            case uiImage(UIImage)
            case url(URL, caching: Fetch.Caching)
            case system(
                symbol: ImageSymbol,
                variableValue: Double? = nil,
                variants: SymbolVariants = .none,
                scale: SwiftUI.Image.Scale = .medium
            )
        }
    }
}

// MARK: - Convenience Inits

extension Plan.Image {
    
}

// MARK: - Static Instances

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
    
    static func symbol(
        _ symbol: ImageSymbol,
        variableValue: Double? = nil,
        variants: SymbolVariants = .none,
        scale: SwiftUI.Image.Scale = .medium,
        width: CGFloat? = nil,
        foregroundColor: Color? = nil
    ) -> Self {
        .init(
            source: .system(
                symbol: symbol,
                variableValue: variableValue,
                variants: variants,
                scale: scale
            ),
            width: width,
            foregroundColor: foregroundColor,
            zoomedURL: nil
        )
    }
    
}

// MARK: - Functions

public extension Plan.Image {
    
    func with(width: CGFloat?) -> Self {
        .init(
            source: source,
            width: width,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            zoomedURL: zoomedURL
        )
    }
    
    func with(variableValue: Double?) -> Self {
        switch source {
        case let .system(symbol, _, variants, scale):
                .init(source: .system(symbol: symbol, variableValue: variableValue, variants: variants, scale: scale))
        default:
            self
        }
    }
    
}

// MARK: - Private Functions

private extension Plan.Image {
    
    var isZoomedVideo: Bool {
        // TODO: More robust test.
        zoomedURL?.pathExtension == "mp4"
    }
    
    var playImage: Plan.Image? {
        guard isZoomedVideo else { return nil }
        return Plan.Image(
            source: .system(
                symbol: .play,
                variants: .circle.fill,
                scale: .large
            )
        )
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

// MARK: - Private Extensions

private extension Image {
    
    func formattedResizedFit(planImage: Plan.Image) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ifLet(planImage.foregroundColor) { foregroundColor, view in
                view.foregroundColor(foregroundColor)
            }
    }
}

// MARK: - Views

extension Plan.Image: View {
    public var body: some View {
        Group {
            if let zoomedURL {
                imageView
                    .overlay(
                        playImage?
                            .colorScheme(.dark)
                            .opacity(0.5)
                    )
                    .onTapFullScreenCover {
                        ZoomView {
                            if let avPlayer {
                                VideoPlayer(player: avPlayer)
                                    .onAppear { onAppearVideoPlayer() }
                            } else {
                                Plan.Image(source: .url(zoomedURL, caching: .file))
                            }
                        }
                    }
            } else {
                imageView
            }
        }
        .frame(width: width)
        .frame(minHeight: backgroundColor != nil ? width : 0)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
    }
}

private extension Plan.Image {
    
    @ViewBuilder
    var imageView: some View {
        switch source {
        case .space:
            Rectangle()
                .foregroundColor(backgroundColor ?? .clear)
                .frame(width: width)
                .frame(minHeight: backgroundColor != nil ? width : 0)
                .cornerRadius(cornerRadius)
        case .uiImage(let uiImage):
            Image(uiImage: uiImage)
                .formattedResizedFit(planImage: self)
        case .url(let url, let caching):
            AsyncImage(
                url: url,
                caching: caching
            ) {
                $0.formattedResizedFit(planImage: self)
            } placeholder: {
                ProgressView()
            }
        case let .system(symbol, variableValue, variant, scale):
            Image(symbol: symbol, variableValue: variableValue)
                .symbolVariant(variant)
                .imageScale(scale)
                .ifLet(foregroundColor) { foregroundColor, view in
                    view.foregroundColor(foregroundColor)
                }
        }
    }
}

// MARK: - Previews

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

extension Plan.Image: PreviewProvider {
    public static var previews: some View {
        Plan.Image.preview
    }
}

struct PlanImage_Preview: PreviewProvider {
    static var previews: some View {
        Plan.Image.preview
    }
}
