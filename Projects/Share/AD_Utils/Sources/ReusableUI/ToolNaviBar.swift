//
//  ToolNaviBar.swift
//  AD_UI
//
//  Created by minii on 2023/07/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public struct ToolNaviBar: View {
  let cancelAction: () -> ()
  let saveAction: () -> ()
  
  let strokeColor: Color = ADUtilsAsset.Color.blue1.swiftUIColor
  let height: CGFloat = 40
  
  public init(
    cancelAction: @escaping () -> Void,
    saveAction: @escaping () -> Void
  ) {
    self.cancelAction = cancelAction
    self.saveAction = saveAction
  }
  
  public var body: some View {
    HStack {
      Cancel()
      Spacer()
      Save()
    }
    .frame(height: height)
  }
}

extension ToolNaviBar {
  @ViewBuilder
  func Save() -> some View {
    let imageName = "square.and.arrow.down"
    
    ToolBarItem(imageName, action: saveAction)
  }
  
  @ViewBuilder
  func Cancel() -> some View {
    let imageName = "x.circle"
    
    ToolBarItem(imageName, action: cancelAction)
  }
}

extension ToolNaviBar {
  @ViewBuilder
  func ToolBarItem(
    _ imageName: String,
    action: @escaping () -> ()
  ) -> some View {
    Button(action: action) {
      Image(systemName: imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .fontWeight(.semibold)
        .foregroundColor(strokeColor)
    }
  }
}

struct Previews_ToolNaviBar: View {
  var body: some View {
    VStack {
      ToolNaviBar(
        cancelAction: {},
        saveAction: {}
      )
    }
    .padding()
  }
}

struct ToolNaviBar_Previews: PreviewProvider {
  static var previews: some View {
    Previews_ToolNaviBar()
  }
}
