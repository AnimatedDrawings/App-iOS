//
//  FindingCharacterJointsView.swift
//  AD_UI
//
//  Created by minii on 2023/07/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import ADUIKit
import FindCharacterJointsFeatures
import ADResources
import DomainModels
import ModifyJoints

public struct FindingCharacterJointsView: View {
  @Perception.Bindable var store: StoreOf<FindCharacterJointsFeature>
  
  public init(
    store: StoreOf<FindCharacterJointsFeature> = Store(
      initialState: .init()
    ) {
      FindCharacterJointsFeature()
    }
  ) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      ADScrollView($store.step.isShowStepBar.sending(\.update.setIsShowStepBar)) {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList(
            myStep: MakeADStep.FindCharacterJoints.rawValue,
            completeStep: store.step.completeStep.rawValue
          ) {
            CheckListContent(checkState: $store.checkState)
          }
          
          NextStepDescription()
          
          ShowMaskingImageViewButton(store.checkState) {
            store.send(.view(.pushModifyJointsView))
          }
          
          Spacer().frame(height: 20)
        }
        .padding()
      }
      .fullScreenCover(
        isPresented: $store.modifyJointsView,
        content: { ifLetModifyJointsView() }
      )
    }
    .task { await store.send(.view(.task)).finish() }
  }
}

private extension FindingCharacterJointsView {
  struct Title: View {
    let title = "FINDING CHARACTER JOINTS"
    let description = "Here are your character's joints! Here's an example of what it should look like"
    let descriptionImage: UIImage = ADResourcesAsset.SampleDrawing.step4Description.image
    let titleColor: Color = ADResourcesAsset.Color.blue2.swiftUIColor
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.title, weight: .semibold))
          .foregroundColor(titleColor)
        
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
}

private extension FindingCharacterJointsView {
  struct CheckListContent: View {
    @Binding var checkState: Bool
    let description = "If your character doesn't have any arms, drag the elbows and wrist joints far away from the character and it can still be animated"
    let myStep: MakeADStep = .FindCharacterJoints
    
    var body: some View {
      VStack(alignment: .leading, spacing: 15) {
        CheckListButton(
          description: description,
          state: $checkState
        )
        
        GIFImage(sample: ADResourcesAsset.Gifs.step4Gif)
          .frame(height: 250)
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
  }
}

private extension FindingCharacterJointsView {
  struct NextStepDescription: View {
    let description = "In the next step, we’ll use the segmentation mask and these joints locations to animate your character with motion capture data."
    
    var body: some View {
      Text(description)
    }
  }
}

private extension FindingCharacterJointsView {
  struct ShowMaskingImageViewButton: View {
    let figureYoga = "figure.yoga"
    let text = "Find Character Joints"
    
    let state: Bool
    let action: () -> ()
    
    init(_ state: Bool, action: @escaping () -> Void) {
      self.state = state
      self.action = action
    }
    
    var body: some View {
      ADButton(
        state: state,
        action: action,
        content: {
          HStack {
            Image(systemName: figureYoga)
            Text(text)
          }
        }
      )
    }
  }
}

private extension FindingCharacterJointsView {
  @MainActor
  func ifLetModifyJointsView() -> some View {
    Group {
      if let modifyJointsStore = self.store.scope(state: \.modifyJoints, action: \.scope.modifyJoints) {
        WithPerceptionTracking {
          ModifyJointsView(store: modifyJointsStore)
            .transparentBlurBackground()
            .addLoadingView(
              isShow: store.loadingView,
              description: "Modify Character Joints ..."
            )
            .alertNetworkError(isPresented: $store.alert.networkError)
        }
      } else {
        Text("No Joints Data...")
      }
    }
  }
}
