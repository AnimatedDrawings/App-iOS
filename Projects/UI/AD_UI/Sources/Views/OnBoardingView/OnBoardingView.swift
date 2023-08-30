//
//  OnBoardingView.swift
//  Config
//
//  Created by minii on 2023/05/25.
//

import SwiftUI
import AD_Utils

struct OnBoardingView: View {
  @Binding var isTapStartButton: Bool
  
  var body: some View {
    VStack {
      Title()
      
      Spacer().frame(height: 80)
      
      Preview()
      
      Spacer().frame(height: 80)
      
      StartButton {
        if isTapStartButton == false {
          isTapStartButton = true
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea()
    .addBackground()
  }
}

extension OnBoardingView {
  @ViewBuilder
  func Title() -> some View {
    let left = "ANIMATED"
    let right = "DRAWINGS"
    let subTitle = "PRESENTED BY META AI RESEARCH"
    let description = "Bring children's drawings to life, by animating characters to move around!"
    var titleSize: Font.TextStyle {
      switch UIDevice.current.userInterfaceIdiom {
      case .phone:
        if let screenWidth = UIScreen.current?.bounds.size.width,
           screenWidth < 380
        {
          return .title
        }
        else {
          return .largeTitle
        }
      default:
        return .largeTitle
      }
    }
    
    VStack {
      HStack {
        Text(left)
          .font(.system(titleSize, weight: .semibold))
          .foregroundColor(ADUtilsAsset.Color.blue1.swiftUIColor)
        Text(right)
          .font(.system(titleSize, weight: .semibold))
          .foregroundColor(ADUtilsAsset.Color.blue3.swiftUIColor)
      }
      
      Text(subTitle)
        .font(.system(.caption, weight: .semibold))
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      
      Spacer().frame(height: 20)
      
      Text(description)
        .font(.system(.headline, weight: .medium))
        .multilineTextAlignment(.center)
    }
  }
}

extension OnBoardingView {
  @ViewBuilder
  func Preview() -> some View {
    let previewName = "PreviewADApp"
    let withExtension = "mp4"
    
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .padding([.leading, .bottom], 20)
        .frame(height: 300)
        .foregroundColor(ADUtilsAsset.Color.blue1.swiftUIColor)
      
      RoundedRectangle(cornerRadius: 10)
        .overlay {
          LoopingVideoPlayer(name: previewName, withExtension: withExtension)
            .mask {
              RoundedRectangle(cornerRadius: 8)
            }
            .padding(.all, 7)
        }
        .padding([.top, .trailing], 20)
        .frame(height: 300)
        .foregroundColor(.white)
    }
  }
}

extension OnBoardingView {
  @ViewBuilder
  func StartButton(action: @escaping () -> ()) -> some View {
    let startText = "Get Started"
    
    ADButton(title: startText, action: action)
  }
}

struct OnBoardingView_Previews: PreviewProvider {
  static var previews: some View {
    @State var isTapStartButton: Bool = false
    
    OnBoardingView(isTapStartButton: $isTapStartButton)
  }
}
