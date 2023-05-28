//
//  RootFeature.swift
//  AD_Feature
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct RootFeature: View {
  public init() {}
  
  public var body: some View {
    OnBoarding()
  }
}

struct RootFeature_Previews: PreviewProvider {
  static var previews: some View {
    RootFeature()
  }
}
