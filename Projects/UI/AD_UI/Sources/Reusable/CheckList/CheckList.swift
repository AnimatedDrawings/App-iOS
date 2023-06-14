//
//  CheckList.swift
//  AD_UI
//
//  Created by minii on 2023/06/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

struct CheckList<C: View>: View {
  let title = "C H E C K L I S T"
  let CheckListContent: C
  @State var isTapTitle: Bool = false
  
  init(@ViewBuilder content: () -> C) {
    self.CheckListContent = content()
  }
  
  var body: some View {
    VStack(alignment:.leading, spacing: 15) {
      Title()
      if self.isTapTitle {
        CheckListContent
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

extension CheckList {
  @ViewBuilder
  func Title() -> some View {
    Button(action: titleAction) {
      Text(title)
        .font(.system(.title3, weight: .medium))
        .foregroundColor(.black)
    }
  }
  
  func titleAction() {
    withAnimation {
      self.isTapTitle.toggle()
    }
  }
}

struct PreviewsCheckList: View {
  func MyRectangle(_ color: Color) -> some View {
    Rectangle()
      .frame(width: 200, height: 200)
      .foregroundColor(color)
  }
  
  var body: some View {
    VStack {
      CheckList {
        MyRectangle(.blue)
        MyRectangle(.red)
        MyRectangle(.green)
      }
      
      Spacer()
    }
    .padding()
  }
}

struct CheckList_Previews: PreviewProvider {
  static var previews: some View {
    PreviewsCheckList()
  }
}
