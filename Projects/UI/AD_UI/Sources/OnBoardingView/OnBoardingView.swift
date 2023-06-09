//
//  OnBoardingView.swift
//  Config
//
//  Created by minii on 2023/05/25.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture

struct OnBoardingView: ADUI {
  typealias MyReducer = OnBoardingStore
  let store: StoreOf<MyReducer>
  
  init(
    store: StoreOf<MyReducer> = Store(
      initialState: MyReducer.State(),
      reducer: MyReducer()
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        Title()
        
        Spacer().frame(height: 80)
        
        Preview()
        
        Spacer().frame(height: 80)
        
        StartButton() { viewStore.send(.pushUploadADrawing) }
      }
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .ignoresSafeArea(.all)
      .background(ADBackground())
    }
  }
}

extension OnBoardingView {
  @ViewBuilder
  func Title() -> some View {
    let left = "ANIMATED"
    let right = "DRAWINGS"
    let subTitle = "PRESENTED BY META AI RESEARCH"
    let description = "Bring children's drawings to life, by animating characters to move around!"
    
    VStack {
      HStack {
        Text(left)
          .font(.system(.largeTitle, weight: .semibold))
          .foregroundColor(ADUtilsAsset.Color.blue1.swiftUIColor)
        Text(right)
          .font(.system(.largeTitle, weight: .semibold))
          .foregroundColor(ADUtilsAsset.Color.blue3.swiftUIColor)
      }
      
      Text(subTitle)
        .font(.system(.caption, weight: .semibold))
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      
      Spacer().frame(height: 20)
      
      Text(description)
        .font(.system(.title3, weight: .medium))
        .multilineTextAlignment(.center)
    }
  }
}

extension OnBoardingView {
  @ViewBuilder
  func Preview() -> some View {
    let previewName = "ADApp_Preview"
    let withExtension = "mp4"
    
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .padding([.leading, .bottom], 20)
        .frame(height: 300)
        .foregroundColor(ADUtilsAsset.Color.blue1.swiftUIColor)
      
      RoundedRectangle(cornerRadius: 10)
        .overlay {
          LoopingPlayer(name: previewName, withExtension: withExtension)
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
    
    ADButton(startText, action: action)
  }
}

struct OnBoardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnBoardingView()
  }
}
