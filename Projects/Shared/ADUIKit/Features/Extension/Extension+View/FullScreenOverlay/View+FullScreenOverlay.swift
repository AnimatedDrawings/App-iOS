//
//  View+FullScreenOverlay.swift
//  AD_Utils
//
//  Created by minii on 2023/07/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public extension View {
  func fullScreenOverlayPresentationSpace<T: Hashable>(name: T) -> some View {
    self.modifier(FullScreenOverlayPresenter(presentationSpace: .named(name)))
  }
  
  func fullScreenOverlayPresentationSpace(_ presentationSpace: PresentationSpace) -> some View {
    self.modifier(FullScreenOverlayPresenter(presentationSpace: presentationSpace))
  }
  
  @ViewBuilder
  func fullScreenOverlay<Overlay: View>(
    presentationSpace: PresentationSpace,
    @ViewBuilder content: () -> Overlay
  ) -> some View {
    self.modifier(FullScreenOverlaySetter(overlay: content(), presentationSpace: presentationSpace))
  }
}
