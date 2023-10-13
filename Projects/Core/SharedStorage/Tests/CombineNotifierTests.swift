//
//  CombineNotifierTests.swift
//  SharedStorageTests
//
//  Created by minii on 2023/10/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import SharedStorage

final class CombineNotifierTests: XCTestCase {
  func testSet() async {
    let mockStorage = CombineNotifier<Int>(initialValue: 1)
    let setNum = 10
    await mockStorage.set(10)
    
    let getNum = await mockStorage.get()
    
    XCTAssertEqual(getNum, setNum)
  }
  
  func testGet() async {
    let mockStorage = CombineNotifier<Int>(initialValue: 1)
    let getNum = await mockStorage.get()
    
    XCTAssertEqual(getNum, 1)
  }
  
  func testValues() async {
    let start = 1
    let end = 10
    let mockStorage = CombineNotifier<Int>(initialValue: start)
    let expectNums: [Int] = (start...end).map { $0 }
    
    var nums: [Int] = []
    for await num in await mockStorage.values().prefix(end) {
      nums.append(num)
      await mockStorage.set(num + 1)
    }
    
    XCTAssertEqual(expectNums, nums)
  }
  
  func testCancel() async {
    let mockStorage = CombineNotifier<Int>(initialValue: 1)
    
    
  }
}
