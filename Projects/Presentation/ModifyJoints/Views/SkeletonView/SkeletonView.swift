//
//  SkeletonView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI
import ADComposableArchitecture
import ModifyJointsFeatures

struct SkeletonView: View {
  let croppedImage: UIImage
  @ObservedObject var viewStore: ViewStoreOf<ModifyJointsFeature>
  
  @State var viewSize: CGSize = .init()
  
  var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .overlay {
          Image(uiImage: croppedImage)
            .resizable()
            .overlay {
              GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                  Color.clear
                    .onAppear {
                      let viewSize = geo.frame(in: .local).size
                      self.viewSize = viewSize
                    }
                  
                  BonesView(
                    viewSize: viewSize,
                    viewStore: viewStore
                  )
                  JointsView(
                    viewSize: viewSize,
                    viewStore: viewStore
                  )
                }
              }
            }
            .padding()
        }
    }
  }
}
