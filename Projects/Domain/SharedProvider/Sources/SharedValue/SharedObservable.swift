//
//  SharedObservable.swift
//  SharedProvider
//
//  Created by minii on 2023/10/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import SharedStorage

class SharedObservable<Output: Equatable>: ObservableObject {
  var value: Output {
    get {
      return myValue
    }
    set {
      Task {
        await notifier.set(newValue)
      }
    }
  }
  
  private var myValue: Output {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.objectWillChange.send()
      }
    }
  }
  
  let notifier: CombineNotifier<Output>
  
  init(notifier: CombineNotifier<Output>) {
    self.notifier = notifier
    self.myValue = notifier.initialValue
    Task {
      for await tmpValue in await notifier.values() {
        myValue = tmpValue
      }
    }
  }
}
