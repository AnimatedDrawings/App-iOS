//
//  ADButton.swift
//  AD_UI
//
//  Created by minii on 2023/05/26.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Utils

public struct ADButton<ButtonLabel: View>: View {
  private let action: () -> ()
  private let label: ButtonLabel
  
  public init(
    action: @escaping () -> (),
    @ViewBuilder label: () -> ButtonLabel
  ) {
    self.action = action
    self.label = label()
  }
  
  public init(
    _ name: String,
    action: @escaping () -> ()
  ) where ButtonLabel == AnyView {
    self.action = action
    self.label = AnyView(
      Text(name)
    )
  }
  
  public var body: some View {
    Button(action: action) {
      RoundedRectangle(cornerRadius: 10)
        .padding(.horizontal, 20)
        .frame(height: 60)
        .foregroundColor(ADUtilsAsset.Color.blue1.swiftUIColor)
        .shadow(radius: 10)
        .overlay {
          label
            .foregroundColor(.white)
        }
    }
  }
}
