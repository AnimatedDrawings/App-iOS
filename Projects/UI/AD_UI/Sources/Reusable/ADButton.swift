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
  var state: ADButton.State
  private let action: () -> ()
  private let label: ButtonLabel
  
  public init(
    _ state: ADButton.State = .active,
    action: @escaping () -> (),
    @ViewBuilder label: () -> ButtonLabel
  ) {
    self.state = state
    self.action = action
    self.label = label()
  }
  
  public init(
    _ name: String,
    _ state: ADButton.State = .active,
    action: @escaping () -> ()
  ) where ButtonLabel == AnyView {
    self.state = state
    self.action = action
    self.label = AnyView(
      Text(name)
    )
  }
  
  public var body: some View {
    Button(action: action) {
      RoundedRectangle(cornerRadius: 10)
        .frame(height: 60)
        .foregroundColor(
          state == .active ?
          ADUtilsAsset.Color.blue1.swiftUIColor :
              .gray
        )
        .shadow(radius: 10)
        .overlay {
          label
            .foregroundColor(.white)
        }
    }
    .disabled(state == .inActive)
  }
}

extension ADButton {
  public enum State {
    case active
    case inActive
  }
}
