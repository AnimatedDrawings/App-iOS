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
  typealias MyStore = MakeADStore
  typealias MyViewStore = ViewStore<MyStore.State, MyStore.Action>
  let store: StoreOf<MyStore>
  
  init(
    store: StoreOf<MyStore> = Store(
      initialState: MyStore.State(),
      reducer: MyStore()
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

extension MakeADView {
  @ViewBuilder
  func PageTabView() -> some View {
    TabView {
      
    }
  }
}



struct MakeADView_Previews: PreviewProvider {
  static var previews: some View {
    MakeADView()
  }
}
