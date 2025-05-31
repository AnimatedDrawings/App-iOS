import AnimationRenderInterfaces
import SpriteKit
import UIKit
import simd

public class AnimationRendererImpl: AnimationRendererProtocol {
  public let characterImage: UIImage
  public let skeletonConfiguration: SkeletonConfiguration
  public let bvhFileName: String

  public init(
    characterImage: UIImage,
    skeletonConfiguration: SkeletonConfiguration,
    bvhFileName: String
  ) {
    self.characterImage = characterImage
    self.skeletonConfiguration = skeletonConfiguration
    self.bvhFileName = bvhFileName
  }

  public func render() async throws -> AnimationGIF {
    print("🎬 [AnimationRenderer] 애니메이션 렌더링 시작")

    // 1. BVH 파싱
    print("📝 [AnimationRenderer] BVH 파일 파싱 중...")
    let bvhAnimation = try BVHParser().parse(fileName: bvhFileName)
    print("✅ [AnimationRenderer] BVH 파싱 완료 - 프레임 수: \(bvhAnimation.motionData.count)")

    // 2. BVH 관절을 SkeletonJoint로 변환
    print("🔄 [AnimationRenderer] BVH 관절을 SkeletonJoint로 변환 중...")
    let skeletonJoints = bvhAnimation.joints.map { bvhJoint in
      SkeletonJoint(
        name: bvhJoint.name,
        location: [0, 0],
        parent: bvhJoint.parent
      )
    }
    print("✅ [AnimationRenderer] SkeletonJoint 변환 완료 - 관절 수: \(skeletonJoints.count)")

    // 4. 메시 변형 노드 생성
    print("🎨 [AnimationRenderer] 메시 변형 노드 생성 중...")
    let texture = SKTexture(image: characterImage)
    let meshNode = MeshDeformationNode(
      texture: texture,
      gridResolution: 25,
      skeletonConfig: skeletonConfiguration
    )
    print("✅ [AnimationRenderer] 메시 변형 노드 생성 완료 - 스켈레톤 설정 추가됨")

    // 5. 애니메이션 프레임 처리기 생성
    print("⚙️ [AnimationRenderer] 프레임 처리기 초기화 중...")
    let frameProcessor = AnimationFrameProcessor(
      meshNode: meshNode,
      bvhAnimation: bvhAnimation,
      skeletonConfiguration: skeletonConfiguration
    )
    print("✅ [AnimationRenderer] 프레임 처리기 초기화 완료")

    // 6. 모든 프레임 처리
    print("🎥 [AnimationRenderer] 프레임 처리 시작 - 총 \(bvhAnimation.motionData.count)개 프레임")
    var frames: [UIImage] = []

    // 2초(약 60프레임)로 제한
    let maxFrames = min(60, bvhAnimation.motionData.count)

    for frameIndex in 0..<maxFrames {
      if frameIndex % 10 == 0 {
        print("⏳ [AnimationRenderer] 프레임 처리 중... \(frameIndex)/\(maxFrames)")
      }
      if let frameImage = frameProcessor.processFrame(frameIndex) {
        frames.append(frameImage)
      }
    }
    print("✅ [AnimationRenderer] 모든 프레임 처리 완료")

    // 7. GIF 생성
    print("🎞️ [AnimationRenderer] GIF 생성 중...")
    let gifCreator = GIFCreator()
    let gifData =
      gifCreator.createGIF(
        from: frames,
        duration: Double(maxFrames) * bvhAnimation.frameTime
      ) ?? Data()
    print(
      "✅ [AnimationRenderer] GIF 생성 완료 - 크기: \(ByteCountFormatter.string(fromByteCount: Int64(gifData.count), countStyle: .file))"
    )

    print("🎉 [AnimationRenderer] 애니메이션 렌더링 완료!")
    return AnimationGIF(data: gifData)
  }

  private func createRotationMatrix(_ rotation: simd_float3) -> simd_float4x4 {
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

    return rx * ry * rz
  }

  private func createTranslationMatrix(_ translation: simd_float3) -> simd_float4x4 {
    return simd_float4x4(
      simd_float4(1, 0, 0, 0),
      simd_float4(0, 1, 0, 0),
      simd_float4(0, 0, 1, 0),
      simd_float4(translation.x, translation.y, translation.z, 1)
    )
  }
}
