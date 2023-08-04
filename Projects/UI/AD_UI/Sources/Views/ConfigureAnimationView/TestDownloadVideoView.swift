//
//  TestDownloadVideoView.swift
//  AD_UI
//
//  Created by minii on 2023/08/04.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture

struct TestDownloadVideoView: View {
  let store: StoreOf<TestDownloadVideoFeature>
  
  init(
    store: StoreOf<TestDownloadVideoFeature> = Store(
      initialState: TestDownloadVideoFeature.State()) {
        TestDownloadVideoFeature()
      }
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        Text(viewStore.state.downloadState)
        
        Button {
          viewStore.send(.downloadVideo)
        } label: {
          Text("download image")
        }
        
        if let gifData = viewStore.state.gifData {
          GIFViewData(gifData)
            .frame(width: 200, height: 200)
        }
        
        GIFViewName("dab_preview")
          .frame(width: 200, height: 200)
      }
    }
  }
}

struct MyPreviewProvider_Previews: PreviewProvider {
  static var previews: some View {
    TestDownloadVideoView()
  }
}
