//
//  CheckList.swift
//  AD_UI
//
//  Created by minii on 2023/06/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public struct CheckList<C: View>: View {
  let isCorrectStep: Bool
  let CheckListContent: C
  
  let title = "C H E C K L I S T"
  var alertText: String {
    return isCorrectStep ? "Read & Check" : "Complete Previous Step"
  }
  var isDisableContent: Bool {
    return !isCorrectStep
  }
  
  public init(
    isCorrectStep: Bool,
    @ViewBuilder content: () -> C
  ) {
    self.isCorrectStep = isCorrectStep
    self.CheckListContent = content()
  }
  
  public var body: some View {
    VStack(alignment:.leading, spacing: 15) {
      HStack {
        Title()
        FloatingAlert(alertText)
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
