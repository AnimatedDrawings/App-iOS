//
//  JointsView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/18.
//

import SwiftUI
import Domain_Model

struct JointsView: View {
  @ObservedObject var modifyJointsLink: ModifyJointsLink
  let strokeColor: Color
  let jointCircleSize: CGFloat = 15
  var skeletonDict: [String : Skeleton] {
    return self.modifyJointsLink.skeletons
  }
  
  let enableDragGesture: Bool
  
  init(
    modifyJointsLink: ModifyJointsLink,
    strokeColor: Color,
    enableDragGesture: Bool = true
  ) {
    self.modifyJointsLink = modifyJointsLink
    self.strokeColor = strokeColor
    self.enableDragGesture = enableDragGesture
  }
  
  var body: some View {
    ForEach(Array(skeletonDict.keys), id: \.self) { name in
      if let mySkeleton = skeletonDict[name] {
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
      .foregroundColor(strokeColor)
      .overlay {
        Circle()
          .strokeBorder(.white, lineWidth: 2)
      }
  }
}

extension JointsView {
  func calJointOffset(_ skeleton: Skeleton) -> CGSize {
    let widthView: CGFloat = self.modifyJointsLink.viewSize.width
    let heightView: CGFloat = self.modifyJointsLink.viewSize.height
    
    let ratioX: CGFloat = skeleton.ratioPoint.x
    let ratioY: CGFloat = skeleton.ratioPoint.y
    
    return CGSize(
      width: (widthView * ratioX) - (self.jointCircleSize / 2),
      height: (heightView * ratioY) - (self.jointCircleSize / 2)
    )
  }
  
  func updateCurrentJoint(_ skeleton: Skeleton) {
    if self.modifyJointsLink.currentJoint == nil {
      self.modifyJointsLink.currentJoint = skeleton.name
    }
  }
  
  func dragOnChanged(_ value: DragGesture.Value, skeleton: Skeleton) {
    let widthView: CGFloat = self.modifyJointsLink.viewSize.width
    let heightView: CGFloat = self.modifyJointsLink.viewSize.height
    let nexX: CGFloat = value.location.x
    let nexY: CGFloat = value.location.y
    
    guard 0 <= nexX && nexX <= widthView &&
            0 <= nexY && nexY <= heightView
    else {
      return
    }
    
    let nexRatioPoint = RatioPoint(x: nexX / widthView, y: nexY / heightView)
    let newSkeleton = skeleton.updatePoint(with: nexRatioPoint)
    self.modifyJointsLink.skeletons[newSkeleton.name] = newSkeleton
  }
  
  func dragOnEnded(_ value: DragGesture.Value) {
    self.modifyJointsLink.currentJoint = nil
  }
}

struct JointsView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_ModifyJointsView()
  }
}
