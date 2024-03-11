//
//  BonesView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/20.
//

import SwiftUI
import DomainModel
import ADUIKitResources
import ADComposableArchitecture
import ModifyJointsFeatures

struct BonesView: View {
  let viewSize: CGSize
  @ObservedObject var viewStore: ViewStoreOf<ModifyJointsFeature>
  
  func calPoint(_ ratioPoint: RatioPoint) -> CGPoint {
    let x = (viewSize.width * ratioPoint.x)
    let y = (viewSize.height * ratioPoint.y)
    
    return CGPoint(x: x, y: y)
  }
  
  var body: some View {
    ForEach(Array(viewStore.skeletons.keys), id: \.self) { myName in
      if let mySkeleton = viewStore.skeletons[myName] {
        if let parentName = mySkeleton.parent,
           let parentSkeleton = viewStore.skeletons[parentName] {
          BoneLine(
            myPoint: calPoint(mySkeleton.ratioPoint),
            parentPoint: calPoint(parentSkeleton.ratioPoint),
            viewSize: viewSize
          )
        }
      }
    }
  }
}

extension BonesView {
  struct BoneLine: View {
    let myPoint: CGPoint
    let parentPoint: CGPoint
    let viewSize: CGSize
    let color: Color = ADUIKitResourcesAsset.Color.blue1.swiftUIColor
    
    init(myPoint: CGPoint, parentPoint: CGPoint, viewSize: CGSize) {
      self.myPoint = myPoint
      self.parentPoint = parentPoint
      self.viewSize = viewSize
    }
    
    var viewRect: CGRect {
      return CGRect(
        origin: .init(),
        size: self.viewSize
      )
    }
    
    var body: some View {
      LineShape(myPoint: myPoint, parentPoint: parentPoint)
        .path(in: self.viewRect)
        .stroke(lineWidth: 5)
        .foregroundColor(color)
    }
  }
  
  struct LineShape: Shape {
    let myPoint: CGPoint
    let parentPoint: CGPoint
    
    func path(in rect: CGRect) -> Path {
      var path = Path()
      
      path.move(to: myPoint)
      path.addLine(to: parentPoint)
      
      return path
    }
  }
}
