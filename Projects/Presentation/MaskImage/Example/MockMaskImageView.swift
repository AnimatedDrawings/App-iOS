//
//  MockMaskImageView.swift
//  MaskImageExample
//
//  Created by chminii on 3/27/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADResources
import ADComposableArchitecture
import MaskImageFeatures

// MARK: - ParentView

@Reducer
struct MockParentFeatue {
  @ObservableState
  struct State: Equatable {
    var showResultView: Bool = false
    var maskedImage: UIImage = .init()
    var maskImage: MaskImageFeature.State
  }
  
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case maskImage(MaskImageFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.maskImage, action: \.maskImage) {
      MaskImageFeature()
    }
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .maskImage(let maskImageActions):
        switch maskImageActions {
        case .delegate(.maskImageResult(let maskImageResult)):
          state.showResultView.toggle()
          state.maskedImage = maskImageResult.image
          print("efefawfwe")
          return .none
        default:
          return .none
        }
      }
    }
  }
}

struct MockParentView: View {
  @Perception.Bindable var store: StoreOf<MockParentFeatue>
  
  init() {
    let maskImageState: MaskImageFeature.State = .mock()
    self.store = Store(initialState: MockParentFeatue.State(maskImage: maskImageState)) {
      MockParentFeatue()
    }
  }
  
  var body: some View {
    NavigationStack {
      WithPerceptionTracking {
        MockMaskImageView(store: store.scope(state: \.maskImage, action: \.maskImage))
          .navigationDestination(isPresented: $store.showResultView) {
            MockResultView(maskedImage: store.maskedImage)
          }
      }
    }
  }
}


// MARK: - ResultView

struct MockResultView: View {
  let maskedImage: UIImage
  
  var body: some View {
    Image(uiImage: maskedImage)
      .resizable()
      .padding()
  }
}


// MARK: - MaskImageView

struct MockMaskImageView: View {
  @Perception.Bindable var store: StoreOf<MaskImageFeature>
  
  init(store: StoreOf<MaskImageFeature>) {
    self.store = store
  }
  
  var body: some View {
    MaskImageView(store: store)
  }
}
