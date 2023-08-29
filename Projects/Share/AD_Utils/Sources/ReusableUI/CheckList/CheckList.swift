//
//  CheckList.swift
//  AD_UI
//
//  Created by minii on 2023/06/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public struct CheckList<C: View>: View {
  let myStepIdx: Int
  let completeStepIdx: Int
  let CheckListContent: C
  
  let title = "C H E C K L I S T"
  var alertText: String {
    switch (myStepIdx, completeStepIdx) {
    case let (x, y) where y + 1 < x:
      return "Complete previous step"
    default:
      return "Read & Check"
    }
  }
  
  public init(
    myStep myStepIdx: Int,
    completeStep completeStepIdx: Int,
    @ViewBuilder content: () -> C
  ) {
    self.myStepIdx = myStepIdx
    self.completeStepIdx = completeStepIdx
    self.CheckListContent = content()
  }
  
  public var body: some View {
    VStack(alignment:.leading, spacing: 15) {
      HStack {
        Title()
        FloatingAlert(alertText)
      }
      CheckListContent
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

extension CheckList {
  @ViewBuilder
  func Title() -> some View {
    Text(title)
      .font(.system(.title3, weight: .medium))
      .foregroundColor(.black)
  }
}
