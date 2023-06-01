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
    checkState: Binding<Bool>,
    checkAction: @escaping ADAction
  ) -> some View {
    VStack(alignment: .leading, spacing: 20) {
      Title()
      CheckList(checkState: checkState, checkAction: checkAction)
      Preview()
      
      Spacer()
    }
    .padding()
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
    .frame(maxHeight: 250)
  }
}

struct FindingTheCharacterView_Previews: PreviewProvider {
  struct TestFindingTheCharacterView: View {
    let ui = FindingTheCharacterView()
    @State var checkState = false
    
    var body: some View {
      ui.Main(
        checkState: $checkState,
        checkAction: {}
      )
    }
  }
  
  static var previews: some View {
    TestFindingTheCharacterView()
  }
}
