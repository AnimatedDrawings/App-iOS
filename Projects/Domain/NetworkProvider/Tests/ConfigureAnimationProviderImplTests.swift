//
//  ConfigureAnimationProviderImplTests.swift
//  NetworkProviderTestings
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import NetworkProvider
import NetworkProviderTestings

final class ConfigureAnimationProviderImplTests: XCTestCase {
  var configureAnimationProviderImpl: ConfigureAnimationProviderImpl!
  
  override func setUp() {
    let storage = MockConfigureAnimationStorage()
    configureAnimationProviderImpl = ConfigureAnimationProviderImpl(storage: storage)
  }
  
  func testAdd() async {
    guard let _ = try? await configureAnimationProviderImpl.add(ad_id: "", animation: .dab) else {
      XCTFail()
      return
    }
  }
  
  func testDownload() async {
    guard let response = try? await configureAnimationProviderImpl
      .download(
        ad_id: "",
        animation: .dab
      )
    else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(response.animation, Data())
  }
}
