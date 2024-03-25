//
//  CombineNotifierTests.swift
//  SharedProviderTests
//
//  Created by chminii on 3/13/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import XCTest
@testable import SharedProvider

final class CombineNotifierTests: XCTestCase {
  func testValues() async {
    let initialValue = 0
    let noti = GlobalNotifier(initialValue: initialValue)
    let id = UUID()
    let dupArray: [Int] = [1, 1, 1]
    let numArray: [Int] = Array((1...10))
    var resultArray: [Int] = []
    let expectation = XCTestExpectation()
    
    Task {
      try await Task.sleep(for: .seconds(2))
      for num in dupArray + numArray {
        await noti.set(num)
      }
    }
    for await num in await noti.values(id: id) {
      resultArray.append(num)
      if num == 10 {
        expectation.fulfill()
        break
      }
    }
    
    await fulfillment(of: [expectation], timeout: 7)
    XCTAssertEqual(resultArray, [initialValue] + numArray)
    let cancellables = await noti.cancellables
    XCTAssertNil(cancellables[id])
  }
  
  func testSet() async {
    let initialValue = "initialValue"
    let noti = GlobalNotifier(initialValue: initialValue)
    
    let test = "test"
    await noti.set(test)
    let result = await noti.get()
    
    XCTAssertNotEqual(result, initialValue)
    XCTAssertEqual(result, test)
  }
  
  func testGet() async {
    let initialValue = "initialValue"
    let noti = GlobalNotifier(initialValue: initialValue)
    
    let result = await noti.get()
    
    XCTAssertEqual(result, initialValue)
  }
}
