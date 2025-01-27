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
struct MockMaskParentFeatue {
  @ObservableState
  struct State: Equatable {
    var resultView: Bool = false
    var maskImageView: Bool = false
    var resultImage: UIImage? = nil
    var maskImage: MaskImageFeature.State
  }
  
  @CasePathable
  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case maskImage(MaskImageFeature.Action)
    case pushMaskImageView
    case showResultView
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
          state.resultImage = maskImageResult.image
          state.maskImageView.toggle()
          return .none
        case .delegate(.cancel):
          state.maskImageView.toggle()
          return .none
        default:
          return .none
        }
        
      case .pushMaskImageView:
        state.maskImageView.toggle()
        return .none
        
      case .showResultView:
        state.resultView.toggle()
        return .none
      }
    }
  }
}

struct MockMaskParentView: View {
  @Bindable var store: StoreOf<MockMaskParentFeatue>
  
  init() {
    self.store = Store(initialState: MockMaskParentFeatue.State(maskImage: .mock())) {
      MockMaskParentFeatue()
    }
  }
  
  var body: some View {
    WithPerceptionTracking {
      NavigationStack {
        Button("push MaskImageView") {
          store.send(.pushMaskImageView)
        }
        .navigationDestination(isPresented: $store.resultView) {
          MockMaskResultView(maskedImage: store.resultImage)
        }
      }
      .fullScreenCover(
        isPresented: $store.maskImageView,
        onDismiss: { store.send(.showResultView) },
        content: {
          MockMaskImageView(store: store.scope(state: \.maskImage, action: \.maskImage))
        }
      )
    }
  }
}


// MARK: - ResultView

struct MockMaskResultView: View {
  let maskedImage: UIImage?
  
  var body: some View {
    if let maskedImage = maskedImage {
      Image(uiImage: maskedImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .overlay {
          Rectangle()
            .strokeBorder(.red, lineWidth: 3)
        }
        .padding()
    } else {
      Text("Fail")
    }
  }
}


// MARK: - MaskImageView

struct MockMaskImageView: View {
  @Bindable var store: StoreOf<MaskImageFeature>
  
  init(store: StoreOf<MaskImageFeature>) {
    self.store = store
  }
  
  var body: some View {
    MaskImageView(store: store)
  }
}
