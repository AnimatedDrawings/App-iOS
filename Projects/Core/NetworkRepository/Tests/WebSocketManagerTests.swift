//
//  WebSocketManagerTests.swift
//  NetworkRepositoryTests
//
//  Created by chminii on 4/7/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import XCTest

@testable import NetworkRepository
@testable import NetworkRepositoryInterfaces

final class WebSocketMessageTests: XCTestCase {
  enum TestType: String {
    case test = "TEST"
  }

  func testInitWithDecodeMessageThrowDecodeMessage() {
    // given
    let jsonData = """
      {
        "type": "TEST_ERROR",
      }
      """.data(using: .utf8)!

    // when, then
    do {
      _ = try JSONDecoder().decode(WebSocketMessage<TestType>.self, from: jsonData)
      XCTFail("Failed to throw decode message")
    } catch {
      XCTAssertEqual(error as? WebSocketError, .decodeMessage)
    }
  }
  // given
  func testInitWithDecodeMessageSuccess() {
    // given
    let jsonData = """
      {
        "type": "TEST",
        "message": "test",
        "data": {
          "test": "test"
        }
      }
      """.data(using: .utf8)!

    // when
    guard
      let decodedMessage = try? JSONDecoder()
        .decode(
          WebSocketMessage<TestType>.self,
          from: jsonData
        )
    else {
      XCTFail("Failed to decode message")
      return
    }

    // then
    XCTAssertEqual(decodedMessage.type, .test)
    XCTAssertEqual(decodedMessage.message, "test")
    XCTAssertEqual(decodedMessage.data?["test"]?.value as? String, "test")
  }
}
