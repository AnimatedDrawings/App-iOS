//
//  CheckListButton.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public struct CheckListButton: View {
  let checkmarkCircle = "checkmark.circle"
  let description: String
  @Binding var state: Bool
  let action: () -> ()
  
  public init(
    _ description: String,
    state: Binding<Bool>,
    action: @escaping () -> ()
  ) {
    self.description = description
    self._state = state
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      HStack(alignment: .top) {
        Image(systemName: checkmarkCircle)
          .foregroundColor(
            state ? ADUtilsAsset.Color.blue2.swiftUIColor : .black.opacity(0.4)
          )
        Text(description)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
          .strikethrough(state)
      }
    }
  }
}

public struct _CheckListButton: View {
  let checkmarkCircle = "checkmark.circle"
  let description: String
  let state: Bool
  let action: () -> ()
  
  public init(
    _ description: String,
    state: Bool,
    action: @escaping () -> ()
  ) {
    self.description = description
    self.state = state
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      HStack(alignment: .top) {
        Image(systemName: checkmarkCircle)
          .foregroundColor(
            state ? ADUtilsAsset.Color.blue2.swiftUIColor : .black.opacity(0.4)
          )
        Text(description)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
          .strikethrough(state)
      }
    }
  }
}
