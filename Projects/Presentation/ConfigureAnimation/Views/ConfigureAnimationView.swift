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
  @Bindable var store: StoreOf<ConfigureAnimationFeature>
  
  public init(
    store: StoreOf<ConfigureAnimationFeature> = Store(initialState: .init()) {
      ConfigureAnimationFeature()
    }
  ) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        Title()
        
        Spacer().frame(height: 50)
        
        MyAnimationView(gifData: store.currentAnimation?.data)
        
        Spacer().frame(height: 50)
        
        TabBar(store: store)
        
        Spacer().frame(height: 20)
      }
      .padding()
      .addADBackground()
      .trashDialogs(store: store)
      .shareDialogs(store: store)
      .animationListDialogs(store: store)
    }
  }
}

// MARK: - Component
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
    @Bindable var store: StoreOf<ConfigureAnimationFeature>
    
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
              store.send(.view(.fix))
            }
            TabBarButton(imageName: trash) {
              store.send(.view(.trash(.showAlert)))
            }
            TabBarButton(imageName: share) {
              store.send(.view(.share(.showShareSheet)))
            }
            TabBarButton(imageName: animation) {
              store.send(.view(.configure(.pushAnimationListView)))
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

// MARK: - Trash Dialogs
fileprivate extension View {
  func trashDialogs(
    store: StoreOf<ConfigureAnimationFeature>
  ) -> some View {
    self.modifier(
      ConfigureAnimationView.TrashAlertModifier(store: store)
    )
  }
}

fileprivate extension ConfigureAnimationView {
  struct TrashAlertModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>
    
    func body(content: Content) -> some View {
      WithPerceptionTracking {
        content
          .alert(
            "Reset Animated Drawing",
            isPresented: $store.trash.alert,
            actions: {
              Button("Cancel", action: {})
              Button(
                action: store.action(.view(.trash(.trashAlertActions(.confirm)))),
                label: {
                  Text("Reset")
                    .foregroundColor(.red)
                }
              )
            },
            message: {
              Text("Are you sure to reset making animation all step?")
            }
          )
      }
    }
  }
}

// MARK: - Share Dialogs
fileprivate extension View {
  func shareDialogs(
    store: StoreOf<ConfigureAnimationFeature>
  ) -> some View {
    self
      .modifier(
        ConfigureAnimationView.SaveGifResultModifier(store: store)
      )
      .modifier(
        ConfigureAnimationView.NoAnimationFileModifier(store: store)
      )
      .modifier(
        ConfigureAnimationView.ShareSheetModifier(store: store)
      )
      .modifier(
        ConfigureAnimationView.ShareFileModifier(store: store)
      )
  }
}

fileprivate extension ConfigureAnimationView {
  struct SaveGifResultModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>
    
    var title: String {
      store.share.saveResult.isSuccess ?
      "Save Success!" :
      "Save GIF Error"
    }
    
    var description: String {
      store.share.saveResult.isSuccess ?
      "" :
      "Cannot Save GIF.. Try again"
    }
    
    func body(content: Content) -> some View {
      WithPerceptionTracking {
        content
          .alert(
            title,
            isPresented: $store.share.saveResult.alert,
            actions: {
              Button("OK", action: {})
            },
            message: {
              Text(description)
            }
          )
      }
    }
  }
}

fileprivate extension ConfigureAnimationView {
  struct NoAnimationFileModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>
    
    func body(content: Content) -> some View {
      WithPerceptionTracking {
        content
          .alert(
            "No Animated Drawings File",
            isPresented: $store.share.alertNoAnimation,
            actions: {
              Button("Cancel", action: {})
            },
            message: {
              Text("The file does not exist. Make a Animation First")
            }
          )
      }
    }
  }
}

fileprivate extension ConfigureAnimationView {
  struct ShareSheetModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>
    
    func body(content: Content) -> some View {
      WithPerceptionTracking {
        content
          .confirmationDialog("", isPresented: $store.share.sheetShare) {
            Button("Save GIF In Photos") {
              store.send(.view(.share(.shareSheetActions(.save))))
            }
            Button("Share GIF") {
              store.send(.view(.share(.shareSheetActions(.share))))
            }
          }
      }
    }
  }
}

fileprivate extension ConfigureAnimationView {
  struct ShareFileModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>
    
    func body(content: Content) -> some View {
      WithPerceptionTracking {
        content
          .sheet(isPresented: $store.share.sheetShareFile) {
            if let currentAnimation = store.currentAnimation {
              ShareView(gifURL: currentAnimation.url)
            } else {
              Text("No Animation File")
            }
          }
      }
    }
  }
}

// MARK: - AnimationList Dialogs
fileprivate extension View {
  func animationListDialogs(
    store: StoreOf<ConfigureAnimationFeature>
  ) -> some View {
    self
      .modifier(
        ConfigureAnimationView.AnimationListModifier(store: store)
      )
  }
}


fileprivate extension ConfigureAnimationView {
  struct AnimationListModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>
    
    func body(content: Content) -> some View {
      WithPerceptionTracking {
        content
          .fullScreenCover(
            isPresented: $store.configure.animationListView,
            content: {
              AnimationListView(
                popViewState: $store.configure.animationListView,
                selectAnimationItem: { selectedAnimation in
                  store.send(.view(.configure(.selectAnimationItem(selectedAnimation))))
                }
              )
              .addLoadingView(
                isShow: store.configure.loadingView,
                description: "Add Animation..."
              )
              .alertNetworkError(isPresented: $store.configure.networkError)
            }
          )
      }
    }
  }
}
