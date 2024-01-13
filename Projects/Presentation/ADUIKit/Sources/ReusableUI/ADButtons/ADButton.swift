//
//  ADButton.swift
//  AD_UI
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitResources

public struct ADButton<Content: View>: View {
  var state: Bool
  let action: () -> ()
  @ViewBuilder let label: () -> ADButtonLabel<Content>
  
  public init(
    state: Bool = true,
    action: @escaping () -> (),
    content: @escaping () -> Content
  ) {
    self.state = state
    self.action = action
    self.label = { ADButtonLabel(state, content: content) }
  }
  
  public init(
    state: Bool = true,
    title: String,
    action: @escaping () -> ()
  ) where Content == AnyView {
    self.state = state
    self.action = action
    self.label = { ADButtonLabel(state: state, title: title) }
  }
  
  public var body: some View {
    Button(action: action, label: label)
      .disabled(!state)
  }
}

public struct ADButtonLabel<Content: View>: View {
  var state: Bool
  @ViewBuilder let content: () -> Content
  
  public init(
    _ state: Bool,
    content: @escaping () -> Content
  ) {
    self.state = state
    self.content = content
  }
  
  public init(
    state: Bool,
    title: String
  ) where Content == AnyView {
    self.state = state
    self.content = { AnyView(Text(title)) }
  }
  
  public var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .frame(height: 60)
      .foregroundColor(
        state ? ADUIKitResourcesAsset.Color.blue1.swiftUIColor : .gray
      )
      .shadow(radius: 10)
      .overlay {
        content()
          .foregroundColor(.white)
      }
  }
}
