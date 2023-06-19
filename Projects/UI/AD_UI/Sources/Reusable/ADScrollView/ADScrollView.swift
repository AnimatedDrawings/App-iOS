//
//  ADScrollView.swift
//  AD_UI
//
//  Created by minii on 2023/06/19.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

struct ADScrollView<C: View>: View {
  let topScrollID = "topScrollID"
  var content: C
  
  init(@ViewBuilder content: () -> C) {
    self.content = content()
  }
  
  var body: some View {
    GeometryReader { geo in
      let rect: CGRect = geo.frame(in: .global)
      let scrollViewBottom: CGFloat = rect.origin.y + rect.size.height
      
      ScrollView(.vertical) {
        content
          .background(
            TrackingView(
              topScrollID: topScrollID,
              scrollViewBottom: scrollViewBottom
            )
          )
      }
      .coordinateSpace(name: topScrollID)
    }
  }
}

extension ADScrollView {
  struct TrackingView: View {
    let topScrollID: String
    let scrollViewBottom: CGFloat
    @EnvironmentObject var stepStatusBarEnvironment: StepStatusBarEnvironment
    
    @State var curTop: CGFloat = 0
    @State var lastTop: CGFloat = 0
    @State var curBottom: CGFloat = 0
    let dist: CGFloat = 30
    
    var body: some View {
      VStack {
        TrackingTopOffset()
        Spacer()
        TrackingBottomOffset()
      }
    }
    
    @ViewBuilder
    func TrackingTopOffset() -> some View {
      GeometryReader { geo in
        let tmpTop: CGFloat = geo.frame(in: .named(self.topScrollID)).origin.y
        
        Color.clear
          .onChange(of: tmpTop) { newValue in
            self.curTop = tmpTop
            trackingAction()
          }
      }
      .frame(width: 0, height: 0)
    }
    
    @ViewBuilder
    func TrackingBottomOffset() -> some View {
      GeometryReader { geo in
        let tmpBottom: CGFloat = geo.frame(in: .global).origin.y
        
        Color.clear
          .onChange(of: tmpBottom) { newValue in
            self.curBottom = tmpBottom - self.scrollViewBottom
            
          }
      }
      .frame(width: 0, height: 0)
    }
    
    func trackingAction() {
      let translationY: CGFloat = self.curTop - self.lastTop
      
      if -dist <= translationY && translationY <= dist {
        return
      }
      
      if curBottom < 0 {
        disappearStepBar()
        resetLastTop()
        return
      }
      else if 0 < curTop {
        appearStepBar()
        resetLastTop()
        return
      }
      
      if translationY < 0 {
        disappearStepBar()
        self.lastTop = curTop
      }
      else if 0 < translationY {
        appearStepBar()
        self.lastTop = curTop
      }
    }
    
    func resetLastTop() {
      if self.lastTop != 0 {
        self.lastTop = 0
      }
    }
    
    func appearStepBar() {
      print("isHide False")
      if self.stepStatusBarEnvironment.isHide == true {
        withAnimation {
          self.stepStatusBarEnvironment.isHide = false
        }
      }
    }
    
    func disappearStepBar() {
      print("isHide True")
      if self.stepStatusBarEnvironment.isHide == false {
        withAnimation {
          self.stepStatusBarEnvironment.isHide = true
        }
      }
    }
  }
}
