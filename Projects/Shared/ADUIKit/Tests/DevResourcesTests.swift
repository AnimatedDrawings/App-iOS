import ADResources
import ADUIKit
import XCTest
import Yams

@testable import ADResources

class DevResourcesTests: XCTestCase {
  func testGetBoundingBox() {

    let boundingBox = DevResources.example1.boundingBox
    XCTAssertEqual(boundingBox.minX, 88)
    XCTAssertEqual(boundingBox.minY, 118)
    XCTAssertEqual(boundingBox.width, 176)
    XCTAssertEqual(boundingBox.height, 284)
  }
}
