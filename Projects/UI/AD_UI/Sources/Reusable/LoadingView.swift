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
          LoadingView(description: description)
        }
      }
    }
  }
}

struct LoadingView: View {
  let description: String
  
  var body: some View {
    ZStack {
      Color.black
        .opacity(0.5)
        .ignoresSafeArea()
        .edgesIgnoringSafeArea(.all)
      
      RoundedRectangle(cornerRadius: 10)
        .frame(height: 180)
        .padding(.horizontal)
        .padding(.horizontal)
        .padding(.horizontal)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .overlay {
          VStack {
            ProgressView()
              .scaleEffect(2.0, anchor: .center)
            
            Spacer()
            
            Text(description)
              .font(.title)
              .fontWeight(.semibold)
          }
          .padding()
          .padding(.vertical)
          .padding(.top)
        }
    }
  }
}

struct Previews_LoadingView: View {
  var isShow = true

  var body: some View {
    VStack {
      Rectangle()
        .foregroundColor(.red)
        .frame(width: 300, height: 300)
      
      Rectangle()
        .foregroundColor(.blue)
        .frame(width: 300, height: 300)
        .addLoadingView(isShow: isShow, description: "feawfewa")
    }
  }
}

struct LoadingView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_LoadingView()
  }
}

