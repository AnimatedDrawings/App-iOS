//
//  MaskableView.swift
//  MaskingImage
//
//  Created by chminii on 1/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import MaskImageFeatures
import ADResources

struct MaskableView: View {
  @Perception.Bindable var store: StoreOf<MaskImageFeature>
  
  @State private var imageFrame: CGRect = .init()
  private let backgroundImage: UIImage = ADResourcesAsset.SampleDrawing.checkerboard.image
  
  var body: some View {
    WithPerceptionTracking {
      RoundedRectangle(cornerRadius: 15)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .overlay {
          Image(uiImage: backgroundImage)
            .resizable()
            .overlay {
              MaskableUIViewRepresentable(
                store: store,
                imageFrame: $imageFrame
              )
            }
            .background(
              GeometryReader { geo in
                Color.clear
                  .onAppear {
                    self.imageFrame = geo.frame(in: .global)
                  }
              }
            )
            .padding()
        }
        .padding()
        .padding(.bottom)
    }
  }
}
