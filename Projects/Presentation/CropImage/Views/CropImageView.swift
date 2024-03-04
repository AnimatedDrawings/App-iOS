//
//  CropImageView.swift
//  AD_UI
//
//  Created by minii on 2023/06/08.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADUIKitSources
import ADUIKitResources
import CropImageFeatures
import ThirdPartyLib

public struct CropImageView: View {
  @Perception.Bindable var store: StoreOf<CropImageFeature>
  
  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 40) {
        ToolNaviBar(
          cancelAction: store.action(.view(.cancel)),
          saveAction: store.action(.view(.save))
        )
        
        Spacer()
        
        ViewFinder(
          image: store.originalImage,
          boundingBox: store.boundingBox,
          viewBoundingBox: $store.viewBoundingBox,
          imageScale: $store.imageScale
        )
        .reload(store.resetTrigger)
        
        Spacer()
        
        HStack {
          Spacer()
          ResetButton(action: store.action(.view(.reset)))
        }
      }
      .padding()
    }
  }
}

extension CropImageView {
  struct ResetButton: View {
    let size: CGFloat = 60
    let imageName = "arrow.uturn.backward"
    let strokeColor = ADUIKitResourcesAsset.Color.blue1.swiftUIColor
    let action: () -> ()
    
    var body: some View {
      Button(action: action) {
        Circle()
          .frame(width: size, height: size)
          .foregroundColor(.white)
          .shadow(radius: 10)
          .overlay {
            Image(systemName: imageName)
              .resizable()
              .foregroundColor(strokeColor)
              .fontWeight(.semibold)
              .padding()
          }
      }
    }
  }
}
