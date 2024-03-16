//
//  MakeADProviderImplTests.swift
//  NetworkProviderTests
//
//  Created by chminii on 3/14/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import NetworkProvider
import NetworkStorage
import ADComposableArchitecture
import NetworkProviderTestings
import ADErrors
import ADResources
import DomainModels
import CoreModels

final class MakeADProviderImplTests: XCTestCase {
  var makeADProviderImpl: MakeADProviderImpl!
  
  override func setUp() {
    let storage = MockMakeADStorage(downloadMaskImage: Data())
    self.makeADProviderImpl = MakeADProviderImpl(storage: storage)
  }
  
  func testUploadDrawing() async {
    let boundingBox = BoundingBox(dto: BoundingBoxDTO.mockExample2())
    guard let response = try? await makeADProviderImpl.uploadDrawing(image: Data()) else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(response.ad_id, "uploadDrawing")
    XCTAssertEqual(response.boundingBox, boundingBox)
  }
  
  func testFindTheCharacter() async {
    do {
      let _ = try await makeADProviderImpl.findTheCharacter(
        ad_id: "",
        boundingBox: BoundingBox.mockExample2()
      )
    } catch {
      XCTFail()
      return
    }
  }
  
  func testDownloadMaskImage() async {
    guard let downloadMaskImage = ADResourcesAsset.TestImages.example2.image.pngData() else {
      XCTFail()
      return
    }
    let storage = MockMakeADStorage(downloadMaskImage: downloadMaskImage)
    makeADProviderImpl = MakeADProviderImpl(storage: storage)
    
    guard let response = try? await makeADProviderImpl.downloadMaskImage(ad_id: ""),
          let maskImageData = response.image.pngData()
    else {
      XCTFail()
      return
    }
    
    XCTAssertNotEqual(maskImageData, Data())
  }
  
  func testDownloadMaskImageThrowMaskDataToImage() async {
    do {
      let _ = try await makeADProviderImpl.downloadMaskImage(ad_id: "")
    } catch let error {
      if let error = error as? MakeADProviderError,
        error == .maskDataToImage
      {
        return
      }
    }
    
    XCTFail()
  }
  
  func testSeparateCharacter() async {
    let joints = Joints(dto: JointsDTO.example2Mock())
    guard let response = try? await makeADProviderImpl.separateCharacter(
      ad_id: "",
      maskedImage: Data()
    )
    else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(response.joints, joints)
  }
  
  func testFindCharacterJoints() async {
    do {
      let _ = try await makeADProviderImpl.findCharacterJoints(
        ad_id: "", 
        joints: Joints.mockExample2()
      )
    } catch {
      XCTFail()
      return
    }
  }
}
