//
//  NetworkStorageTests.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

//import XCTest
//@testable import NetworkStorage
//
//final class NetworkStorageTests: XCTestCase {
//  private var mockURLSession: MockURLSesson!
//  private var mockNetworkStorage: NetworkStorage<MockTargetType>!
//  
//  override func setUp() {
//    super.setUp()
//    
//    mockURLSession = MockURLSesson(responseData: Data())
//    mockNetworkStorage = NetworkStorage<MockTargetType>(
//      session: mockURLSession
//    )
//  }
//  
//  func testNetworkStorageRequestEmptyResponse() async throws {
//    mockURLSession.responseData = .mockEmptyResponseData
//    
//    let emptyResponse: EmptyResponse = try await mockNetworkStorage.request(.requestEmptyResponse)
//    XCTAssertNoThrow(emptyResponse)
//  }
//  
//  func testNetworkStorageRequestDefaultResponse() async throws {
//    mockURLSession.responseData = .mockDefaultResponseData
//    
//    let mockResponse: MockResponse = try await mockNetworkStorage.request(.requestDefaultResponse)
//    XCTAssertNoThrow(mockResponse)
//    XCTAssertEqual(mockResponse.test, "test")
//  }
//  
//  func testNetworkStorageDownload() async throws {
//    let emptyData = Data()
//    
//    mockURLSession.responseData = emptyData
//    
//    let responseData = try await mockNetworkStorage.download(.download)
//    XCTAssertEqual(emptyData, responseData)
//  }
//}
