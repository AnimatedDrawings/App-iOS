import AnimationRenderInterfaces
import UIKit
import simd

class BVHParser {
  init() {}

  func parse(fileName: String) throws -> BVHAnimation {
    // BVH 파일 로드
    let bvhString = try loadBVHFile(fileName: fileName)
    // BVH 파일을 HIERARCHY와 MOTION 섹션으로 분리
    let (hierarchyLines, motionLines) = try separateBVH(bvhString: bvhString)
    // HIERARCHY 섹션에서 골격 구조 파싱
    let joints = parseHierarchy(hierarchyLines)
    // MOTION 섹션에서 프레임별 회전/이동 데이터 파싱
    let (frameCount, frameTime, motionData) = parseMotion(motionLines)

    return BVHAnimation(
      frameCount: frameCount,
      frameTime: frameTime,
      joints: joints,
      motionData: motionData
    )
  }

  func loadBVHFile(fileName: String) throws -> String {
    guard
      let url = Bundle.module.url(forResource: fileName, withExtension: "bvh"),
      let data = try? Data(contentsOf: url),
      let string = String(data: data, encoding: .utf8)
    else {
      throw BVHParserError.loadBVHFileFailed
    }

    return string
  }

  func separateBVH(bvhString: String) throws -> (hierarchyLines: [String], motionLines: [String]) {
    let lines = bvhString.components(separatedBy: .newlines)
    guard
      let motionIndex = lines.firstIndex(where: {
        $0.trimmingCharacters(in: .whitespaces) == "MOTION"
      })
    else {
      throw BVHParserError.separateBVHFailed
    }

    let hierarchyLines = Array(lines[0..<motionIndex])
    let motionLines = Array(lines[motionIndex..<lines.count])

    return (hierarchyLines, motionLines)
  }

  func parseMotion(_ lines: [String]) -> (
    frameCount: Int,
    frameTime: Double,
    motionData: [[Double]]
  ) {
    var frameCount = 0
    var frameTime = 0.0
    var motionData: [[Double]] = []

    for line in lines {
      let trimmedLine = line.trimmingCharacters(in: .whitespaces)
      let components = trimmedLine.components(separatedBy: .whitespaces).filter { !$0.isEmpty }

      guard !components.isEmpty else { continue }

      if components[0] == "Frames:" && components.count >= 2 {
        frameCount = Int(components[1]) ?? 0
      } else if components[0] == "Frame" && components[1] == "Time:" && components.count >= 3 {
        frameTime = Double(components[2]) ?? 0.0
      } else if components[0] != "MOTION" && components[0] != "Frames:" && components[0] != "Frame"
      {
        // 모션 데이터 라인 파싱
        let frameData = components.compactMap { Double($0) }
        if !frameData.isEmpty {
          motionData.append(frameData)
        }
      }
    }

    return (frameCount: frameCount, frameTime: frameTime, motionData: motionData)
  }

  func parseHierarchy(_ lines: [String]) -> [BVHJointData] {
    var joints: [BVHJointData] = []
    var jointStack: [(name: String, offset: simd_float3)] = []
    var channelIndex = 0

    var currentJointName = ""
    var currentOffset = simd_float3(0, 0, 0)
    var currentChannels: [BVHChannel] = []

    for line in lines {
      let trimmedLine = line.trimmingCharacters(in: .whitespaces)
      let components = trimmedLine.components(separatedBy: .whitespaces).filter { !$0.isEmpty }

      guard !components.isEmpty else { continue }

      switch components[0] {
      case "ROOT", "JOINT":
        if components.count >= 2 {
          currentJointName = components[1]
          currentOffset = simd_float3(0, 0, 0)
          currentChannels = []
        }

      case "OFFSET":
        if components.count >= 4 {
          currentOffset = simd_float3(
            Float(components[1]) ?? 0,
            Float(components[2]) ?? 0,
            Float(components[3]) ?? 0
          )
        }

      case "CHANNELS":
        if components.count >= 3 {
          let channelCount = Int(components[1]) ?? 0
          currentChannels = []

          for i in 2..<min(components.count, 2 + channelCount) {
            if let channel = BVHChannel(rawValue: components[i]) {
              currentChannels.append(channel)
            }
          }

          // 관절 데이터 생성
          let parent = jointStack.last?.name
          let channelOrder = Array(channelIndex..<(channelIndex + currentChannels.count))

          let jointData = BVHJointData(
            name: currentJointName,
            parent: parent,
            offset: currentOffset,
            channels: currentChannels,
            channelOrder: channelOrder
          )

          joints.append(jointData)
          jointStack.append((currentJointName, currentOffset))
          channelIndex += currentChannels.count
        }

      case "End":
        if components.count >= 2 && components[1] == "Site" {
          jointStack.append(("EndSite", simd_float3(0, 0, 0)))
        }

      case "}":
        if !jointStack.isEmpty {
          jointStack.removeLast()
        }

      default:
        break
      }
    }

    return joints
  }
}
