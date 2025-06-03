import AnimationRenderInterfaces
import XCTest

@testable import AnimationRender

final class TestBVHParser: XCTestCase {
  var parser: BVHParser!

  override func setUp() {
    super.setUp()
    parser = BVHParser()
  }

  override func tearDown() {
    parser = nil
    super.tearDown()
  }

  func testLoadBVHFile() throws {
    // Given
    let fileName = "dab"

    // When
    let bvhString = try parser.loadBVHFile(fileName: fileName)

    // Then
    XCTAssertFalse(bvhString.isEmpty)
    XCTAssertTrue(bvhString.contains("HIERARCHY"))
    XCTAssertTrue(bvhString.contains("MOTION"))
  }

  func testSeparateBVH() throws {
    // Given
    let bvhString = """
      HIERARCHY
      ROOT Hips
      {
          OFFSET 0.00 0.00 0.00
          CHANNELS 6 Xposition Yposition Zposition Zrotation Xrotation Yrotation
          JOINT Spine
          {
              OFFSET 0.00 10.00 0.00
              CHANNELS 3 Zrotation Xrotation Yrotation
          }
      }
      MOTION
      Frames: 1
      Frame Time: 0.033333
      0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00
      """

    // When
    let (hierarchyLines, motionLines) = try parser.separateBVH(bvhString: bvhString)

    // Then
    XCTAssertFalse(hierarchyLines.isEmpty)
    XCTAssertFalse(motionLines.isEmpty)
    XCTAssertTrue(hierarchyLines.contains("HIERARCHY"))
    XCTAssertTrue(motionLines.contains("MOTION"))
  }

  func testParseMotion() {
    // Given
    let motionLines = [
      "MOTION",
      "Frames: 2",
      "Frame Time: 0.033333",
      "0.00 0.00 0.00 0.00 0.00 0.00",
      "1.00 1.00 1.00 1.00 1.00 1.00",
    ]

    // When
    let (frameCount, frameTime, motionData) = parser.parseMotion(motionLines)

    // Then
    XCTAssertEqual(frameCount, 2)
    XCTAssertEqual(frameTime, 0.033333)
    XCTAssertEqual(motionData.count, 2)
    XCTAssertEqual(motionData[0].count, 6)
    XCTAssertEqual(motionData[1].count, 6)
  }

  func testParseHierarchy() {
    // Given
    let hierarchyLines = [
      "HIERARCHY",
      "ROOT Hips",
      "{",
      "    OFFSET 0.00 0.00 0.00",
      "    CHANNELS 6 Xposition Yposition Zposition Zrotation Xrotation Yrotation",
      "    JOINT Spine",
      "    {",
      "        OFFSET 0.00 10.00 0.00",
      "        CHANNELS 3 Zrotation Xrotation Yrotation",
      "    }",
      "}",
    ]

    // When
    let joints = parser.parseHierarchy(hierarchyLines)

    // Then
    XCTAssertEqual(joints.count, 2)
    XCTAssertEqual(joints[0].name, "Hips")
    XCTAssertEqual(joints[1].name, "Spine")
    XCTAssertEqual(joints[1].parent, "Hips")
    XCTAssertEqual(joints[0].channels.count, 6)
    XCTAssertEqual(joints[1].channels.count, 3)
  }

  func testParseFullBVH() throws {
    // Given
    let fileName = "dab"

    // When
    let animation = try parser.parse(fileName: fileName)

    // Then
    XCTAssertGreaterThan(animation.frameCount, 0)
    XCTAssertGreaterThan(animation.frameTime, 0)
    XCTAssertFalse(animation.joints.isEmpty)
    XCTAssertFalse(animation.motionData.isEmpty)
  }
}
