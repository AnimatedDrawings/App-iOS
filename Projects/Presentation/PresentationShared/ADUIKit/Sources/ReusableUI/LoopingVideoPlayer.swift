//
//  LoopingVideoPlayer.swift
//  AD_Utils
//
//  Created by minii on 2023/08/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AVFoundation

public struct LoopingVideoPlayer: UIViewRepresentable {
  let name: String
  let withExtension: String
  
  public init(name: String, withExtension: String) {
    self.name = name
    self.withExtension = withExtension
  }
  
  public func makeUIView(context: Context) -> UIView {
    return QueuePlayerUIView(name: name, withExtension: withExtension, frame: .zero)
  }
  
  public func updateUIView(_ uiView: UIView, context: Context) {
    // Do nothing here
  }
}

class QueuePlayerUIView: UIView {
  private var playerLayer = AVPlayerLayer()
  private var playerLooper: AVPlayerLooper?
  
  init(
    name: String,
    withExtension: String,
    frame: CGRect
  ) {
    super.init(frame: frame)
    
    // Load Video
    let fileUrl = ADUIKitResources.bundle.url(forResource: name, withExtension: withExtension)!
    let playerItem = AVPlayerItem(url: fileUrl)
    
    // Setup Player
    let player = AVQueuePlayer(playerItem: playerItem)
    playerLayer.player = player
    playerLayer.videoGravity = .resizeAspectFill
    layer.addSublayer(playerLayer)
    
    // Loop
    playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
    
    // Play
    player.play()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer.frame = bounds
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct LoopingPlayer_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      LoopingVideoPlayer(name: "ADApp_Preview", withExtension: "mp4")
    }
    .frame(width: 300, height: 300)
  }
}

