//
//  UploadADrawingView.swift
//  AD_OnBoarding
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

public struct UploadADrawingView: View {
  
  public init() {}
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Title()
      Description()
      CheckList()
    }
    .padding()
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func Title() -> some View {
    let title = "UPLOAD A DRAWING"
    
    Text(title)
      .font(.system(.largeTitle, weight: .semibold))
      .foregroundColor(ADUtilsAsset.blue2.swiftUIColor)
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func Description() -> some View {
    let left = "Upload a drawing of"
    let one = " ONE "
    let right = "character, where the arms and legs don’t overlap the body (see examples below)."

    Text(left) + Text(one).fontWeight(.bold) + Text(right)
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func CheckList() -> some View {
    let title = "C H E C K L I S T"
    let description1 = "Make sure the character is drawn on a white piece of paper without lines, wrinkles, or tears"
    let description2 = "Make sure the drawing is well lit. To minimize shadows, hold the camera further away and zoom in on the drawing."
    let description3 = "Don’t include any identifiable information, offensive content (see our community standards), or drawings that infringe on the copyrights of others."
    
    VStack(alignment: .leading, spacing: 15) {
      Text(title)
        .font(.system(.title3, weight: .medium))
      CheckListDescription(with: description1)
      CheckListDescription(with: description2)
      //      // MARK: "(see our community standards)" 링크추가
      CheckListDescription(with: description3)
    }
  }

  @ViewBuilder
  func CheckListDescription(with description: String) -> some View {
    HStack(alignment: .top) {
      Image(systemName: "checkmark.circle")
        .foregroundColor(ADUtilsAsset.blue2.swiftUIColor)
      Text(description)
    }
  }
}

struct UploadADrawingView_Previews: PreviewProvider {
  static var previews: some View {
    UploadADrawingView()
  }
}
