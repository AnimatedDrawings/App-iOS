//
//  OnBoardingView.swift
//  Config
//
//  Created by minii on 2023/05/25.
//

import SwiftUI
import AD_Utils
import ComposableArchitecture

public struct OnBoardingView: ADUI {
  public init() {}
}

extension OnBoardingView {
  @ViewBuilder
  public func main(
    startButtonAction: @escaping ADAction
  ) -> some View {
    VStack {
      Title()
      SubTitle()
      Spacer().frame(height: 20)
      Description()
      
      Spacer().frame(height: 40)
      
      RoundedRectangle(cornerRadius: 10)
        .padding(.horizontal, 20)
        .frame(height: 300)
        .foregroundColor(ADUtilsAsset.blue2.swiftUIColor)
      
      Spacer().frame(height: 40)
      
      StartButton(action: startButtonAction)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea(.all)
    .background(ADUtilsAsset.blue4.swiftUIColor)
  }
}

extension OnBoardingView {
  @ViewBuilder
  func Title() -> some View {
    let left = "ANIMATED"
    let right = "DRAWINGS"

    HStack {
      Text(left)
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(ADUtilsAsset.blue1.swiftUIColor)
      Text(right)
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(ADUtilsAsset.blue3.swiftUIColor)
    }
  }
}

extension OnBoardingView {
  @ViewBuilder
  func SubTitle() -> some View {
    let subTitle = "PRESENTED BY META AI RESEARCH"
    
    Text(subTitle)
      .font(.system(.caption, weight: .semibold))
      .foregroundColor(ADUtilsAsset.blue2.swiftUIColor)
  }
}

extension OnBoardingView {
  @ViewBuilder
  func Description() -> some View {
    let description = "Bring children's drawings to life, by animating characters to move around!"
    
    Text(description)
      .font(.system(.headline, weight: .medium))
      .multilineTextAlignment(.center)
  }
}

extension OnBoardingView {
  @ViewBuilder
  func StartButton(action: @escaping () -> ()) -> some View {
    let startText = "Get Started"
    
    ADButton(startText, action: action)
  }
}

struct OnBoardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnBoardingView().main(
      startButtonAction: { print("efe") }
    )
  }
}
