//
//  ADInfo.swift
//  SharedProvider
//
//  Created by chminii on 2/6/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import SharedStorage
import ThirdPartyLib

public struct ADInfo {
  public var id: CombineNotifier<String?>
  
  public init(id: String? = nil) {
    self.id = CombineNotifier(initialValue: id)
  }
}

extension ADInfo: DependencyKey {
  public static var liveValue = ADInfo()
  public static var testValue = ADInfo(id: "test")
}
