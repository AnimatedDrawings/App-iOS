//
//  ConfigureAnimationViewAction.swift
//  ConfigureAnimationFeatures
//
//  Created by chminii on 4/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADComposableArchitecture
import DomainModels
import GoogleMobileAds

extension ConfigureAnimationFeature {
  public enum ViewActions: Equatable {
    case fix
    case trash(TrashActions)
    case share(ShareActions)
    case configure(ConfigureActions)
  }

  public func ViewReducer() -> some ReducerOf<Self> {
    CombineReducers {
      FixReducer()
      TrashReducer()
      ShareReducer()
      ConfigureReducer()
    }
  }
}

// MARK: - Fix Actions

extension ConfigureAnimationFeature {
  public func FixReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(let viewActions):
        switch viewActions {
        case .fix:
          return .run { send in
            await step.isShowStepBar.set(true)
            await adViewState.adViewState.set(.MakeAD)
          }

        default:
          return .none
        }

      default:
        return .none
      }
    }
  }
}

// MARK: - Trash Actions

extension ConfigureAnimationFeature {
  public enum TrashActions: Equatable {
    case showAlert
    case trashAlertActions(TrashAlertActions)
  }

  public enum TrashAlertActions: Equatable {
    case confirm
  }

  public func TrashReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(.trash(let trashActions)):
        switch trashActions {
        case .showAlert:
          state.trash.alert.toggle()
          return .none
        case .trashAlertActions(.confirm):
          return .send(.delegate(.resetMakeAD))
        }

      default:
        return .none
      }
    }
  }
}

// MARK: - Trash Actions

extension ConfigureAnimationFeature {
  public enum ShareActions: Equatable {
    case showShareSheet
    case shareSheetActions(ShareSheetActions)
  }

  public enum ShareSheetActions: Equatable {
    case save
    case share
  }

  public func ShareReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(.share(let shareActions)):
        switch shareActions {
        case .showShareSheet:
          if state.currentAnimation == nil {
            return .send(.inner(.alertNoAnimationFile))
          }
          state.share.sheetShare.toggle()
          return .none

        case .shareSheetActions(let shareSheetActions):
          guard let currentAnimation = state.currentAnimation else {
            return .none
          }

          switch shareSheetActions {
          case .save:
            return .send(.async(.saveGifInPhotos(currentAnimation.url)))
          case .share:
            return .send(.inner(.sheetShareFile))
          }
        }

      default:
        return .none
      }
    }
  }
}

// MARK: - Configure Actions

extension ConfigureAnimationFeature {
  public enum ConfigureActions: Equatable {
    case pushAnimationListView
    case selectAnimationItem(ADAnimation)
  }

  public func ConfigureReducer() -> some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(.configure(let configureActions)):
        switch configureActions {
        case .pushAnimationListView:
          return .send(.inner(.toggleAnimationListView))

        case .selectAnimationItem(let animation):
          return .run { send in
            let loadADResult = await rewardADManager.loadAD()

            switch loadADResult {
            case .success:
              await send(.inner(.toggleAnimationListView))
              try? await Task.sleep(seconds: 3.0)
              
              let showADResult: ShowADResult = await rewardADManager.showAD()
              
              print("showADResult: \(showADResult)")
              
              return

            case .failure:
              await send(.inner(.alertNetworkError))
              return
            }
          }
        }

      default:
        return .none
      }
    }
  }
}

extension UIApplication {
  var rootViewController: UIViewController? {
    connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }?
      .rootViewController
  }
}
