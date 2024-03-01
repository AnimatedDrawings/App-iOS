//
//  CropStroke.swift
//  CropImage
//
//  Created by chminii on 2/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

struct CropStroke: View {
  @Binding var curPoint: CGPoint
  @Binding var curSize: CGSize
  let strokeColor: Color
  let lineWidth: CGFloat
  
  var body: some View {
    VStack {
      ZStack(alignment: .topLeading) {
        Rectangle()
          .stroke(strokeColor, lineWidth: lineWidth)
      }
      .offset(
        x: curPoint.x,
        y: curPoint.y
      )
      .frame(maxWidth: curSize.width, maxHeight: curSize.height, alignment: .topLeading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}
