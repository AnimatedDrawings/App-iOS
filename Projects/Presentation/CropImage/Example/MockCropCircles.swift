//
//  MockCropCircles.swift
//  CropImage
//
//  Created by chminii on 3/1/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADUIKitResources
import DomainModel
import CoreModel
import SwiftUI

struct Preview_CropCircles: View {
  let boundingBox: CGRect
  
//  @State var curPoint: CGPoint = .init()
//  @State var curSize: CGSize = .init()
  @State var viewSize: CGSize = .init()
  @State var viewBoundingBox: CGRect = .init()
  
  let example1: UIImage = ADUIKitResourcesAsset.SampleDrawing.step1Example1.image
  let strokeColor: Color = ADUIKitResourcesAsset.Color.blue3.swiftUIColor
  let lineWidth: CGFloat = 3
  
  init() {
//    let testBoundingBox = BoundingBoxDTO.mock().toCGRect()
//    self.boundingBox = CGRect(origin: .init(), size: testBoundingBox.size)
    self.boundingBox = BoundingBoxDTO.mock().toCGRect()
  }
  
  var body: some View {
    VStack {
//      CoordiText(curPoint: $curPoint, curSize: $curSize)
      
      ZStack(alignment: .topLeading) {
        TestImage(image: example1, viewSize: $viewSize)
          .onChange(of: viewSize, perform: updateFrameCropCircles)
          .overlay {
            CropCircles(
              viewBoundingBox: $viewBoundingBox,
              viewSize: $viewSize,
              strokeColor: strokeColor,
              lineWidth: lineWidth
            )
          }
          .padding()
      }
    }
  }
  
  func updateFrameCropCircles(_ viewSize: CGSize) {
    let imageScale = calImageScale(viewSize: viewSize)
    let boundingOrigin = CGPoint(
      x: boundingBox.minX * imageScale,
      y: boundingBox.minY * imageScale
    )
    let boundingSize = CGSize(
      width: boundingBox.width * imageScale,
      height: boundingBox.height * imageScale
    )
    
    viewBoundingBox = CGRect(origin: boundingOrigin, size: boundingSize)
  }
  
  func calImageScale(viewSize: CGSize) -> CGFloat {
    let imageSizeValue: CGFloat = example1.size.width
    let viewSizeValue: CGFloat = viewSize.width
    return imageSizeValue != 0 ? viewSizeValue / imageSizeValue : 0
  }
  
  struct CoordiText: View {
    @Binding var curPoint: CGPoint
    @Binding var curSize: CGSize
    
    var body: some View {
      VStack {
        Text("X : \(curPoint.x), Y : \(curPoint.y)")
        Text("Width : \(curSize.width), Height : \(curSize.height)")
      }
    }
  }
  
  struct TestImage: View {
    let image: UIImage
    @Binding var viewSize: CGSize
    
    var body: some View {
      ZStack {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .background(
            GeometryReader { geo in
              Color.clear
                .onAppear {
                  self.viewSize = geo.frame(in: .local).size
                }
            }
          )
      }
    }
  }
}
