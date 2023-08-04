//
//  LoadingView.swift
//  AD_UI
//
//  Created by minii on 2023/07/25.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

extension View {
  func addLoadingView(isShow: Bool, description: String) -> some View {
    self.modifier(LoadingViewModifier(isShow: isShow, description: description))
  }
}

struct LoadingViewModifier: ViewModifier {
  let isShow: Bool
  let description: String
  
  func body(content: Content) -> some View {
    GeometryReader { geo in
      ZStack {
        content
          .disabled(isShow)
          .blur(radius: isShow ? 2 : 0)
        
        if isShow {
          ZStack {
            Color.black
              .opacity(0.5)
              .ignoresSafeArea()
              .edgesIgnoringSafeArea(.all)
            
            LoadingView(description: description)
          }
        }
      }
    }
  }
}

struct LoadingView: View {
  let description: String
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .frame(height: 200)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .overlay {
          VStack {
            ProgressView()
              .scaleEffect(3.0, anchor: .center)
            
            Spacer()
            
            Text(description)
              .lineLimit(1)
              .font(.system(size: 100))
              .minimumScaleFactor(0.001)
              .frame(maxWidth: .infinity)
              .frame(height: 50)
            
          }
          .padding()
          .padding(.vertical)
          .padding(.top)
        }
        .padding(.horizontal)
        .padding(.horizontal)
        .padding(.horizontal)
    }
  }
}

struct LoadingView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      ADBackground()
      
      LoadingView(description: "TestLoadingView...")
//        .transparentBlurBackground(
//          effect: UIBlurEffect(style: .regular),
//          intensity: 0.9
//        )
        .transparentBlurBackground(
          effect: UIBlurEffect(style: .regular),
          intensity: 1
        )
    }
  }
}
