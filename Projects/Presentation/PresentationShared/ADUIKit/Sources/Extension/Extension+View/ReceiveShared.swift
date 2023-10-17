//
//  receiveShared.swift
//  ADUIKit
//
//  Created by minii on 2023/10/17.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ThirdPartyLib
import SharedStorage

public extension View {
  func receiveShared<Output: Equatable>(
    _ keyPath: KeyPath<DependencyValues, CombineNotifier<Output>>,
    action: @escaping (Output) -> ()
  ) -> some View {
    let notifier = DependencyValues._current[keyPath: keyPath]
    
    return self.task {
      for await receivedValue in await notifier.values() {
        action(receivedValue)
      }
    }
  }
}
