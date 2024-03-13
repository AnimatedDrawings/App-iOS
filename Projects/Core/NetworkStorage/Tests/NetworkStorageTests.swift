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

final class NetworkStorageTests: XCTestCase {
  var networkStorage: NetworkStorage<MockStorageTargetType>!
  
  override func setUp() {
    let mockURLSession = MockURLSesson(responseJsonData: Data())
    networkStorage = NetworkStorage(session: mockURLSession)
  }
  
  func testRequestThrowJsonDecode() async {
    do {
      let response: MockResponse = try await networkStorage.request(.test)
    } catch let error {
      if let error = error as? NetworkError,
         error == .jsonDecode 
      {
        return
      }
    }
    
    XCTFail()
  }
  
  func testRequestThrowServer() async {
    let mockResponse = MockResponse()
    guard let responseJsonData = defaultResponseToJsonData(isSuccess: false, response: mockResponse) else {
      XCTFail()
      return
    }
    let mockURLSession = MockURLSesson(responseJsonData: responseJsonData)
    networkStorage = NetworkStorage(session: mockURLSession)
    
    do {
      let response: MockResponse = try await networkStorage.request(.test)
    } catch let error {
      if let error = error as? NetworkError,
         error == .server
      {
        return
      }
    }
    
    XCTFail()
  }
  
  func testRequestReturnEmptyResponse() async {
    let mockResponse = EmptyResponse()
    guard let responseJsonData = defaultResponseToJsonData(response: mockResponse) else {
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
    guard let responseJsonData = defaultResponseToJsonData(response: mockResponse) else {
      XCTFail()
      return
    }
    let mockURLSession = MockURLSesson(responseJsonData: responseJsonData)
    networkStorage = NetworkStorage(session: mockURLSession)
    
    do {
      let response: MockResponse = try await networkStorage.request(.test)
    } catch let error {
      if let error = error as? NetworkError,
         error == .emptyResponse
      {
        return
      }
    }
    
    XCTFail()
  }
  
  func testRequestReturnActualResponse() async {
    let mockResponse = MockResponse()
    guard let responseJsonData = defaultResponseToJsonData(response: mockResponse) else {
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

import NetworkStorageInterfaces

extension NetworkStorageTests {
  func defaultResponseToJsonData<R: Responsable>(
    isSuccess: Bool = true,
    message: String = "message",
    response: R?
  ) -> Data?
  {
    let defaultResponse = DefaultResponse(
      isSuccess: isSuccess,
      message: message,
      response: response
    )
    
    return try? JSONEncoder().encode(defaultResponse)
  }
}
