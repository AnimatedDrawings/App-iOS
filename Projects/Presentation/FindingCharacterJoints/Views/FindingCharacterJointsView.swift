//
//  FindingCharacterJointsView.swift
//  AD_UI
//
//  Created by minii on 2023/07/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import FindingCharacterJointsFeatures
import ThirdPartyLib
import ModifyJoints
import ADUIKitSources
import ADUIKitResources
import DomainModel
import SharedProvider

public struct FindingCharacterJointsView: ADUI {
  public typealias MyFeature = FindingCharacterJointsFeature
  
  public init(
    store: MyStore = Store(
      initialState: .init()
    ) {
      MyFeature()
    }
  ) {
    self.store = store
    self._viewStore = StateObject(
      wrappedValue: ViewStore(store, observe: { $0 })
    )
  }
  
  let store: MyStore
  @StateObject var viewStore: MyViewStore
  
  @SharedValue(\.shared.makeAD.croppedImage) var croppedImage
  @SharedValue(\.shared.makeAD.joints) var joints
  
  public var body: some View {
    ADScrollView(.constant(true)) {
      VStack(alignment: .leading, spacing: 20) {
        Title()
        
        CheckList(myStep: .FindingCharacterJoints, completeStep: .SeparatingCharacter) {
          CheckListContent(viewStore: viewStore)
        }
        
        NextStepDescription()
        
        ShowMaskingImageViewButton(viewStore.checkState) {
          viewStore.send(.toggleModifyJointsView)
        }
        
        Spacer().frame(height: 20)
      }
      .padding()
    }
    .fullScreenCover(
      isPresented: viewStore.$isShowModifyJointsView,
      onDismiss: { viewStore.send(.onDismissModifyJointsView) },
      content: {
        if let croppedImage = croppedImage,
           let joints = joints
        {
          ModifyJointsView(
            croppedImage: croppedImage,
            joints: joints,
            save: { modifiedJoints in
              viewStore.send(.findCharacterJoints(modifiedJoints))
            },
            cancel: {
              viewStore.send(.toggleModifyJointsView)
            }
          )
          .transparentBlurBackground()
          .addLoadingView(
            isShow: viewStore.state.isShowLoadingView,
            description: "Modify Character Joints ..."
          )
          .alertNetworkError(isPresented: viewStore.$isShowNetworkErrorAlert)
        }
      }
    )
    .resetMakeADView(.FindingCharacterJoints) {
      viewStore.send(.initState)
    }
  }
}

private extension FindingCharacterJointsView {
  struct Title: View {
    let title = "FINDING CHARACTER JOINTS"
    let description = "Here are your character's joints! Here's an example of what it should look like"
    let descriptionImage: UIImage = ADUIKitResourcesAsset.SampleDrawing.step4Description.image
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.title, weight: .semibold))
          .foregroundColor(ADUIKitResourcesAsset.Color.blue2.swiftUIColor)
        
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
    let description = "If your character doesn't have any arms, drag the elbows and wrist joints far away from the character and it can still be animated"
    let myStep: MakeADStep = .FindingCharacterJoints
    
    @ObservedObject var viewStore: MyViewStore
    
    var body: some View {
      VStack(alignment: .leading, spacing: 15) {
        CheckListButton(
          description: description,
          state: viewStore.$checkState
        )
        
        GIFImage(sample: ADUIKitResourcesAsset.Gifs.step4Gif)
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

// MARK: - Previews
struct FindingCharacterJointsView_Previews: PreviewProvider {
  static var previews: some View {
    FindingCharacterJointsView()
  }
}
