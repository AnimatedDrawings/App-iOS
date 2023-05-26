//
//  OnBoardingView.swift
//  Config
//
//  Created by minii on 2023/05/25.
//

import SwiftUI
import AD_Utils

public struct OnBoardingView: View {
  private let onBoardingString = "onBoardingString"
  
  public init() {}
  
  public var body: some View {
    VStack {
      Text(onBoardingString)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea(.all)
    .background(ADUtilsAsset.blue4.swiftUIColor)
  }
}
