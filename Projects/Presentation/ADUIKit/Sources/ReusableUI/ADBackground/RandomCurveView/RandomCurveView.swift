//
//  RandomCurveView.swift
//  ADUIKit
//
//  Created by chminii on 1/30/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

extension ADBackground {
  struct RandomCurveView: View {
    let withStepBar: Bool
    @State var randomCurvePoint: ADBackground.RandomCurvePoint = .init(rect: .zero)
    
    var body: some View {
      GeometryReader { geo in
        let rect: CGRect = geo.frame(in: .global)
        
        ADBackground.RandomCurveShape(randomCurvePoint: randomCurvePoint)
          .onAppear {
            self.randomCurvePoint = ADBackground.RandomCurvePoint(rect: rect)
          }
          .if(withStepBar) {
            $0.receiveShared(\.shared.stepBar.currentStep) { receivedValue in
                self.randomCurvePoint = ADBackground.RandomCurvePoint(rect: rect)
              }
          } else: {
            $0
          }
          .animation(.spring(), value: randomCurvePoint)
      }
    }
  }
}
