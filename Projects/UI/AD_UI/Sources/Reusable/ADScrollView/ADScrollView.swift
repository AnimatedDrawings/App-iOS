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
  
  init(
    adScrollAction: @escaping (_ currentOffset: CGPoint) -> (),
    @ViewBuilder content: () -> C
  ) {
    self.onPreferenceChangeAction = adScrollAction
    self.content = content()
  }
  
  var body: some View {
    ScrollView {
      content
        .background(
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
        )
    }
    .coordinateSpace(name: scrollID)
  }
}

public func hideStepStatusBar(
  _ currentOffset: CGPoint,
  lastOffset: Binding<CGPoint>
) -> () {
  let translationY: CGFloat = currentOffset.y - lastOffset.wrappedValue.y
  if -50 <= translationY && translationY <= 50 {
    return
  }
  if translationY < 0 {
    print("Scroll Down")
    lastOffset.wrappedValue.y = currentOffset.y
  } else {
    print("Scroll Up")
    lastOffset.wrappedValue.y = currentOffset.y
  }
}

struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
