//
//  AddAnimationView.swift
//  AD_UI
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import AD_Feature
import AD_Utils
import ComposableArchitecture

struct AddAnimationView: ADUI {
  typealias MyFeature = AddAnimationFeature
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
      VStack(spacing: 20) {
        Title()
        
        Spacer()
        
        ResultView()
        
        Spacer()
        
        TabBar(with: viewStore)
        
        Spacer().frame(height: 20)
      }
      .padding()
      .adBackground()
      .sheet(isPresented: viewStore.$isShowAnimationListView) {
        AnimationListView { selectedAnimation in
          viewStore.send(.selectAnimation(selectedAnimation))
        }
        .presentationDragIndicator(.visible)
      }
    }
  }
}

extension AddAnimationView {
  @ViewBuilder
  func Title() -> some View {
    let title = "ADD ANIMATION"
    let description = "Choose one of the motions by tapping human button to see your character perform it!"
    
    VStack(alignment: .leading, spacing: 20) {
      Text(title)
        .font(.system(.largeTitle, weight: .semibold))
        .foregroundColor(strokeColor)
      
      Text(description)
    }
  }
}

extension AddAnimationView {
  @ViewBuilder
  func ResultView() -> some View {
    RoundedRectangle(cornerRadius: 15)
      .foregroundColor(.white)
      .shadow(radius: 10)
      .frame(height: 400)
  }
}

extension AddAnimationView {
  @ViewBuilder
  @MainActor
  func TabBar(with viewStore: MyViewStore) -> some View {
    let reset = "trash"
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
          TabBarButton(imageName: fix) {}
          TabBarButton(imageName: reset) {}
          TabBarButton(imageName: share) {}
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
    AddAnimationView()
  }
}

struct AddAnimationView_Previews: PreviewProvider {
  static var previews: some View {
    Previews_AddAnimationView()
  }
}
