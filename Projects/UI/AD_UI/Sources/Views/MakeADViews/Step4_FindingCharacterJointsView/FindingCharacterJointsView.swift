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
import AD_ModifyJoints

struct FindingCharacterJointsView: ADUI {
  typealias MyFeature = FindingCharacterJointsFeature
  let store: StoreOf<MyFeature>
  
  init(
    store: StoreOf<MyFeature> = rootViewStore.scope(
      state: \.findingCharacterJointsState,
      action: RootViewFeature.Action.findingCharacterJointsAction
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView(
        viewStore.binding(
          get: \.sharedState.isShowStepStatusBar,
          send: MyFeature.Action.bindIsShowStepStatusBar
        )
      ) {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList(
            isCorrectStep: Step.isCorrectStep(
              myStep: .FindingCharacterJoints,
              completeStep: viewStore.sharedState.completeStep
            )
          ) {
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
        isPresented: viewStore.$isShowModifyJointsView,
        onDismiss: { viewStore.send(.onDismissModifyJointsView) },
        content: {
          if let croppedImage = viewStore.sharedState.croppedImage,
             let jointsDTO = viewStore.sharedState.jointsDTO
          {
            ModifyJointsView(
              croppedImage: croppedImage,
              jointsInfo: jointsDTO.toDomain(),
              modifyNextAction: { modifiedJointsInfo in
                let modifiedJointsDTO = modifiedJointsInfo.toDTO(
                  originImageSize: .init(
                    width: jointsDTO.width,
                    height: jointsDTO.height
                  )
                )
                viewStore.send(.findCharacterJoints(modifiedJointsDTO))
              },
              cancel: { viewStore.send(.toggleModifyJointsView) }
            )
            .transparentBlurBackground()
            .addLoadingView(isShow: viewStore.state.isShowLoadingView, description: "Modify Character Joints ...")
            .alert(store: self.store.scope(state: \.$alertShared, action: { .alertShared($0) }))
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
        .font(.system(.title, weight: .semibold))
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
  @MainActor
  func CheckListContent(with viewStore: MyViewStore) -> some View {
    let description = "If your character doesn't have any arms, drag the elbows and wrist joints far away from the character and it can still be animated"
    
    VStack(alignment: .leading, spacing: 15) {
      CheckListButton(description, state: viewStore.checkState) {
        viewStore.send(.checkAction)
      }
      
      GIFViewName("step4Gif")
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

extension JointsDTO {
  func toDomain() -> JointsInfo {
    let imageWidth = CGFloat(self.width)
    let imageHeight = CGFloat(self.height)
    
    return JointsInfo(
      skeletons: self.skeletonDTO
        .reduce(into: [String : SkeletonInfo](), { dict, dto in
          let name: String = dto.name
          let ratioX: CGFloat = imageWidth == 0 ? 0 : CGFloat(dto.location[0]) / imageWidth
          let ratioY: CGFloat = imageHeight == 0 ? 0 : CGFloat(dto.location[1]) / imageHeight
          let ratioPoint = RatioPoint(x: ratioX, y: ratioY)
          
          dict[name] = SkeletonInfo(
            name: name,
            ratioPoint: ratioPoint,
            parent: dto.parent
          )
        })
    )
  }
}

extension JointsInfo {
  func toDTO(originImageSize: CGSize) -> JointsDTO {
    return JointsDTO(
      width: Int(originImageSize.width),
      height: Int(originImageSize.height),
      skeletonDTO: self.skeletons.map { _, skeletonInfo in
        let locationX = Int(skeletonInfo.ratioPoint.x * originImageSize.width)
        let locationY = Int(skeletonInfo.ratioPoint.y * originImageSize.height)
        
        return SkeletonDTO(
          name: skeletonInfo.name,
          location: [locationX, locationY],
          parent: skeletonInfo.parent
        )
      }
    )
  }
}

struct FindingCharacterJointsView_Previews: PreviewProvider {
  static var previews: some View {
    FindingCharacterJointsView()
  }
}
