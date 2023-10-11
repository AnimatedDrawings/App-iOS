//
//  BonesView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/20.
//

import SwiftUI
import Domain_Model

struct BonesView: View {
  @ObservedObject var modifyJointsLink: ModifyJointsLink
  let strokeColor: Color
  var skeletonDict: [String : Skeleton] {
    return self.modifyJointsLink.skeletons
  }
  
  var body: some View {
    ForEach(Array(self.skeletonDict.keys), id: \.self) { myName in
      if let mySkeleton = self.skeletonDict[myName] {
        if let parentName = mySkeleton.parent,
            let parentSkeleton = self.skeletonDict[parentName] {
          BoneLine(me: mySkeleton.ratioPoint, parent: parentSkeleton.ratioPoint)
        }
      }
    }
  }
}

extension BonesView {
  var viewRect: CGRect {
    return CGRect(
      origin: .init(),
      size: self.modifyJointsLink.viewSize
    )
  }
  
  @ViewBuilder
  func BoneLine(me: RatioPoint, parent: RatioPoint) -> some View {
    let myPoint: CGPoint = calPoint(me)
    let parentPoint: CGPoint = calPoint(parent)
    LineShape(myPoint: myPoint, parentPoint: parentPoint)
      .path(in: self.viewRect)
      .stroke(lineWidth: 5)
      .foregroundColor(strokeColor)
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
  
  func calPoint(_ ratioPoint: RatioPoint) -> CGPoint {
    let x = (self.viewRect.width * ratioPoint.x)
    let y = (self.viewRect.height * ratioPoint.y)
    
    return CGPoint(x: x, y: y)
  }
}
