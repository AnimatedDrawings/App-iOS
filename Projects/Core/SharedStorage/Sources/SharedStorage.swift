//
//  SharedStorage.swift
//  SharedStorage
//
//  Created by minii on 2023/10/01.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public class SharedStorage<Output: Equatable>: ObservableObject {
  public var value: Output {
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
    willSet {
      DispatchQueue.main.async { [weak self] in
        self?.objectWillChange.send()
      }
    }
  }
  
  let notifier: CombineNotifier<Output>
  
  public init(notifier: CombineNotifier<Output>) {
    self.notifier = notifier
    self.myValue = notifier.initialValue
    Task {
      for await tmpValue in await notifier.values() {
        myValue = tmpValue
      }
    }
  }
}
