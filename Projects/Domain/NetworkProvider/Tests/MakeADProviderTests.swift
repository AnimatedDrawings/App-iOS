//
//  MakeADProviderTests.swift
//  NetworkProviderTests
//
//  Created by chminii on 3/14/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import NetworkProvider
import NetworkStorage

final class MakeADProviderTests: XCTestCase {
  var makeADProvider: MakeADProvider!
  
  override func setUp() {
    makeADProvider = MakeADProvider.liveValue
    storage = MakeADStorage.shared
    storage = MakeADStorage()
  }
  
  func testUploadDrawing() {
    
  }
}
