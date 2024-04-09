//
//  ModifyJointsViewActionTests.swift
//  ModifyJointsTests
//
//  Created by chminii on 4/9/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import ModifyJointsFeatures
import ADComposableArchitecture
import DomainModels
import ADResources

final class ModifyJointsViewActionTests: XCTestCase {
  var store: TestStoreOf<ModifyJointsFeature>!
  
  override func setUp() {
    let joints: Joints = .mock()
    let croppedImage: UIImage = ADResourcesAsset.TestImages.croppedImage.image
    let state: ModifyJointsFeature.State = .init(
      skeletons: joints.skeletons,
      croppedImage: croppedImage
    )
    store = TestStore(initialState: state) {
      ModifyJointsFeature()
    }
  }
  
  func testSave() async {
    await store.send(.view(.save))
    
    store.exhaustivity = .off
    await store.receive(.delegate(.modifyJointsResult))
  }
  
  func testCancel() async {
    await store.send(.view(.cancel))
    store.exhaustivity = .off
    await store.receive(.delegate(.cancel))
  }
}
