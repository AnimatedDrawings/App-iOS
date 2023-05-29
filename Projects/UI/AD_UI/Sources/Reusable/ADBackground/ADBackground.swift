//
//  ADBackground.swift
//  AD_UI
//
//  Created by minii on 2023/05/29.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public struct ADBackground: View {
  public init() {}
  
  public var body: some View {
    GeometryReader { proxy in
      let rect: CGRect = proxy.frame(in: .global)
      
      DoodleLines(rect: rect)
    }
    .ignoresSafeArea()
  }
}

struct ADBackground_Previews: PreviewProvider {
  static var previews: some View {
    ADBackground()
  }
}
