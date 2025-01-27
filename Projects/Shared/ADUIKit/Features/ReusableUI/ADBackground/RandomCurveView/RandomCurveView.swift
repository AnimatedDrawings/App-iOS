//
//  RandomCurveView.swift
//  ADUIKit
//
//  Created by chminii on 1/30/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

struct RandomCurve<T: Equatable>: View {
//  @Binding var curveTrigger: T
  var curveTrigger: T
  @State var randomCurvePoint: RandomCurvePoint = .init(rect: .zero)
  
  var test: any Equatable = 12
  
  var body: some View {
    GeometryReader { geo in
      let rect: CGRect = geo.frame(in: .global)
      
      RandomCurveShape(randomCurvePoint: randomCurvePoint)
        .onAppear {
          self.randomCurvePoint = RandomCurvePoint(rect: rect)
        }
        .onChange(of: curveTrigger) {
          randomCurvePoint = RandomCurvePoint(rect: rect)
        }
        .animation(.spring(), value: randomCurvePoint)
    }
  }
}
