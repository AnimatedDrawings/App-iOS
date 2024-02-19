//
//  ADID.swift
//  SharedProvider
//
//  Created by chminii on 2/6/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import SharedStorage
import ThirdPartyLib

public struct ADID {
  public var id: CombineNotifier<String?>
  
  public init(id: String? = nil) {
    self.id = CombineNotifier(initialValue: id)
  }
}

extension ADID: DependencyKey {
  public static var liveValue = ADID()
  public static var testValue = ADID()
}

public extension DependencyValues {
  var adInfo: ADID {
    get { self[ADID.self] }
    set { self[ADID.self] = newValue }
  }
}
