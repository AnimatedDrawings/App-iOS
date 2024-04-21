//
//  MaskImageViewActionTests.swift
//  MaskImageTests
//
//  Created by chminii on 4/1/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
import ADComposableArchitecture
import MaskImageFeatures
import ADResources

final class MaskImageViewActionTests: XCTestCase {
  var store: TestStoreOf<MaskImageFeature>!
  
  override func setUp() {
    let croppedImage: UIImage = ADResourcesAsset.TestImages.croppedImage.image
    let maskedImage: UIImage = ADResourcesAsset.TestImages.maskedImage.image
    let maskImageState: MaskImageFeature.State = .init(croppedImage: croppedImage, maskedImage: maskedImage)
    store = TestStore(initialState: maskImageState) {
      MaskImageFeature()
    }
  }
  
  func testSave() async {
    await store.send(.view(.save)) {
      $0.triggerState.save = !$0.triggerState.save
    }
  }
  
  func testCancel() async {
    await store.send(.view(.cancel))
    await store.receive(.delegate(.cancel))
  }
  
  func testSetDrawingTool() async {
    let drawingTool: DrawingTool = .draw
    await store.send(.view(.maskToolAction(.setDrawingTool(drawingTool)))) {
      $0.triggerState.drawingTool = drawingTool
    }
  }
  
  func testSetMaskCache() async {
    await store.send(.view(.maskToolAction(.setMaskCache(.undo)))) {
      $0.triggerState.maskCache.undo = !$0.triggerState.maskCache.undo
    }
    
    await store.send(.view(.maskToolAction(.setMaskCache(.reset)))) {
      $0.triggerState.maskCache.reset = !$0.triggerState.maskCache.reset
    }
  }
  
  func testChangeToolCircleSize() async {
    let toolCircleSize: CGFloat = 40
    
    await store.send(.view(.maskToolAction(.changeToolCircleSize(toolCircleSize)))) {
      $0.toolCircleSize = toolCircleSize
    }
  }
}
