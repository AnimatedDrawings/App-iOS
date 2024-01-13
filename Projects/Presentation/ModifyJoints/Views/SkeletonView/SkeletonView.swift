//
//  SkeletonView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/17.
//

import SwiftUI

struct SkeletonView: View {
  let croppedImage: UIImage
  @ObservedObject var modifyJointsLink: ModifyJointsLink
  
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
                      self.modifyJointsLink.viewSize = viewSize
                    }
                  
                  BonesView(modifyJointsLink: self.modifyJointsLink)
                  JointsView(
                    modifyJointsLink: self.modifyJointsLink
                  )
                }
              }
            }
            .padding()
        }
    }
  }
}

struct DraggingPointsView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_ModifyJointsView()
  }
}
