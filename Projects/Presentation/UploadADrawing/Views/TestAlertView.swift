//
//  TestAlertView.swift
//  UploadADrawing
//
//  Created by minii on 2023/10/18.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import SwiftUI

public struct TestAlertFeature: Reducer {
  public init() {}
  
  public struct State: Equatable {
    @PresentationState public var alertShared: AlertState<AlertShared>?
    
    public init(alertShared: AlertState<AlertShared>? = nil) {
      self.alertShared = alertShared
    }
  }
  
  public enum Action {
    case alertShared(PresentationAction<AlertShared>)
    case showAlertShared(AlertState<AlertShared>)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .alertShared:
        return .none
      case .showAlertShared(let alertState):
        state.alertShared = alertState
        return .none
      }
    }
    .ifLet(\.$alertShared, action: /Action.alertShared)
  }
}

public struct TestAlertView: ADUI {
  public typealias MyFeature = TestAlertFeature
  
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
    VStack {
      Button {
        viewStore.send(.showAlertShared(TestAlertFeature.initAlertNetworkError()))
      } label: {
        Text("Alert!")
          .font(.largeTitle)
      }
    }
    .alert(store: self.store.scope(state: \.$alertShared, action: { .alertShared($0) }))

    
//    .alert(store: self.store.scope(state: \.$alertShared, action: { .alertShared($0) }))
  }
}

public extension TestAlertFeature {
  enum AlertShared: Equatable {}
  
  static func initAlertNetworkError() -> AlertState<AlertShared> {
    return AlertState(
      title: {
        TextState("Connection Error")
      },
      actions: {
        ButtonState(role: .cancel) {
          TextState("Cancel")
        }
      },
      message: {
        TextState("Please check device network condition.")
      }
    )
  }
}
