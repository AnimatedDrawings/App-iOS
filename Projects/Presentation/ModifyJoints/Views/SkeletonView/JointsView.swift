//
//  JointsView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/18.
//

import SwiftUI
import ADResources
import DomainModels
import ADComposableArchitecture

struct JointsView: View {
  @Binding var skeletons: [String : Skeleton]
  @Binding var currentJointName: String?
  let viewSize: CGSize
  let color: Color = ADResourcesAsset.Color.blue1.swiftUIColor
  let jointCircleSize: CGFloat = 15
  
  var body: some View {
    ForEach(Array(skeletons.keys), id: \.self) { name in
      if let mySkeleton = skeletons[name] {
        JointCircle()
          .offset(calJointOffset(mySkeleton))
          .gesture(
            DragGesture(coordinateSpace: .local)
              .onChanged({ value in
                updateCurrentJoint(mySkeleton)
                dragOnChanged(value, skeleton: mySkeleton)
              })
              .onEnded(dragOnEnded(_:))
          )
      }
    }
  }
}

extension JointsView {
  @ViewBuilder
  func JointCircle() -> some View {
    Circle()
      .frame(width: jointCircleSize, height: jointCircleSize)
      .foregroundColor(color)
      .overlay {
        Circle()
          .strokeBorder(.white, lineWidth: 2)
      }
  }
}

extension JointsView {
  func calJointOffset(_ skeleton: Skeleton) -> CGSize {
    let widthView: CGFloat = self.viewSize.width
    let heightView: CGFloat = self.viewSize.height
    
    let ratioX: CGFloat = skeleton.ratioPoint.x
    let ratioY: CGFloat = skeleton.ratioPoint.y
    
    return CGSize(
      width: (widthView * ratioX) - (jointCircleSize / 2),
      height: (heightView * ratioY) - (jointCircleSize / 2)
    )
  }
  
  func updateCurrentJoint(_ skeleton: Skeleton) {
    currentJointName = skeleton.name
  }
  
  func dragOnChanged(_ value: DragGesture.Value, skeleton: Skeleton) {
    let widthView: CGFloat = viewSize.width
    let heightView: CGFloat = viewSize.height
    let nexX: CGFloat = value.location.x
    let nexY: CGFloat = value.location.y
    
    guard 0 <= nexX && nexX <= widthView &&
            0 <= nexY && nexY <= heightView
    else {
      return
    }
    
    let nexRatioPoint = RatioPoint(x: nexX / widthView, y: nexY / heightView)
    let newSkeleton = skeleton.updatePoint(with: nexRatioPoint)
    skeletons[newSkeleton.name] = newSkeleton
  }
  
  func dragOnEnded(_ value: DragGesture.Value) {
    currentJointName = nil
  }
}

extension Skeleton {
  func updatePoint(with newPoint: RatioPoint) -> Self {
    return Self(
      name: self.name,
      ratioPoint: newPoint,
      parent: self.parent
    )
  }
}
