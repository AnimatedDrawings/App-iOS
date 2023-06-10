//
//  MakeADView.swift
//  AD_UI
//
//  Created by minii on 2023/06/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture

struct MakeADView: ADUI {
  typealias MyReducer = MakeADStore
  typealias MyViewStore = ViewStore<MyReducer.State, MyReducer.Action>
  let store: StoreOf<MyReducer>
  
  init(
    store: StoreOf<MyReducer> = Store(
      initialState: MyReducer.State(),
      reducer: MyReducer()
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        StepStatusBar(curIdx: viewStore.curStep.rawValue)
          .padding()
        
        UploadADrawingView()
      }
    }
  }
}

struct MakeADView_Previews: PreviewProvider {
  static var previews: some View {
    MakeADView()
  }
}
