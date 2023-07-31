//
//  FindingCharacterJointsView.swift
//  AD_UI
//
//  Created by minii on 2023/07/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture

struct FindingCharacterJointsView: ADUI {
  typealias MyStore = FindingCharacterJointsStore
  let store: StoreOf<MyStore>
  
  init(
    store: StoreOf<MyStore> = Store(
      initialState: MyStore.State(
        sharedState: SharedState(),
        state: FindingCharacterJointsStore.MyState()
      ),
      reducer: MyStore()
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView(viewStore.binding(\.sharedState.$isShowStepStatusBar)) {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList {
            CheckListContent(with: viewStore)
          }
          
          NextStepDescription()
          
          ShowMaskingImageViewButton(state: viewStore.checkState) {
            viewStore.send(.toggleModifyJointsView)
          }
          
          Spacer().frame(height: 20)
        }
        .padding()
      }
      .fullScreenCover(
        isPresented: viewStore.binding(\.$isShowModifyJointsView),
        onDismiss: {},
        content: {
          if let maskedImage = viewStore.sharedState.maskedImage,
             let jointsDTO = viewStore.sharedState.jointsDTO
          {
            ModifyJointsView(
              maskedImage: maskedImage,
              jointsDTO: jointsDTO,
              cancel: { viewStore.send(.toggleModifyJointsView) },
              save: { modifiedJointsDTO in
                viewStore.send(.findCharacterJoints(modifiedJointsDTO))
              }
            )
            .transparentBlurBackground()
            .addLoadingView(isShow: viewStore.state.isShowLoadingView, description: "Modify Character Joints ...")
          }
        }
      )
    }
  }
}

extension FindingCharacterJointsView {
  @ViewBuilder
  func Title() -> some View {
    let title = "FINDING CHARACTER JOINTS"
    let description = "Here are your character's joints! Here's an example of what it should look like"
    let descriptionImage: UIImage = ADUtilsAsset.SampleDrawing.step4Description.image
    
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      
      Text(description)
      
      HStack {
        Spacer()
        Image(uiImage: descriptionImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 200)
        Spacer()
      }
    }
  }
}

extension FindingCharacterJointsView {
  @ViewBuilder
  func CheckListContent(with viewStore: MyViewStore) -> some View {
    let description = "If your character doesn't have any arms, drag the elbows and wrist joints far away from the character and it can still be animated"
    
    VStack(alignment: .leading, spacing: 15) {
      CheckListButton(description, state: viewStore.binding(\.$checkState)) {
        viewStore.send(.checkAction)
      }
      
      GIFView(gifName: "Step4_Preview")
        .frame(height: 250)
    }
  }
}

extension FindingCharacterJointsView {
  @ViewBuilder
  func NextStepDescription() -> some View {
    let description = "In the next step, we’ll use the segmentation mask and these joints locations to animate your character with motion capture data."
    
    Text(description)
  }
}

extension FindingCharacterJointsView {
  @ViewBuilder
  func ShowMaskingImageViewButton(
    state: Bool,
    action: @escaping () -> ()
  ) -> some View {
    let viewFinder = "figure.yoga"
    let text = "Find Character Joints"
    
    ADButton(
      state ? .active : .inActive,
      action: action
    ) {
      HStack {
        Image(systemName: viewFinder)
        Text(text)
      }
    }
  }
}

struct FindingCharacterJointsView_Previews: PreviewProvider {
  static var previews: some View {
    FindingCharacterJointsView()
  }
}
