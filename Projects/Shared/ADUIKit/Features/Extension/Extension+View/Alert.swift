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
    okAction: @escaping () -> () = {}
  ) -> some View {
    self.alert(
      "Connection Error",
      isPresented: isPresented,
      actions: {
        Button("OK", action: okAction)
      },
      message: {
        Text("Please check device network condition.")
      }
    )
  }
  
  func alertWorkLoadHighError(
    isPresented: Binding<Bool>,
    okAction: @escaping () -> () = {}
  ) -> some View {
    self.alert(
      "The current workload is high.",
      isPresented: isPresented,
      actions: {
        Button("OK", action: okAction)
      },
      message: {
        Text("Too many concurrent users. Please try again later.")
      }
    )
  }
}
