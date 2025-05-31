import simd

public struct BVHAnimation {
  public let frameCount: Int
  public let frameTime: Double
  public let joints: [BVHJointData]
  public let motionData: [[Double]]

  public init(
    frameCount: Int,
    frameTime: Double,
    joints: [BVHJointData],
    motionData: [[Double]]
  ) {
    self.frameCount = frameCount
    self.frameTime = frameTime
    self.joints = joints
    self.motionData = motionData
  }
}

public struct BVHJointData {
  public let name: String
  public let parent: String?
  public let offset: simd_float3  // 3D 오프셋
  public let channels: [BVHChannel]  // 채널 정보
  public let channelOrder: [Int]  // 모션 데이터에서의 채널 순서

  public init(
    name: String,
    parent: String?,
    offset: simd_float3,
    channels: [BVHChannel],
    channelOrder: [Int]
  ) {
    self.name = name
    self.parent = parent
    self.offset = offset
    self.channels = channels
    self.channelOrder = channelOrder
  }
}

public enum BVHChannel: String, CaseIterable {
  case xPosition = "Xposition"
  case yPosition = "Yposition"
  case zPosition = "Zposition"
  case xRotation = "Xrotation"
  case yRotation = "Yrotation"
  case zRotation = "Zrotation"
}
