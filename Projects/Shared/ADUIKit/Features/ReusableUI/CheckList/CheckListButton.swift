//
//  CheckListButton.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADResources

public struct CheckListButton: View {
  @Binding var state: Bool
  let checkmarkCircle = "checkmark.circle"
  let description: String
  
  public init(
    description: String,
    state: Binding<Bool>
  ) {
    self.description = description
    self._state = state
  }
  
  public var body: some View {
    Button {
      state.toggle()
    } label: {
      HStack(alignment: .top) {
        Image(systemName: checkmarkCircle)
          .foregroundColor(
            state ? ADResourcesAsset.Color.blue2.swiftUIColor : .black.opacity(0.4)
          )
        Text(description)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
          .strikethrough(state)
      }
    }
  }
}
