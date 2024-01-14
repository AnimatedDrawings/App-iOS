//
//  CropImageTests.swift
//  CropImageExample
//
//  Created by chminii on 1/13/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
import CropImageFeatures
import ThirdPartyLib
import SharedProvider

final class CropImageTests: XCTestCase {
  var store: TestStoreOf<CropImageFeature>!
  var mockOriginalImage: UIImage!
  
  override func setUp() {
    super.setUp()
    self.store = TestStore(initialState: .init()) {
      CropImageFeature()
    }
  }
  
  func testSave() async {
  }
}
