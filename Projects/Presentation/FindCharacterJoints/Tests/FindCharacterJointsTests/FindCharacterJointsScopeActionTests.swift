//
//  FindCharacterJointsScopeActionTests.swift
//  FindCharacterJointsTests
//
//  Created by chminii on 4/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import FindCharacterJointsFeatures
import ADComposableArchitecture
import ModifyJointsFeatures
import DomainModels
import ADResources

final class FindCharacterJointsScopeActionTests: XCTestCase {
  var store: TestStoreOf<FindCharacterJointsFeature>!
  
  override func setUp() {
    let originJoints: Joints = .mock()
    let croppedImage: UIImage = ADResourcesAsset.TestImages.croppedImage.image
    let modifyJointsState: ModifyJointsFeature.State = .init(
      originJoints: originJoints,
      croppedImage: croppedImage
    )
    let state: FindCharacterJointsFeature.State = .init(modifyJoints: modifyJointsState)
    store = TestStore(initialState: state) {
      FindCharacterJointsFeature()
    }
  }
  
  func testCancel() async {
    await store.send(.scope(.modifyJoints(.delegate(.cancel))))
    
    store.exhaustivity = .off
    await store.receive(.inner(.popModifyJointsView))
  }
  
  func testModifyJointsResult() async {
    let joints: Joints = .mock()
    
    await store.send(.scope(.modifyJoints(.delegate(.modifyJointsResult(joints)))))
    
    store.exhaustivity = .off
    await store.receive(.async(.findCharacterJoints(joints)))
  }
}
