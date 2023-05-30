//
//  UploadADrawingView.swift
//  AD_OnBoarding
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

public struct UploadADrawingView: ADUI {
  public init() {}
}

extension UploadADrawingView {
  @ViewBuilder
  public func Main(
    uploadAction: @escaping ADAction,
    sampleTapAction: @escaping ADAction
  ) -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Title()
        CheckList()
        UploadButton(action: uploadAction)
        
        SampleDrawingsDescription()
        SampleImages(cardAction1: sampleTapAction)
        
        Spacer()
      }
      .padding()
    }
    .background(ADBackground())
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func Title() -> some View {
    let title = "UPLOAD A DRAWING"
    let left = "Upload a drawing of"
    let one = " ONE "
    let right = "character, where the arms and legs don’t overlap the body (see examples below)."
    
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      
      Text(left) + Text(one).fontWeight(.bold) + Text(right)
    }
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
    let checkmarkCircle = "checkmark.circle"
    
    HStack(alignment: .top) {
      Image(systemName: checkmarkCircle)
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      Text(description)
    }
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func UploadButton(action: @escaping () -> ()) -> some View {
    let photoFill = "photo.fill"
    let text = "Upload Photo"
    
    ADButton(action: action) {
      HStack {
        Image(systemName: photoFill)
        Text(text)
      }
    }
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func SampleDrawingsDescription() -> some View {
    let leftTitle = "S A M P L E"
    let rightTitle = "D R A W I N G S"
    let description = "Feel free to try the demo by clicking on one of the following example images."
    
    VStack(alignment: .leading, spacing: 15) {
      HStack(spacing: 15) {
        Text(leftTitle)
          .font(.system(.title3, weight: .medium))
        Text(rightTitle)
          .font(.system(.title3, weight: .medium))
      }
      Text(description)
    }
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func SampleImages(cardAction1: @escaping ADAction) -> some View {
    VStack(spacing: 20) {
      HStack(spacing: 20) {
        ImageCardButton(action: cardAction1)
        ImageCardButton(action: cardAction1)
      }
      HStack(spacing: 20) {
        ImageCardButton(action: cardAction1)
        ImageCardButton(action: cardAction1)
      }
    }
    .frame(height: 450)
  }
  
  @ViewBuilder
  func ImageCardButton(action: @escaping ADAction) -> some View {
    Button(action: action) {
      ADUtilsAsset.SampleDrawing.garlic.swiftUIImage
        .resizable()
        .mask {
          RoundedRectangle(cornerRadius: 15)
        }
    }
  }
}

struct UploadADrawingView_Previews: PreviewProvider {
  static var previews: some View {
    let ui = UploadADrawingView()
    
    ui.Main(
      uploadAction: {},
      sampleTapAction: {}
    )
  }
}
