// import AnimationRenderInterfaces
// import UIKit
// import simd

// // BVH 데이터와 2D 골격 정보를 연결
// public struct BVHSkeletonMapper {

//   public init() {}

//   public func mapBVHToSkeleton(
//     bvhJoints: [SkeletonJoint],
//     skeletonConfig: SkeletonConfiguration
//   ) -> [String: SkeletonMapping] {

//     var mappings: [String: SkeletonMapping] = [:]

//     // BVH 관절명과 2D 골격 관절명 매핑 사전
//     let jointMappingTable = createJointMappingTable()

//     for bvhJoint in bvhJoints {
//       let bvhName = bvhJoint.name

//       // 매핑 테이블에서 대응하는 2D 스켈레톤 관절 찾기
//       if let mappedName = jointMappingTable[bvhName],
//         let skeletonJoint = skeletonConfig.joints.first(where: { $0.name == mappedName })
//       {

//         let mapping = SkeletonMapping(
//           bvhJointName: bvhName,
//           skeletonJoint: skeletonJoint,
//           influenceRadius: calculateInfluenceRadius(for: skeletonJoint, in: skeletonConfig)
//         )

//         mappings[bvhName] = mapping
//       }
//     }

//     return mappings
//   }

//   private func createJointMappingTable() -> [String: String] {
//     // BVH 관절명 -> 2D 스켈레톤 관절명 매핑
//     return [
//       // 상체
//       "Hips": "hip",
//       "Spine": "torso",
//       "Spine1": "torso",
//       "Spine2": "torso",
//       "Spine3": "torso",
//       "Neck": "neck",
//       "Head": "neck",

//       // 오른쪽 팔
//       "RightShoulder": "right_shoulder",
//       "RightArm": "right_shoulder",
//       "RightForeArm": "right_elbow",
//       "RightHand": "right_hand",
//       "RightHandEnd": "right_hand",

//       // 왼쪽 팔
//       "LeftShoulder": "left_shoulder",
//       "LeftArm": "left_shoulder",
//       "LeftForeArm": "left_elbow",
//       "LeftHand": "left_hand",
//       "LeftHandEnd": "left_hand",

//       // 오른쪽 다리
//       "RightUpLeg": "right_hip",
//       "RightLeg": "right_knee",
//       "RightFoot": "right_foot",
//       "RightToeBase": "right_foot",

//       // 왼쪽 다리
//       "LeftUpLeg": "left_hip",
//       "LeftLeg": "left_knee",
//       "LeftFoot": "left_foot",
//       "LeftToeBase": "left_foot",
//     ]
//   }

//   private func calculateInfluenceRadius(
//     for joint: SkeletonJoint,
//     in config: SkeletonConfiguration
//   ) -> Float {
//     // 이미지 크기 기반으로 영향 반경 계산
//     let imageSize = simd_float2(Float(config.width), Float(config.height))
//     let baseRadius = simd_length(imageSize) * 0.08  // 이미지 대각선의 8%

//     // 관절 타입에 따른 가중치 적용
//     let weightMultiplier: Float = {
//       switch joint.name {
//       case "hip", "torso", "root":
//         return 1.5  // 중심부 관절은 더 큰 영향력
//       case let name where name.contains("shoulder"):
//         return 1.2
//       case let name where name.contains("elbow"), let name where name.contains("knee"):
//         return 1.0
//       case let name where name.contains("hand"), let name where name.contains("foot"):
//         return 0.8
//       default:
//         return 1.0
//       }
//     }()

//     return baseRadius * weightMultiplier
//   }
// }

// public struct SkeletonMapping {
//   public let bvhJointName: String
//   public let skeletonJoint: SkeletonJoint
//   public let influenceRadius: Float  // 메시 변형 영향 범위

//   public init(bvhJointName: String, skeletonJoint: SkeletonJoint, influenceRadius: Float) {
//     self.bvhJointName = bvhJointName
//     self.skeletonJoint = skeletonJoint
//     self.influenceRadius = influenceRadius
//   }
// }
