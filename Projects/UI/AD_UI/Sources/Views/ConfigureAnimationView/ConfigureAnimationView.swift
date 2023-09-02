//
//  ConfigureAnimationView.swift
//  AD_UI
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture

struct ConfigureAnimationView: ADUI {
  typealias MyFeature = ConfigureAnimationFeature
  let store: StoreOf<MyFeature>
  
  let strokeColor: Color = ADUtilsAsset.Color.blue2.swiftUIColor
  
  init(
    store: StoreOf<MyFeature> = rootViewStore.scope(
      state: \.addAnimationState,
      action: RootViewFeature.Action.addAnimationAction
    )
  ) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        Title()
        
        Spacer().frame(height: 50)
        
        MyAnimationView(with: viewStore)
        
        Spacer().frame(height: 50)
        
        TabBar(with: viewStore)
        
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
}

extension ConfigureAnimationView {
  @ViewBuilder
  func Title() -> some View {
    let title = "ADD ANIMATION"
    let description = "Choose one of the motions by tapping human button to see your character perform it!"
    
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .font(.system(.title, weight: .semibold))
        .foregroundColor(ADUtilsAsset.Color.blue2.swiftUIColor)
      
      Text(description)
        .frame(maxWidth: .infinity)
    }
  }
}

extension ConfigureAnimationView {
  @ViewBuilder
  @MainActor
  func MyAnimationView(with viewStore: MyViewStore) -> some View {
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

extension ConfigureAnimationView {
  @ViewBuilder
  @MainActor
  func TabBar(with viewStore: MyViewStore) -> some View {
    let trash = "trash"
    let fix = "arrowshape.turn.up.backward"
    let share = "square.and.arrow.up"
    let animation = "figure.dance"
    
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
            viewStore.send(.toggleIsShowAddAnimationView)
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

struct Previews_AddAnimationView: View {
  var body: some View {
    ConfigureAnimationView()
  }
}

struct AddAnimationView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_AddAnimationView()
  }
}
