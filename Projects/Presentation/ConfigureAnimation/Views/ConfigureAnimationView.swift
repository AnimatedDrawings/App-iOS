//
//  ConfigureAnimationView.swift
//  AD_UI
//
//  Created by minii on 2023/07/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import ADResources
import ADUIKit
import ConfigureAnimationFeatures
import SwiftUI

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
    .addLoadingView(
      isShow: store.configure.loadingView,
      description: store.configure.loadingDescription
    )
    .alertNetworkError(isPresented: $store.configure.networkError)
    .alertWorkLoadHighError(isPresented: $store.configure.fullJob)
    .alertStartRendering(
      isPresented: $store.configure.alertStartRendering,
      okAction: {
        store.send(.view(.configure(.okActionInAlertStartRendering)))
      },
      cancelAction: {}
    )
  }
}

// MARK: - Component
extension ConfigureAnimationView {
  fileprivate struct Title: View {
    let title = "ADD ANIMATION"
    let description =
      "Choose one of the motions by tapping human button to see your character perform it!"

    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        Text(title)
          .font(.system(.title, weight: .semibold))
          .foregroundColor(ADResourcesAsset.Color.blue2.swiftUIColor)

        Text(description)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, 10)
    }
  }
}

extension ConfigureAnimationView {
  fileprivate struct MyAnimationView: View {
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
extension ConfigureAnimationView {
  fileprivate struct TabBar: View {
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
      action: @escaping () -> Void
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
extension View {
  fileprivate func trashDialogs(
    store: StoreOf<ConfigureAnimationFeature>
  ) -> some View {
    self.modifier(
      ConfigureAnimationView.TrashAlertModifier(store: store)
    )
  }
}

extension ConfigureAnimationView {
  fileprivate struct TrashAlertModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>

    func body(content: Content) -> some View {
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

// MARK: - Share Dialogs
extension View {
  fileprivate func shareDialogs(
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

extension ConfigureAnimationView {
  fileprivate struct SaveGifResultModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>

    var title: String {
      store.share.saveResult.isSuccess ? "Save Success!" : "Save GIF Error"
    }

    var description: String {
      store.share.saveResult.isSuccess ? "" : "Cannot Save GIF.. Try again"
    }

    func body(content: Content) -> some View {
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

extension ConfigureAnimationView {
  fileprivate struct NoAnimationFileModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>

    func body(content: Content) -> some View {
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

extension ConfigureAnimationView {
  fileprivate struct ShareSheetModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>

    func body(content: Content) -> some View {
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

extension ConfigureAnimationView {
  fileprivate struct ShareFileModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>

    func body(content: Content) -> some View {
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

// MARK: - AnimationList Dialogs
extension View {
  fileprivate func animationListDialogs(
    store: StoreOf<ConfigureAnimationFeature>
  ) -> some View {
    self
      .modifier(
        ConfigureAnimationView.AnimationListModifier(store: store)
      )
  }
}

extension ConfigureAnimationView {
  fileprivate struct AnimationListModifier: ViewModifier {
    @Bindable var store: StoreOf<ConfigureAnimationFeature>

    func body(content: Content) -> some View {
      content
        .fullScreenCover(
          isPresented: $store.configure.animationListView,
          onDismiss: {
            store.send(.view(.configure(.onDismissAnimationListView)))
          },
          content: {
            AnimationListView(
              cancelButtonAction: {
                store.send(.view(.configure(.cancelButtonInAnimationList)))
              },
              selectAnimationItem: { selectedAnimation in
                store.send(.view(.configure(.selectAnimationItem(selectedAnimation))))
              }
            )
          },
        )
    }
  }
}

private extension View {
  func alertStartRendering(
    isPresented: Binding<Bool>,
    okAction: @escaping () -> (),
    cancelAction: @escaping () -> ()
  ) -> some View {
    self.alert(
      "Animation Rendering Start",
      isPresented: isPresented,
      actions: {
        Button("Start", action: okAction)
        Button("Cancel", action: cancelAction)
      },
      message: {
        Text("Rendering can take up to 2 minutes. While rendering is in progress, you can support us by watching an advertisement, and once the ad ends, your animation will be complete.")
      }
    )
  }
}
