//
//  NetworkStorageTests.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import NetworkStorage
import NetworkStorageTestings
import ADErrors
import CoreModels
import NetworkStorageInterfaces

final class NetworkStorageTests: XCTestCase {
  var networkStorage: NetworkStorage<MockStorageTargetType>!
  
  override func setUp() {
    let mockURLSession = MockURLSesson(responseJsonData: Data())
    networkStorage = NetworkStorage(session: mockURLSession)
  }
  
  func testRequestThrowJsonDecode() async {
    do {
      let _: MockResponse = try await networkStorage.request(.test)
    } catch let error {
      if let error = error as? NetworkStorageError,
         error == .jsonDecode 
      {
        return
      }
    }
    
    XCTFail()
  }
  
  func testRequestThrowServer() async {
    let mockResponse = MockResponse()
    let defaultResponse = DefaultResponse(isSuccess: false, message: "", response: mockResponse)
    guard let responseJsonData = defaultResponse.toJsonData() else {
      XCTFail()
      return
    }
    let mockURLSession = MockURLSesson(responseJsonData: responseJsonData)
    networkStorage = NetworkStorage(session: mockURLSession)
    
    do {
      let _: MockResponse = try await networkStorage.request(.test)
    } catch let error {
      if let error = error as? NetworkStorageError,
         error == .server
      {
        return
      }
    }
    
    XCTFail()
  }
  
  func testRequestReturnEmptyResponse() async {
    let mockResponse = EmptyResponse()
    let defaultResponse = DefaultResponse(isSuccess: true, message: "", response: mockResponse)
    guard let responseJsonData = defaultResponse.toJsonData() else {
      XCTFail()
      return
    }
    let mockURLSession = MockURLSesson(responseJsonData: responseJsonData)
    networkStorage = NetworkStorage(session: mockURLSession)
    
    let response: EmptyResponse
    do {
      response = try await networkStorage.request(.test)
    } catch {
      XCTFail()
      return
    }
    
    XCTAssertEqual(mockResponse, response)
  }
  
  func testRequestThrowEmptyResponse() async {
    let mockResponse: MockResponse? = nil
    let defaultResponse = DefaultResponse(isSuccess: true, message: "", response: mockResponse)
    guard let responseJsonData = defaultResponse.toJsonData() else {
      XCTFail()
      return
    }
    let mockURLSession = MockURLSesson(responseJsonData: responseJsonData)
    networkStorage = NetworkStorage(session: mockURLSession)
    
    do {
      let _: MockResponse = try await networkStorage.request(.test)
    } catch let error {
      if let error = error as? NetworkStorageError,
         error == .emptyResponse
      {
        return
      }
    }
    
    XCTFail()
  }
  
  func testRequestReturnActualResponse() async {
    let mockResponse = MockResponse()
    let defaultResponse = DefaultResponse(isSuccess: true, message: "", response: mockResponse)
    guard let responseJsonData = defaultResponse.toJsonData() else {
      XCTFail()
      return
    }
    let mockURLSession = MockURLSesson(responseJsonData: responseJsonData)
    networkStorage = NetworkStorage(session: mockURLSession)
    
    let response: MockResponse
    do {
      response = try await networkStorage.request(.test)
    } catch {
      XCTFail()
      return
    }
    
    XCTAssertEqual(mockResponse, response)
  }
  
  func testDownload() async {
    let responseData: Data
    do {
      responseData = try await networkStorage.download(.test)
    } catch {
      XCTFail()
      return
    }
    
    XCTAssertEqual(responseData, Data())
  }
}
