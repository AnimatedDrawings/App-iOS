//
//  Alert.swift
//  ADUIKit
//
//  Created by minii on 2023/10/19.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public extension View {
  func alertNetworkError(
    isPresented: Binding<Bool>,
    cancelAction: @escaping () -> () = {}
  ) -> some View {
    self.alert(
      "Connection Error",
      isPresented: isPresented,
      actions: {
        Button("Cancel", action: cancelAction)
      },
      message: {
        Text("Please check device network condition.")
      }
    )
  }
}
