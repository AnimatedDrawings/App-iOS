//
//  ConfigureAnimationView.swift
//  AD_UI
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import ConfigureAnimation_Features
import AD_UIKit

public struct ConfigureAnimationView: ADUI {
  public typealias MyFeature = ConfigureAnimationFeature
  
  public init(
    store: MyStore = Store(
      initialState: .init()
    ) {
      MyFeature()
    }
  ) {
    self.store = store
    self._viewStore = StateObject(
      wrappedValue: ViewStore(store, observe: { $0 })
    )
  }
  
  let store: MyStore
  @StateObject var viewStore: MyViewStore
  
  public var body: some View {
    VStack(spacing: 0) {
      Title()
      
      Spacer().frame(height: 50)
      
      MyAnimationView(viewStore: viewStore)
      
      Spacer().frame(height: 50)
      
      TabBar(viewStore: viewStore)
      
      Spacer().frame(height: 20)
    }
    .padding()
    .addBackground()
    .alert(store: self.store.scope(state: \.$alertShared, action: { .alertShared($0) }))
    .alert(store: self.store.scope(state: \.$alertTrashMakeAD, action: { .alertTrashMakeAD($0) }))
    .confirmationDialog("", isPresented: viewStore.$isShowActionSheet) {
      Button("Save GIF In Photos") {
        if let gifURL = viewStore.myAnimationURL {
          viewStore.send(.saveGIFInPhotos(gifURL))
        }
      }
      Button("Share") {
        if viewStore.myAnimationURL != nil {
          viewStore.send(.toggleIsShowShareView)
        }
      }
    }
    .sheet(isPresented: viewStore.$isShowShareView) {
      if let myAnimationURL = viewStore.myAnimationURL {
        ShareView(gifURL: myAnimationURL)
          .presentationDetents([.medium, .large])
      }
    }
    .fullScreenCover(
      isPresented: viewStore.$isShowAnimationListView,
      onDismiss: { viewStore.send(.onDismissAnimationListView) },
      content: {
        AnimationListView(isShow: viewStore.$isShowAnimationListView) { selectedAnimation in
          viewStore.send(.selectAnimation(selectedAnimation))
        }
        .addLoadingView(isShow: viewStore.isShowLoadingView, description: "Add Animation...")
        .alert(store: self.store.scope(state: \.$alertShared, action: { .alertShared($0) }))
      }
    )
  }
}

private extension ConfigureAnimationView {
  struct Title: View {
    let title = "ADD ANIMATION"
    let description = "Choose one of the motions by tapping human button to see your character perform it!"
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.title, weight: .semibold))
          .foregroundColor(ADUIKitAsset.Color.blue2.swiftUIColor)
        
        Text(description)
          .frame(maxWidth: .infinity)
      }
    }
  }
}

private extension ConfigureAnimationView {
  struct MyAnimationView: View {
    @ObservedObject var viewStore: MyViewStore
    
    var body: some View {
      RoundedRectangle(cornerRadius: 15)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .overlay(alignment: .center) {
          if let gifData = viewStore.state.myAnimationData {
            GIFImage(gifData: gifData)
          }
        }
    }
  }
}

private extension ConfigureAnimationView {
  struct TabBar: View {
    let trash = "trash"
    let fix = "arrowshape.turn.up.backward"
    let share = "square.and.arrow.up"
    let animation = "figure.dance"
    let strokeColor: Color = ADUIKitAsset.Color.blue2.swiftUIColor
    
    @ObservedObject var viewStore: MyViewStore
    
    var body: some View {
      RoundedRectangle(cornerRadius: 35)
        .frame(height: 70)
        .foregroundColor(.white)
        .shadow(radius: 7)
        .overlay {
          RoundedRectangle(cornerRadius: 35)
            .strokeBorder(strokeColor, lineWidth: 3)
            .frame(height: 70)
        }
        .overlay {
          HStack(spacing: 0) {
            TabBarButton(imageName: fix) {
              viewStore.send(.fixMakeAD)
            }
            TabBarButton(imageName: trash) {
              viewStore.send(.showAlertTrashMakeAD)
            }
            TabBarButton(imageName: share) {
              viewStore.send(.toggleIsShowShareActionSheet)
            }
            TabBarButton(imageName: animation) {
              viewStore.send(.toggleIsShowAnimationListView)
            }
          }
        }
    }
    
    @ViewBuilder
    func TabBarButton(
      imageName: String,
      action: @escaping () -> ()
    ) -> some View {
      Button(action: action) {
        Image(systemName: imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding(.vertical)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .foregroundColor(strokeColor)
      }
    }
  }
}

// MARK: - Previews
struct ConfigureAnimationView_Previews: PreviewProvider {
  static var previews: some View {
    ConfigureAnimationView()
  }
}
