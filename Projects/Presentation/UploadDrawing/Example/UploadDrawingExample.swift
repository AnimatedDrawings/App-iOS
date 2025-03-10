//
//  UploadDrawingExample.swift
//  UploadDrawingExample
//
//  Created by minii on 2023/10/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import NetworkProvider
import NetworkProviderInterfaces
import SwiftUI
import UploadDrawingFeatures

@main
struct UploadDrawingExample: App {
  var body: some Scene {
    WindowGroup {
      UploadDrawingView()
    }
  }
}

struct MockUploadDrawingView: View {
  @Bindable var store: StoreOf<UploadDrawingFeature>

  init() {
    let state = UploadDrawingFeature.State()
    self.store = Store(initialState: state) {
      UploadDrawingFeature()
        .dependency(\.adNetworkProvider, ADNetworkProvider.testValue
        )
    }
  }

  var body: some View {
    UploadDrawingView()
  }
}
