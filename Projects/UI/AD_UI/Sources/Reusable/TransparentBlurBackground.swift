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
    effect: UIVisualEffect? = UIBlurEffect(style: .regular),
    intensity: CGFloat = 1
  ) -> some View {
    self.modifier(VisualEffectViewModifier(effect: effect, intensity: intensity))
  }
}

struct VisualEffectViewModifier: ViewModifier {
  let effect: UIVisualEffect?
  let intensity: CGFloat
  
  func body(content: Content) -> some View {
    ZStack {
      VisualEffectView(effect: effect, intensity: intensity)
        .edgesIgnoringSafeArea(.all)
      
      content
        .clearBackground()
    }
  }
}

struct VisualEffectView: UIViewRepresentable {
  typealias UIViewType = ADBlurEffectView
  let effect: UIVisualEffect?
  let intensity: CGFloat
  
  func makeUIView(context: Context) -> ADBlurEffectView {
    let blurView = ADBlurEffectView(effect: effect, intensity: intensity)
    return blurView
  }
  
  func updateUIView(_ uiView: ADBlurEffectView, context: Context) {
    uiView.effect = effect
  }
}

class ADBlurEffectView: UIVisualEffectView {
  var intensity: CGFloat
  var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
  
  init(
    effect: UIVisualEffect?,
    intensity: CGFloat
  ) {
    self.intensity = intensity
    super.init(effect: effect)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didMoveToSuperview() {
    guard let superview = superview else { return }
    backgroundColor = .clear
    frame = superview.bounds //Or setup constraints instead
    setupBlur()
  }
  
  private func setupBlur() {
    animator.stopAnimation(true)
    effect = nil
    
    animator.addAnimations { [weak self] in
      self?.effect = UIBlurEffect(style: .dark)
    }
    animator.fractionComplete = self.intensity  //This is your blur intensity in range 0 - 1
  }
  
  deinit {
    animator.stopAnimation(true)
  }
}

//struct VisualEffectView: UIViewRepresentable {
//  typealias UIViewType = UIVisualEffectView
//  let effect: UIVisualEffect?
//
//  func makeUIView(context: Context) -> UIVisualEffectView {
//    let view = UIVisualEffectView()
//    return view
//  }
//
//  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
//    uiView.effect = effect
//  }
//}
