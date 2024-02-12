//
//  RandomCurveView.swift
//  ADUIKit
//
//  Created by chminii on 1/30/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

struct RandomCurve: View {
  @Binding var curveTrigger: Bool
  @State var randomCurvePoint: RandomCurvePoint = .init(rect: .zero)
  
  var body: some View {
    GeometryReader { geo in
      let rect: CGRect = geo.frame(in: .global)
      
      RandomCurveShape(randomCurvePoint: randomCurvePoint)
        .onAppear {
          self.randomCurvePoint = RandomCurvePoint(rect: rect)
        }
        .onChange(of: curveTrigger) { _ in
          randomCurvePoint = RandomCurvePoint(rect: rect)
        }
        .animation(.spring(), value: randomCurvePoint)
    }
  }
}
