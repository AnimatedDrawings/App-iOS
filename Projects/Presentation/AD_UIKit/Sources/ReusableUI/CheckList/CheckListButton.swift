//
//  CheckListButton.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import Domain_Model
import SharedProvider
import ThirdPartyLib

public struct CheckListButton: View {
  let checkmarkCircle = "checkmark.circle"
  let description: String
  @Binding var state: Bool
  let myStep: Step
  let action: () -> ()
  
  public init(
    description: String,
    state: Binding<Bool>,
    myStep: Step,
    action: @escaping () -> ()
  ) {
    self.description = description
    self._state = state
    self.myStep = myStep
    self.action = action
  }
  
  @Dependency(\.shared.stepBar.completeStep) var completeStep
  
  public var body: some View {
    Button(action: action) {
      HStack(alignment: .top) {
        Image(systemName: checkmarkCircle)
          .foregroundColor(
            state ? ADUIKitAsset.Color.blue2.swiftUIColor : .black.opacity(0.4)
          )
        Text(description)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
          .strikethrough(state)
      }
    }
    .task {
      for await tmpStep in await completeStep.values() {
        state = state && (myStep.rawValue <= tmpStep.rawValue)
      }
    }
  }
}
