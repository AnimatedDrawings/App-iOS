import AnimationRenderInterfaces
import SpriteKit
import simd

class AnimationFrameProcessor {
  private let meshNode: MeshDeformationNode
  private let bvhAnimation: BVHAnimation
  private let skeletonConfiguration: SkeletonConfiguration

  init(
    meshNode: MeshDeformationNode,
    bvhAnimation: BVHAnimation,
    skeletonConfiguration: SkeletonConfiguration
  ) {
    self.meshNode = meshNode
    self.bvhAnimation = bvhAnimation
    self.skeletonConfiguration = skeletonConfiguration
  }

  func processFrame(_ frameIndex: Int) -> UIImage? {
    guard frameIndex < bvhAnimation.motionData.count else { return nil }

    print("🔄 [FrameProcessor] 프레임 \(frameIndex) 처리 시작")

    // 1. 프레임 데이터에서 관절 변환 계산
    print("📊 [FrameProcessor] 관절 변환 계산 중...")
    let jointTransforms = calculateJointTransforms(frameIndex: frameIndex)
    print("✅ [FrameProcessor] 관절 변환 계산 완료 - 관절 수: \(jointTransforms.count)")

    // 2. 메시 변형 적용
    print("🎨 [FrameProcessor] 메시 변형 적용 중...")
    meshNode.updateMeshDeformation(jointTransforms: jointTransforms)
    print("✅ [FrameProcessor] 메시 변형 적용 완료")

    // 3. 현재 프레임 이미지 캡처
    print("📸 [FrameProcessor] 프레임 이미지 캡처 중...")
    let image = captureCurrentFrame()
    if let image = image {
      print(
        "✅ [FrameProcessor] 프레임 \(frameIndex) 이미지 생성 완료 - 크기: \(image.size.width)x\(image.size.height)"
      )
    } else {
      print("❌ [FrameProcessor] 프레임 \(frameIndex) 이미지 생성 실패")
    }

    return image
  }

  private func calculateJointTransforms(frameIndex: Int) -> [String: simd_float4x4] {
    print("🔍 [FrameProcessor] 프레임 \(frameIndex)의 관절 데이터 처리 중...")
    var transforms: [String: simd_float4x4] = [:]
    let frameData = bvhAnimation.motionData[frameIndex]

    for (jointIndex, joint) in bvhAnimation.joints.enumerated() {
      let channelStartIndex = jointIndex * 6  // 6DOF per joint

      if channelStartIndex + 5 < frameData.count {
        let translation = simd_float3(
          Float(frameData[channelStartIndex]),
          Float(frameData[channelStartIndex + 1]),
          Float(frameData[channelStartIndex + 2])
        )

        let rotation = simd_float3(
          Float(frameData[channelStartIndex + 3]) * .pi / 180,
          Float(frameData[channelStartIndex + 4]) * .pi / 180,
          Float(frameData[channelStartIndex + 5]) * .pi / 180
        )

        // 회전 행렬 생성 (ZYX 순서)
        let rotationMatrix = createRotationMatrix(rotation)
        let translationMatrix = createTranslationMatrix(translation)

        // 부모 관절의 변환 적용
        var finalTransform = translationMatrix * rotationMatrix
        if let parentName = joint.parent,
          let parentTransform = transforms[parentName]
        {
          finalTransform = parentTransform * finalTransform
        }

        transforms[joint.name] = finalTransform
      }
    }

    return transforms
  }

  private func createRotationMatrix(_ rotation: simd_float3) -> simd_float4x4 {
    // ZYX 순서로 회전 행렬 생성
    let rx = simd_float4x4(
      simd_float4(1, 0, 0, 0),
      simd_float4(0, cos(rotation.x), -sin(rotation.x), 0),
      simd_float4(0, sin(rotation.x), cos(rotation.x), 0),
      simd_float4(0, 0, 0, 1)
    )

    let ry = simd_float4x4(
      simd_float4(cos(rotation.y), 0, sin(rotation.y), 0),
      simd_float4(0, 1, 0, 0),
      simd_float4(-sin(rotation.y), 0, cos(rotation.y), 0),
      simd_float4(0, 0, 0, 1)
    )

    let rz = simd_float4x4(
      simd_float4(cos(rotation.z), -sin(rotation.z), 0, 0),
      simd_float4(sin(rotation.z), cos(rotation.z), 0, 0),
      simd_float4(0, 0, 1, 0),
      simd_float4(0, 0, 0, 1)
    )

    return rz * ry * rx  // ZYX 순서로 적용
  }

  private func createTranslationMatrix(_ translation: simd_float3) -> simd_float4x4 {
    return simd_float4x4(
      simd_float4(1, 0, 0, 0),
      simd_float4(0, 1, 0, 0),
      simd_float4(0, 0, 1, 0),
      simd_float4(translation.x, translation.y, translation.z, 1)
    )
  }

  private func captureCurrentFrame() -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: meshNode.size)
    let image = renderer.image { context in
      meshNode.draw(in: context.cgContext)
    }

    // 이미지가 제대로 생성되었는지 확인
    if image.cgImage == nil {
      print("⚠️ [FrameProcessor] 생성된 이미지의 CGImage가 nil입니다")
      return nil
    }

    return image
  }
}
