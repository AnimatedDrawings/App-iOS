//
//  FloatingAnimation.swift
//  AD_Utils
//
//  Created by minii on 2023/08/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

extension View {
  func addFloatingAnimation(dist: Binding<CGFloat>) -> some View {
    self.modifier(FloatingAnimation(dist: dist))
  }
}

struct FloatingAnimation: ViewModifier {
  @Binding var dist: CGFloat
  let timer = Timer.publish(every: 1.1, on: .main, in: .common).autoconnect()
  
  init(dist: Binding<CGFloat>) {
    self._dist = dist
  }
  
  func body(content: Content) -> some View {
    content
      .offset(y: dist)
      .animation(.easeInOut(duration: 0.8), value: self.dist)
      .onReceive(timer) { _ in
        self.dist *= -1
      }
  }
}
