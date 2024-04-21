//
//  FullScreenOverlayPresenter.swift
//  AD_Utils
//
//  Created by minii on 2023/07/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

struct FullScreenOverlayPresenter: ViewModifier {
  var presentationSpace: PresentationSpace
  
  @ObservedObject private var container: FullScreenOverlayContainer = .shared
  
  func body(content: Content) -> some View {
    content.overlay(
      ZStack {
        ForEach(
          container.overlays[presentationSpace, default: [:]].sorted(by: { $0.key.hashValue < $1.key.hashValue }),
          id: \.key
        ) { _, overlay in
          overlay
        }
      }
    )
  }
}
