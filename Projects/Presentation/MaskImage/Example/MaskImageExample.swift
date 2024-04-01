//
//  MaskImageExample.swift
//  MaskImageExample
//
//  Created by chminii on 1/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI

@main
struct MaskImageExample: App {
  var body: some Scene {
    WindowGroup {
      TestView()
    }
  }
}


import ADComposableArchitecture

struct TestView: View {
  var body: some View {
    VStack {
      NumView()
      ButtonView()
    }
  }
}

// MARK: - NumView

@Reducer
struct NumFeature {
  @Dependency(\.actionBridge) var actionBridge
  
  @ObservableState
  struct State: Equatable {
    var num: Int
    
    init(num: Int = 0) {
      self.num = num
    }
  }
  
  enum Action: Equatable {
    case increment
    case decrement
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .increment:
        state.num += 1
        actionBridge.action()
        return .none
      case .decrement:
        state.num -= 1
        return .none
      }
    }
  }
}

struct NumView: View {
  @Perception.Bindable var store: StoreOf<NumFeature>
  
  init() {
    self.store = Store(initialState: .init()) {
      NumFeature()
    }
  }
  
  var body: some View {
    VStack {
      Button {
        store.send(.increment)
      } label: {
        Text("testest")
      }
      
      WithPerceptionTracking {
        Text("Num : \(store.num)")
      }
    }
  }
}


// MARK: - ButtonView
@Reducer
struct ButtonFeature {
  @Dependency(\.actionBridge) var actionBridge
  
  @ObservableState
  struct State {
    
  }
  
  enum Action: Equatable {
    case increment
    case decrement
  }
  
  var body: some ReducerOf<ButtonFeature> {
    Reduce { state, action in
      switch action {
      case .increment:
        actionBridge.action()
        return .none
      case .decrement:
        return .none
      }
    }
  }
}


struct ButtonView: View {
//  @Perception.Bindable var store: StoreOf<ButtonFeature>
  var storeBox: StoreBox<ButtonFeature>
  
  init() {
    self.storeBox = StoreBox<ButtonFeature>(
      initialState: ButtonFeature.State(),
      reducer: ButtonFeature()
    )
//    self.store = Store(initialState: .init(), reducer: {
//      ButtonFeature()
//    })
  }
  
  var body: some View {
    HStack(spacing: 30) {
      Button {
//        store.send(.decrement)
        storeBox.store.send(.decrement)
      } label: {
        Text("-")
      }
      
      Button {
//        storeBox.withDependencies {
//          $0.actionBridge = ActionBridge {
//            print("check")
//          }
//        }
//        store = StoreBox(initialState: store.state, reducer: ButtonFeature())
        
        print("efef")
         storeBox.withDependencies {
          $0.actionBridge = ActionBridge(
            action: {
              print("updateDependency")
            }
          )
        }
      } label: {
        Text("+")
      }
    }
  }
}

public struct ActionBridge {
  public var action: () -> ()
  
  public init(action: @escaping () -> Void) {
    self.action = action
  }
}

extension ActionBridge: DependencyKey {
  public static var liveValue = Self(action: {})
}

public extension DependencyValues {
  var actionBridge: ActionBridge {
    get { self[ActionBridge.self] }
    set { self[ActionBridge.self] = newValue }
  }
}


//let store = storeBox.withDependencies {
//  $0.actionBridge = ActionBridge { action in
//    // 다른 Store 에게 Action을 전송할 수 있습니다.
//  }
//}


public struct StoreBox<R: Reducer> {
  final class Dependency {
    var mutate: ((inout DependencyValues) -> Void)?
    
    func withDependencies(_ values: inout DependencyValues) {
      self.mutate?(&values)
    }
  }
  
  private let dependency = Dependency()
  
  public let store: StoreOf<R>
  public var state: R.State { self.store.withState { $0 } }
  
  public init(
    initialState: R.State,
    reducer: R
  ) {
    self.store = StoreOf<R>(
      initialState: initialState,
      reducer: { reducer },
      withDependencies: self.dependency.withDependencies
    )
  }
  
  @discardableResult
  public func withDependencies(_ mutate: @escaping (inout DependencyValues) -> Void) -> StoreOf<R> {
    self.dependency.mutate = mutate
    return self.store
  }
}

extension StoreBox: Identifiable where R.State: Identifiable {
  public var id: R.State.ID { self.state.id }
}

extension StoreBox: Equatable where R.State: Identifiable {
  public static func == (lhs: StoreBox<R>, rhs: StoreBox<R>) -> Bool {
    lhs.id == rhs.id
  }
}
