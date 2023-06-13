//
//  ADScrollView.swift
//  AD_UI
//
//  Created by minii on 2023/06/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

struct ADScrollView<C: View>: View {
  let scrollID = "scrollID"
  var onPreferenceChangeAction: (_ currentOffset: CGPoint) -> ()
  var content: C
  @State var lastOffset: CGPoint = .init()
  
  init(
    adScrollAction: @escaping (_ currentOffset: CGPoint) -> (),
    @ViewBuilder content: () -> C
  ) {
    self.onPreferenceChangeAction = adScrollAction
    self.content = content()
  }
  
  init(@ViewBuilder content: () -> C) {
    self.init(adScrollAction: { _ in }, content: { content() })
    self.onPreferenceChangeAction = self.hideStepStatusBar(_:)
  }
  
  var body: some View {
    ScrollView {
      content
        .background(TrackingView())
    }
    .coordinateSpace(name: scrollID)
  }
}

extension ADScrollView {
  @ViewBuilder
  func TrackingView() -> some View {
    HStack {
      VStack {
        GeometryReader { geo in
          Color.clear.preference(
            key: OffsetPreferenceKey.self,
            value: geo.frame(in: .named(scrollID)).origin
          )
        }
        .frame(width: 0, height: 0)
        .onPreferenceChange(
          OffsetPreferenceKey.self,
          perform: onPreferenceChangeAction
        )
        
        Spacer()
      }
      Spacer()
    }
  }
}

extension ADScrollView {
  func hideStepStatusBar(_ currentOffset: CGPoint) {
    let translationY: CGFloat = currentOffset.y - self.lastOffset.y
    if -50 <= translationY && translationY <= 50 {
      return
    }
    if translationY < 0 {
      print("Scroll Down")
      self.lastOffset.y = currentOffset.y
    } else {
      print("Scroll Up")
      self.lastOffset.y = currentOffset.y
    }
  }
}

struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
