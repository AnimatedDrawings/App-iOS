//
//  ReceiveShared.swift
//  SharedProvider
//
//  Created by chminii on 3/17/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ADComposableArchitecture

public extension View {
  func receiveShared<Output: Equatable>(
    _ keyPath: KeyPath<DependencyValues, GlobalNotifier<Output>>,
    action: @escaping (Output) -> ()
  ) -> some View {
    self.modifier(
      ReceiveSharedViewModifier(
        keyPath: keyPath,
        action: action
      )
    )
  }
}

struct ReceiveSharedViewModifier<Output: Equatable>: ViewModifier {
  let notifier: GlobalNotifier<Output>
  let action: (Output) -> ()
  @State var receivedValue: Output
  @State var viewDidLoad = false
  
  init (
    keyPath: KeyPath<DependencyValues, GlobalNotifier<Output>>,
    action: @escaping (Output) -> ()
  ) {
    self.notifier = DependencyValues._current[keyPath: keyPath]
    self.action = action
    self._receivedValue = State(initialValue: notifier.initialValue)
  }
  
  func body(content: Content) -> some View {
    content
      .task {
        for await tmpReceivedValue in await notifier.values() {
          if receivedValue != tmpReceivedValue {
            receivedValue = tmpReceivedValue
            action(tmpReceivedValue)
          }
        }
      }
      .onAppear {
        if !viewDidLoad {
          action(receivedValue)
          viewDidLoad = true
        }
      }
  }
}
