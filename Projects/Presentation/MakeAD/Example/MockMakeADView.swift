//
//  MockMakeADView.swift
//  MakeADExample
//
//  Created by chminii on 2/13/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import MakeADFeatures

struct MockMakeADView: View {
  let store = Store(
    initialState: MakeADFeature.State(
      stepBar: .init(
        isShowStepBar: true,
        currentStep: .UploadADrawing,
        completeStep: .UploadADrawing
      )
    )
  ) {
    MakeADFeature()
  }
  
  var body: some View {
    MakeADView(store: store)
  }
}

#Preview {
  MockMakeADView()
}
