//
//  receiveShared.swift
//  ADUIKit
//
//  Created by minii on 2023/10/17.
//  Copyright © 2023 chminipark. All rights reserved.
//

//import SwiftUI
//import ADComposableArchitecture
//import SharedStorage
//
//public extension View {
//  func receiveShared<Output: Equatable>(
//    _ keyPath: KeyPath<DependencyValues, CombineNotifier<Output>>,
//    action: @escaping (Output) -> ()
//  ) -> some View {
//    self.modifier(
//      ReceiveSharedViewModifier(
//        keyPath: keyPath,
//        action: action
//      )
//    )
//  }
//}
//
//struct ReceiveSharedViewModifier<Output: Equatable>: ViewModifier {
//  let notifier: CombineNotifier<Output>
//  let action: (Output) -> ()
//  @State var receivedValue: Output
//  @State var viewDidLoad = false
//  
//  init (
//    keyPath: KeyPath<DependencyValues, CombineNotifier<Output>>,
//    action: @escaping (Output) -> ()
//  ) {
//    self.notifier = DependencyValues._current[keyPath: keyPath]
//    self.action = action
//    self._receivedValue = State(initialValue: notifier.initialValue)
//  }
//  
//  func body(content: Content) -> some View {
//    content
//      .task {
//        for await tmpReceivedValue in await notifier.values() {
//          if receivedValue != tmpReceivedValue {
//            receivedValue = tmpReceivedValue
//            action(tmpReceivedValue)
//          }
//        }
//      }
//      .onAppear {
//        if !viewDidLoad {
//          action(receivedValue)
//          viewDidLoad = true
//        }
//      }
//  }
//}
