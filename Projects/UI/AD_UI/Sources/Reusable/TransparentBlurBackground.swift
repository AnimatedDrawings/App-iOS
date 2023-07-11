//
//  TransparentBlurBackground.swift
//  AD_UI
//
//  Created by minii on 2023/07/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

extension View {
  func transparentBlurBackground(
    effect: UIVisualEffect? = UIBlurEffect(style: .regular)
  ) -> some View {
    self.modifier(VisualEffectViewModifier(effect: effect))
  }
}

struct VisualEffectViewModifier: ViewModifier {
  let effect: UIVisualEffect?
  
  func body(content: Content) -> some View {
    ZStack {
      VisualEffectView(effect: effect)
        .edgesIgnoringSafeArea(.all)
      
      content
        .clearModalBackground()
    }
  }
}

struct VisualEffectView: UIViewRepresentable {
  typealias UIViewType = UIVisualEffectView
  let effect: UIVisualEffect?
  
  func makeUIView(context: Context) -> UIVisualEffectView {
    let view = UIVisualEffectView()
    return view
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = effect
  }
}
