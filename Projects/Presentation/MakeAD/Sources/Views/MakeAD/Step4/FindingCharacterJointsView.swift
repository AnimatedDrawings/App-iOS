//
//  FindingCharacterJointsView.swift
//  AD_UI
//
//  Created by minii on 2023/07/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import MakeAD_Feature
import ThirdPartyLib
import ModifyJoints
import AD_UIKit
import Domain_Model
import SharedProvider

struct FindingCharacterJointsView: ADUI {
  typealias MyFeature = FindingCharacterJointsFeature
  let store: StoreOf<MyFeature>
  
  init(
    store: StoreOf<MyFeature> = Store(
      initialState: .init()
    ) {
      MyFeature()
    }
  ) {
    self.store = store
  }
  
  @SharedValue(\.shared.makeAD.croppedImage) var croppedImage
  @SharedValue(\.shared.makeAD.jointsDTO) var jointsDTO
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ADScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Title()
          
          CheckList(myStep: .FindingCharacterJoints) {
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
          if let croppedImage = croppedImage,
             let jointsDTO = jointsDTO
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
            .addLoadingView(
              isShow: viewStore.state.isShowLoadingView,
              description: "Modify Character Joints ..."
            )
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
    let descriptionImage: UIImage = ADUIKitAsset.SampleDrawing.step4Description.image
    
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .font(.system(.title, weight: .semibold))
        .foregroundColor(ADUIKitAsset.Color.blue2.swiftUIColor)
      
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
      CheckListButton(description, state: viewStore.checkState) {
        viewStore.send(.checkAction)
      }
      
      GIFImage(sample: ADUIKitAsset.Gifs.step4Gif)
        .frame(height: 250)
        .frame(maxWidth: .infinity, alignment: .center)
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

// MARK: - Previews
struct FindingCharacterJointsView_Previews: PreviewProvider {
  static var previews: some View {
    FindingCharacterJointsView()
  }
}
