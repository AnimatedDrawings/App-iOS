//
//  ADButton.swift
//  AD_UI
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

struct ADButton<Content: View>: View {
  var state: ADButtonState
  let action: () -> ()
  @ViewBuilder let label: () -> ADButtonLabel<Content>
  
  init(
    _ state: ADButtonState = .active,
    action: @escaping () -> (),
    content: @escaping () -> Content
  ) {
    self.state = state
    self.action = action
    self.label = { ADButtonLabel(state, content: content) }
  }
  
  init(
    _ state: ADButtonState = .active,
    title: String,
    action: @escaping () -> ()
  ) where Content == AnyView {
    self.state = state
    self.action = action
    self.label = { ADButtonLabel(state, title: title) }
  }
  
  var body: some View {
    Button(action: action, label: label)
  }
}

struct ADButtonLabel<Content: View>: View {
  var state: ADButtonState
  @ViewBuilder let content: () -> Content
  
  init(
    _ state: ADButtonState,
    content: @escaping () -> Content
  ) {
    self.state = state
    self.content = content
  }
  
  init(
    _ state: ADButtonState,
    title: String
  ) where Content == AnyView {
    self.state = state
    self.content = { AnyView(Text(title)) }
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .frame(height: 60)
      .foregroundColor(
        state == .active ?
        ADUtilsAsset.Color.blue1.swiftUIColor :
            .gray
      )
      .shadow(radius: 10)
      .overlay {
        content()
          .foregroundColor(.white)
      }
  }
}

enum ADButtonState {
  case active
  case inActive
}
