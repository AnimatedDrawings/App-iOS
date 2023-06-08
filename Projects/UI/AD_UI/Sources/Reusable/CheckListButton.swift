//
//  CheckListButton.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

struct CheckListButton: View {
  let checkmarkCircle = "checkmark.circle"
  let description: String
  @Binding var state: Bool
  let action: ADAction
  
  init(
    _ description: String,
    state: Binding<Bool>,
    action: @escaping ADAction
  ) {
    self.description = description
    self._state = state
    self.action = action
  }
  
  var body: some View {
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
