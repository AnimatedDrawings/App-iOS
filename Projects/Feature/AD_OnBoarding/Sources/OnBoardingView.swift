//
//  OnBoardingView.swift
//  Config
//
//  Created by minii on 2023/05/25.
//

import SwiftUI
import AD_Utils

public struct OnBoardingView: View {
  private let title = "ANIMATED DRAWINGS"
  private let subTitle = "PRESENTED BY META AI RESEARCH"
  private let description = "Bring children's drawings to life, by animating characters to move around!"
  
  public init() {}
  
  public var body: some View {
    VStack {
      Text(title)
      Text(subTitle)
      
      Button {
        
      } label: {
        Text("efe")
      }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea(.all)
    .background(ADUtilsAsset.blue4.swiftUIColor)
  }
}

struct OnBoardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnBoardingView()
  }
}
