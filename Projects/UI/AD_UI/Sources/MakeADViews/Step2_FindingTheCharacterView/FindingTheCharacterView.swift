//
//  FindingTheCharacterView.swift
//  AD_UI
//
//  Created by minii on 2023/06/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

public struct FindingTheCharacterView: ADUI {
  public init () {}
}

extension FindingTheCharacterView {
  @ViewBuilder
  public func Main(
    originalImage: UIImage,
    checkState: Binding<Bool>,
    checkAction: @escaping ADAction
  ) -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Title()
        CheckList(checkState: checkState, checkAction: checkAction)
        
        Preview()
        
        CropImageView(originalImage: originalImage)
          .scrollDisabled(true)
        
        Spacer()
      }
      .padding()
    }
    .background(ADBackground())
  }
}

extension FindingTheCharacterView {
  @ViewBuilder
  func Title() -> some View {
    let title = "FINDING THE CHARACTER"
    let description = "We’ve identified the character, and put a box around it."
    
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      
      Text(description)
    }
  }
}

extension FindingTheCharacterView {
  @ViewBuilder
  func CheckList(
    checkState: Binding<Bool>,
    checkAction: @escaping ADAction
  ) -> some View {
    let title = "C H E C K L I S T"
    let description = "Resize the box to ensure it tightly fits one character."
    
    VStack(alignment: .leading, spacing: 15) {
      Text(title)
        .font(.system(.title3, weight: .medium))
      
      CheckListButton(description, state: checkState, action: checkAction)
    }
  }
}

extension FindingTheCharacterView {
  @ViewBuilder
  func Preview() -> some View {
    HStack {
      GIFView(gifName: "FindingTheCharacter_Preview1")
      GIFView(gifName: "FindingTheCharacter_Preview2")
    }
    .frame(height: 250)
  }
}

public struct PreviewsFindingTheCharacterView: View {
  let ui = FindingTheCharacterView()
  let originalImage: UIImage = ADUtilsAsset.SampleDrawing.garlic.image
  @State var checkState = false
  
  public init() {}
  
  public var body: some View {
    ui.Main(
      originalImage: originalImage,
      checkState: $checkState,
      checkAction: {}
    )
  }
}

struct FindingTheCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    PreviewsFindingTheCharacterView()
  }
}
