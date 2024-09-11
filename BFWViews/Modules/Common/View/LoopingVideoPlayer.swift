//
//  LoopingVideoPlayer.swift
//
//  Created by Tom Brodhurst-Hill on 12/9/2024.
//  Copyright © 2021 BareFeetWare. All rights reserved.
//

//  Extracted from BFWViews: https://bitbucket.org/barefeetware/bfwviews/

import SwiftUI
import AVKit

struct LoopingVideoPlayer {
    
    let url: URL
    let isAutoPlay: Bool
    
    private var asset: AVAsset
    private var player: AVQueuePlayer
    private var playerLooper: AVPlayerLooper
    @State private var height: CGFloat = 150
    
    init(url: URL, isAutoPlay: Bool) {
        self.url = url
        self.asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        self.player = AVQueuePlayer(playerItem: item)
        self.playerLooper = AVPlayerLooper(player: player, templateItem: item)
        self.isAutoPlay = isAutoPlay
    }
    
}

extension LoopingVideoPlayer {
    
    var videoSize: CGSize? {
        guard let track = asset.tracks(withMediaType: .video).first
        else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    
    func onAppear() {
        if isAutoPlay {
            player.play()
        }
    }
    
    func onDisappear() {
        player.pause()
    }
    
    func onReadFrame(_ rect: CGRect) {
        guard let videoSize, rect != .zero else { return }
        height = rect.width * videoSize.height / videoSize.width
    }
    
}

// MARK: - Views

extension LoopingVideoPlayer: View {
    var body: some View {
        VideoPlayer(player: player)
            .readFrame { onReadFrame($0) }
            .frame(height: height)
            .onAppear { onAppear() }
            .onDisappear { onDisappear() }
    }
}

#Preview {
    List {
        if let url = URL(string: "https://www.apple.com/105/media/us/airpods/2022/dc1310af-8cb9-4218-8d40-26bbe6a1d307/anim/hero/large_2x.mp4")
        {
            LoopingVideoPlayer(
                url: url,
                isAutoPlay: true
            )
            .listRowInsets(EdgeInsets())
        } else {
            Image(systemName: "video")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(.secondary)
                .padding()
        }
    }
    .navigationTitle("VideoView")
}
