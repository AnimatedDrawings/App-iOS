//
//  BonesView.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/20.
//

import SwiftUI
import DomainModels
import ADComposableArchitecture
import ADResources

struct BonesView: View {
  @Binding var skeletons: [String : Skeleton]
  let viewSize: CGSize
  
  func calPoint(_ ratioPoint: RatioPoint) -> CGPoint {
    let x = (viewSize.width * ratioPoint.x)
    let y = (viewSize.height * ratioPoint.y)
    
    return CGPoint(x: x, y: y)
  }
  
  var body: some View {
    ForEach(Array(skeletons.keys), id: \.self) { myName in
      if let mySkeleton = skeletons[myName] {
        if let parentName = mySkeleton.parent,
           let parentSkeleton = skeletons[parentName] {
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
    let color: Color = ADResourcesAsset.Color.blue1.swiftUIColor
    
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
