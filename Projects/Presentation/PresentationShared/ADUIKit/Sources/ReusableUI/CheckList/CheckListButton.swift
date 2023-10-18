//
//  CheckListButton.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import DomainModel
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
    .if(myStep == .UploadADrawing) {
      $0
    } else: {
      $0.receiveShared(\.shared.stepBar.completeStep) { completeStep in
        DispatchQueue.main.async {
          state = state && myStep.rawValue <= completeStep.rawValue + 1
        }
      }
    }
  }
}
