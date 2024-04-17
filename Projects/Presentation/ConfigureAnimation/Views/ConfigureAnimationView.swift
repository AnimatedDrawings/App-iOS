//
//  ConfigureAnimationView.swift
//  AD_UI
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture
import ConfigureAnimationFeatures
import ADUIKit
import ADResources

public struct ConfigureAnimationView: View {
  @Perception.Bindable var store: StoreOf<ConfigureAnimationFeature>
  
  public init(
    store: StoreOf<ConfigureAnimationFeature> = Store(initialState: .init()) {
      ConfigureAnimationFeature()
    }
  ) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Title()
      
      Spacer().frame(height: 50)
      
      MyAnimationView(gifData: nil)
      
      Spacer().frame(height: 50)
      
      TabBar(store: store)
      
      Spacer().frame(height: 20)
    }
    .padding()
    .addADBackground()
    .alertTrashMakeAD(
      isPresented: $store.alert.trash,
      resetAction: store.action(.view(.tabBar(.trash(.confirmTrash))))
    )
    .alertSaveGIFInPhotosResult(
      isPresented: $store.alert.saveGif.toggle,
      isSuccess: store.alert.saveGif.isSuccess
    )
    .alertNoAnimationFile(isPresented: $store.alert.noAnimation)
    .confirmationDialog("", isPresented: $store.isShowActionSheet) {
      Button("Save GIF In Photos") {
        if let gifURL = store.myAnimationURL {
          store.send(.saveGIFInPhotos(gifURL))
        }
      }
      Button("Share") {
        if store.myAnimationURL != nil {
          store.send(.toggleIsShowShareView)
        }
      }
    }
    .sheet(isPresented: $store.isShowShareView) {
      if let myAnimationURL = store.myAnimationURL {
        ShareView(gifURL: myAnimationURL)
          .presentationDetents([.medium, .large])
      }
    }
    .fullScreenCover(
      isPresented: $store.isShowAnimationListView,
      onDismiss: { store.send(.onDismissAnimationListView) },
      content: {
        AnimationListView(isShow: $store.isShowAnimationListView) { selectedAnimation in
          store.send(.selectAnimation(selectedAnimation))
        }
        .addLoadingView(isShow: store.isShowLoadingView, description: "Add Animation...")
        .alertNetworkError(isPresented: $store.isShowNetworkErrorAlert)
      }
    )
  }
}

extension View {
  func alertSaveGIFInPhotosResult(
    isPresented: Binding<Bool>,
    isSuccess: Bool
  ) -> some View {
    let title = isSuccess ? "Save Success!" : "Save GIF Error"
    let description = isSuccess ? "" : "Cannot Save GIF.. Try again"
    
    return self.alert(
      title,
      isPresented: isPresented,
      actions: {
        Button("OK", action: {})
      },
      message: {
        Text(description)
      }
    )
  }
  
  func alertTrashMakeAD(
    isPresented: Binding<Bool>,
    resetAction: @escaping () -> ()
  ) -> some View {
    return self.alert(
      "Reset Animated Drawing",
      isPresented: isPresented,
      actions: {
        Button("Cancel", action: {})
        Button(action: resetAction) {
          Text("Reset")
            .foregroundColor(.red)
        }
      },
      message: {
        Text("Are you sure to reset making animation all step?")
      }
    )
  }
  
  func alertNoAnimationFile(
    isPresented: Binding<Bool>
  ) -> some View {
    self.alert(
      "No Animated Drawings File",
      isPresented: isPresented,
      actions: {
        Button("Cancel", action: {})
      },
      message: {
        Text("The file does not exist. Make a Animation First")
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
          .foregroundColor(ADResourcesAsset.Color.blue2.swiftUIColor)
        
        Text(description)
          .frame(maxWidth: .infinity)
      }
    }
  }
}

private extension ConfigureAnimationView {
  struct MyAnimationView: View {
    let gifData: Data?
    
    var body: some View {
      RoundedRectangle(cornerRadius: 15)
        .foregroundColor(.white)
        .shadow(radius: 10)
        .overlay(alignment: .center) {
          if let gifData = gifData {
            GIFImage(gifData: gifData)
          }
        }
    }
  }
}

private extension ConfigureAnimationView {
  struct TabBar: View {
    @Perception.Bindable var store: StoreOf<ConfigureAnimationFeature>
    
    let trash = "trash"
    let fix = "arrowshape.turn.up.backward"
    let share = "square.and.arrow.up"
    let animation = "figure.dance"
    let strokeColor: Color = ADResourcesAsset.Color.blue2.swiftUIColor
    
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
              store.send(.view(.tabBar(.fix)))
            }
            TabBarButton(imageName: trash) {
              store.send(.view(.tabBar(.trash(.showAlert))))
            }
            TabBarButton(imageName: share) {
              store.send(.view(.tabBar(.share)))
            }
            TabBarButton(imageName: animation) {
              store.send(.view(.tabBar(.animation)))
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
