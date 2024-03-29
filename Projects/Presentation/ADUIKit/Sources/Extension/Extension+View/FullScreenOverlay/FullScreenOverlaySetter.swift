//
//  FullScreenOverlaySetter.swift
//  AD_Utils
//
//  Created by minii on 2023/07/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

struct FullScreenOverlaySetter<Overlay: View>: ViewModifier {
  
  var overlay: Overlay
  var presentationSpace: PresentationSpace
  
  @State private var id: UUID = .init()
  @State private var isAppearing: Bool = false
  
  func body(content: Content) -> some View {
    return content
      .onAppear { isAppearing = true; updateOverlay() }
      .onDisappear { isAppearing = false; removeOverlay() }
      .onUpdate { isAppearing ? updateOverlay() : removeOverlay() }
    // onDisappear 이후에 onUpdate가 실행되는 경우도 있기 때문에, isAppearing 상태를 저장해 오버레이가 다시 추가되는 것을 방지한다.
  }
  
  private func updateOverlay() {
    FullScreenOverlayContainer.shared.updateOverlay(overlay, for: id, in: presentationSpace)
  }
  
  private func removeOverlay() {
    FullScreenOverlayContainer.shared.removeOverlay(for: id, in: presentationSpace)
  }
}

private extension View {
  func onUpdate(perform action: (() -> Void)? = nil) -> some View {
    if let action = action {
      DispatchQueue.main.async(execute: action)
    }
    return self
  }
}

