//
//  CheckList.swift
//  AD_UI
//
//  Created by minii on 2023/06/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public struct CheckList<C: View>: View {
  let title = "C H E C K L I S T"
  let CheckListContent: C
  
  public init(@ViewBuilder content: () -> C) {
    self.CheckListContent = content()
  }
  
  public var body: some View {
    VStack(alignment:.leading, spacing: 15) {
      Title()
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
