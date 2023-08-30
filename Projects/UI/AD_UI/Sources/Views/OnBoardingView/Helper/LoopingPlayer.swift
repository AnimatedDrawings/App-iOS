//
//  LoopingPlayer.swift
//  AD_UI
//
//  Created by minii on 2023/05/29.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AVFoundation
import AD_Utils

struct LoopingPlayer: UIViewRepresentable {
  let name: String
  let withExtension: String
  
  func makeUIView(context: Context) -> UIView {
    return QueuePlayerUIView(name: name, withExtension: withExtension, frame: .zero)
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
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
    let fileUrl = ADUtilsResources.bundle.url(forResource: name, withExtension: withExtension)!
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
      LoopingPlayer(name: "ADApp_Preview", withExtension: "mp4")
    }
    .frame(width: 300, height: 300)
  }
}
