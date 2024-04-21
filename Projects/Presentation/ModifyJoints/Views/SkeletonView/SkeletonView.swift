//
//  SkeletonView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI
import ADComposableArchitecture
import ModifyJointsFeatures
import DomainModels

struct SkeletonView: View {
  @Binding var skeletons: [String : Skeleton]
  @Binding var currentJointName: String?
  let croppedImage: UIImage
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
                    skeletons: $skeletons,
                    viewSize: viewSize
                  )
                  
                  JointsView(
                    skeletons: $skeletons,
                    currentJointName: $currentJointName,
                    viewSize: viewSize
                  )
                }
              }
            }
            .padding()
        }
    }
  }
}
