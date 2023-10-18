//
//  MakeADButton.swift
//  ADUIKit
//
//  Created by minii on 2023/10/18.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import DomainModel

public struct MakeADButton<C: View>: View {
  @Binding var state: Bool
  let myStep: Step
  let action: () -> ()
  @ViewBuilder let content: () -> C
  
  public init(
    state: Binding<Bool>,
    myStep: Step,
    action: @escaping () -> (),
    content: @escaping () -> C
  ) {
    self._state = state
    self.myStep = myStep
    self.action = action
    self.content = content
  }
  
  public var body: some View {
    ADButton(
      state: state,
      action: action,
      content: content
    )
    .receiveShared(\.shared.stepBar.completeStep) { completeStep in
      DispatchQueue.main.async {
        state = state && myStep.rawValue <= completeStep.rawValue + 1
      }
    }
  }
}
