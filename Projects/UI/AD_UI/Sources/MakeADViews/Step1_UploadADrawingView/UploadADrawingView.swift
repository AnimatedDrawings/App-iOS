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
    checkState1: Binding<Bool>,
    checkAction1: @escaping ADAction,
    checkState2: Binding<Bool>,
    checkAction2: @escaping ADAction,
    checkState3: Binding<Bool>,
    checkAction3: @escaping ADAction,
    uploadState: Binding<Bool>,
    uploadAction: @escaping ADAction,
    sampleTapAction: @escaping ADAction
  ) -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Title()
        CheckList(
          checkState1: checkState1,
          checkAction1: checkAction1,
          checkState2: checkState2,
          checkAction2: checkAction2,
          checkState3: checkState3,
          checkAction3: checkAction3
        )
        UploadButton(state: uploadState, action: uploadAction)
        
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
  func CheckList(
    checkState1: Binding<Bool>,
    checkAction1: @escaping ADAction,
    checkState2: Binding<Bool>,
    checkAction2: @escaping ADAction,
    checkState3: Binding<Bool>,
    checkAction3: @escaping ADAction
  ) -> some View {
    let title = "C H E C K L I S T"
    let description1 = "Make sure the character is drawn on a white piece of paper without lines, wrinkles, or tears"
    let description2 = "Make sure the drawing is well lit. To minimize shadows, hold the camera further away and zoom in on the drawing."
    let description3 = "Don’t include any identifiable information, offensive content (see our community standards), or drawings that infringe on the copyrights of others."
    
    VStack(alignment: .leading, spacing: 15) {
      Text(title)
        .font(.system(.title3, weight: .medium))
      
      CheckListButton(description1, state: checkState1, action: checkAction1)
      CheckListButton(description2, state: checkState2, action: checkAction2)
      //      //      // MARK: "(see our community standards)" 링크추가
      CheckListButton(description3, state: checkState3, action: checkAction3)
    }
  }
  
  @ViewBuilder
  func CheckListButton(
    _ description: String,
    state: Binding<Bool>,
    action: @escaping ADAction
  ) -> some View {
    let checkmarkCircle = "checkmark.circle"
    
    Button(action: action) {
      HStack(alignment: .top) {
        Image(systemName: checkmarkCircle)
          .foregroundColor(
            state.wrappedValue ?
            ADUtilsAsset.Color.blue2.swiftUIColor :
                .black.opacity(0.4)
          )
        Text(description)
          .foregroundColor(.black)
          .multilineTextAlignment(.leading)
          .strikethrough(state.wrappedValue)
      }
    }
  }
}

extension UploadADrawingView {
  @ViewBuilder
  func UploadButton(
    state: Binding<Bool>,
    action: @escaping () -> ()
  ) -> some View {
    let photoFill = "photo.fill"
    let text = "Upload Photo"
    
    ADButton(
      state.wrappedValue ? .active : .inActive,
      action: action
    ) {
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
  struct TestUploadADrawingView: View {
    let ui = UploadADrawingView()
    @State var checkState1 = false
    @State var checkState2 = false
    @State var checkState3 = false
    @State var uploadState = false
    
    var body: some View {
      ui.Main(
        checkState1: $checkState1,
        checkAction1: { checkState1.toggle() },
        checkState2: $checkState2,
        checkAction2: { checkState2.toggle() },
        checkState3: $checkState3,
        checkAction3: { checkState3.toggle() },
        uploadState: $uploadState,
        uploadAction: { uploadState.toggle() },
        sampleTapAction: {}
      )
    }
  }
  
  static var previews: some View {
    TestUploadADrawingView()
  }
}
