public struct SkeletonConfiguration {
  public let width: Int
  public let height: Int
  public let joints: [SkeletonJoint]

  public static func mockExample1() -> Self {
    return .init(
      width: 176,
      height: 284,
      joints: SkeletonJoint.mockExample1()
    )
  }
}

public struct SkeletonJoint {
  public var name: String = ""
  public var location: [Int] = []
  public var parent: String?

  public init(name: String, location: [Int], parent: String?) {
    self.name = name
    self.location = location
    self.parent = parent
  }

  public static func mockExample1() -> [SkeletonJoint] {
    return [
      SkeletonJoint(name: "root", location: [81, 242], parent: nil),
      SkeletonJoint(name: "hip", location: [81, 242], parent: "root"),
      SkeletonJoint(name: "torso", location: [82, 215], parent: "hip"),
      SkeletonJoint(name: "neck", location: [92, 96], parent: "torso"),
      SkeletonJoint(name: "right_shoulder", location: [53, 213], parent: "torso"),
      SkeletonJoint(name: "right_elbow", location: [37, 193], parent: "right_shoulder"),
      SkeletonJoint(name: "right_hand", location: [17, 174], parent: "right_elbow"),
      SkeletonJoint(name: "left_shoulder", location: [112, 218], parent: "torso"),
      SkeletonJoint(name: "left_elbow", location: [131, 196], parent: "left_shoulder"),
      SkeletonJoint(name: "left_hand", location: [150, 174], parent: "left_elbow"),
      SkeletonJoint(name: "right_hip", location: [67, 240], parent: "root"),
      SkeletonJoint(name: "right_knee", location: [67, 257], parent: "right_hip"),
      SkeletonJoint(name: "right_foot", location: [67, 274], parent: "right_knee"),
      SkeletonJoint(name: "left_hip", location: [95, 243], parent: "root"),
      SkeletonJoint(name: "left_knee", location: [92, 257], parent: "left_hip"),
      SkeletonJoint(name: "left_foot", location: [95, 274], parent: "left_knee"),
    ]
  }
}
