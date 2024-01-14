//
//  CheckList.swift
//  AD_UI
//
//  Created by minii on 2023/06/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import SharedProvider
import DomainModel
import ADUIKitResources

public struct CheckList<C: View>: View {
  let CheckListContent: C
  let myStep: Step
  @SharedValue(\.shared.stepBar.completeStep) var completeStep
  var isCorrectStep: Bool {
    myStep.rawValue <= completeStep.rawValue + 1
  }
  
  let title = "C H E C K L I S T"
  var alertText: String {
    return isCorrectStep ? "Read & Check" : "Complete Previous Step"
  }
  var alertColor: Color {
    return isCorrectStep ?
    ADUIKitResourcesAsset.Color.blue1.swiftUIColor :
    ADUIKitResourcesAsset.Color.red1.swiftUIColor
  }
  
  var isDisableContent: Bool {
    return !isCorrectStep
  }
  
  public init(
    myStep: Step,
    @ViewBuilder CheckListContent: () -> C
  ) {
    self.myStep = myStep
    self.CheckListContent = CheckListContent()
  }
  
  public var body: some View {
    VStack(alignment:.leading, spacing: 15) {
      HStack {
        Title()
        FloatingAlert(text: alertText, color: alertColor)
          .reload(isCorrectStep)
      }
      CheckListContent
        .disabled(isDisableContent)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

extension CheckList {
  @ViewBuilder
  func Title() -> some View {
    Text(title)
      .font(.system(.title3, weight: .semibold))
      .foregroundColor(.black)
  }
}
