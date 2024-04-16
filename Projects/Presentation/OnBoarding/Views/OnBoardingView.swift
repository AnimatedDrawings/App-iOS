//
//  OnBoardingView.swift
//  Config
//
//  Created by minii on 2023/05/25.
//

import SwiftUI
import ADUIKit
import ADResources
import SharedProvider

public struct OnBoardingView: View {
  @SharedValue(\.adViewState.currentView) var currentView
  
  public init() {}
  
  public var body: some View {
    VStack {
      Title()
      
      Spacer()
      
      Preview()
      
      Spacer()
      
      StartButton { currentView = .MakeAD }
    }
    .padding()
    .padding(.vertical)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .addADBackground()
  }
}

private extension OnBoardingView {
  struct Title: View {
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
    
    var body: some View {
      VStack {
        HStack {
          Text(left)
            .font(.system(titleSize, weight: .semibold))
            .foregroundColor(ADResourcesAsset.Color.blue1.swiftUIColor)
          Text(right)
            .font(.system(titleSize, weight: .semibold))
            .foregroundColor(ADResourcesAsset.Color.blue3.swiftUIColor)
        }
        
        Text(subTitle)
          .font(.system(.caption, weight: .semibold))
          .foregroundColor(ADResourcesAsset.Color.blue2.swiftUIColor)
        
        Spacer().frame(height: 20)
        
        Text(description)
          .font(.system(.headline, weight: .medium))
          .multilineTextAlignment(.center)
      }
    }
  }
}

private extension OnBoardingView {
  struct Preview: View {
    let previewName = "PreviewADApp"
    let withExtension = "mp4"
    
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 10)
          .padding([.leading, .bottom], 20)
          .frame(height: 300)
          .foregroundColor(ADResourcesAsset.Color.blue1.swiftUIColor)
        
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
}

private extension OnBoardingView {
  struct StartButton: View {
    let action: () -> ()
    let startText = "Get Started"
    
    var body: some View {
      ADButton(title: startText, action: action)
    }
  }
}
