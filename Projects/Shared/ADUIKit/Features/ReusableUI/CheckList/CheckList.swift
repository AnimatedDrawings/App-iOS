//
//  CheckList.swift
//  AD_UI
//
//  Created by minii on 2023/06/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADResources

public struct CheckList<C: View>: View {
  let CheckListContent: C
  let myStep: Int
  let completeStep: Int
  var isCorrectStep: Bool {
    myStep <= completeStep + 1
  }
  
  var alertText: String {
    return isCorrectStep ? "Read & Check" : "Complete Previous Step"
  }
  var alertColor: Color {
    return isCorrectStep ?
    ADResourcesAsset.Color.blue1.swiftUIColor :
    ADResourcesAsset.Color.red1.swiftUIColor
  }
  
  var isDisableContent: Bool {
    return !isCorrectStep
  }
  
  public init(
    myStep: Int,
    completeStep: Int,
    @ViewBuilder CheckListContent: () -> C
  ) {
    self.myStep = myStep
    self.completeStep = completeStep
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
  struct Title: View {
    let title = "C H E C K L I S T"
    
    var body: some View {
      Text(title)
        .font(.system(.title3, weight: .semibold))
        .foregroundColor(.black)
    }
  }
}
