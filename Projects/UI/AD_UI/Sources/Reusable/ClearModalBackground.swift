//
//  ClearModalBackground.swift
//  AD_UI
//
//  Created by minii on 2023/07/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

extension View {
  func clearModalBackground() -> some View {
    self.modifier(ClearBackgroundViewModifier())
  }
}

struct ClearBackgroundView: UIViewRepresentable {
  func makeUIView(context: Context) -> some UIView {
    let view = UIView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }
  func updateUIView(_ uiView: UIViewType, context: Context) {
  }
}

struct ClearBackgroundViewModifier: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 16.4, *) {
      content
        .presentationBackground(.clear)
    } else {
      content
        .background(ClearBackgroundView())
    }
  }
}
