//
//  ADInfoProvider.swift
//  SharedProvider
//
//  Created by chminii on 2/6/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import ADComposableArchitecture

public struct ADInfoProvider {
  public var id: GlobalNotifier<String?>
  
  public init(id: String? = nil) {
    self.id = GlobalNotifier(initialValue: id)
  }
}

extension ADInfoProvider: DependencyKey {
  public static var liveValue = ADInfoProvider()
  public static var testValue = ADInfoProvider(id: "test")
}
