import AnimationRenderInterfaces
import UIKit
import simd

protocol SkeletalMeshDeformerProtocol {
  func deformMesh(
    originalVertices: [simd_float2],
    skeleton: SkeletonConfiguration,
    jointTransforms: [String: simd_float4x4]
  ) -> [simd_float2]
}

class SkeletalMeshDeformer: SkeletalMeshDeformerProtocol {
  let influenceRadius: Float

  init(
    characterSize: CGSize,
    influenceRadiusRatio: Float = 0.2
  ) {
    let characterMaxSize = max(characterSize.width, characterSize.height)
    let influenceRadius = Float(characterMaxSize) * influenceRadiusRatio
    self.influenceRadius = influenceRadius
  }

  func deformMesh(
    originalVertices: [simd_float2],
    skeleton: SkeletonConfiguration,
    jointTransforms: [String: simd_float4x4]
  ) -> [simd_float2] {
    return originalVertices.map { vertex in
      var deformedVertex = vertex
      var totalWeight: Float = 0
      var weightedSum = simd_float2(0, 0)

      // 각 관절의 영향을 계산
      for joint in skeleton.joints {
        let jointPosition = simd_float2(
          Float(joint.location[0]),
          Float(joint.location[1])
        )

        let distance = simd_length(vertex - jointPosition)
        let weight = calculateWeight(distance: distance, joint: joint)

        if weight > 0 {
          if let transform = jointTransforms[joint.name] {
            // 2D 변환 행렬로 변환
            let transform2D = convertTo2DTransform(transform)
            let transformedVertex = applyTransform(
              vertex: vertex,
              transform: transform2D,
              pivot: jointPosition
            )

            weightedSum += transformedVertex * weight
            totalWeight += weight
          }
        }
      }

      // 가중치가 있는 경우에만 변형 적용
      if totalWeight > 0 {
        deformedVertex = weightedSum / totalWeight
      }

      return deformedVertex
    }
  }

  func calculateWeight(distance: Float, joint: SkeletonJoint) -> Float {
    if distance > influenceRadius {
      return 0.0
    }

    // 거리 기반 가중치 (smoothstep falloff)
    let normalizedDistance = distance / influenceRadius
    let t = 1.0 - normalizedDistance
    return t * t * (3.0 - 2.0 * t)  // smoothstep 함수
  }

  func convertTo2DTransform(_ transform: simd_float4x4) -> simd_float3x3 {
    // 4x4 행렬에서 2D 변환에 필요한 부분만 추출
    return simd_float3x3(
      simd_float3(transform.columns.0.x, transform.columns.0.y, transform.columns.3.x),
      simd_float3(transform.columns.1.x, transform.columns.1.y, transform.columns.3.y),
      simd_float3(0, 0, 1)
    )
  }

  private func applyTransform(
    vertex: simd_float2,
    transform: simd_float3x3,
    pivot: simd_float2
  ) -> simd_float2 {
    // 피벗 중심으로 변환
    let relativeVertex = vertex - pivot

    // 2D 버텍스를 3D 동차 좌표로 변환
    let homogeneous = simd_float3(relativeVertex.x, relativeVertex.y, 1)

    // 변환 행렬 적용
    let transformed = transform * homogeneous

    // 3D 동차 좌표를 2D로 변환하고 피벗 위치를 더해줌
    return simd_float2(
      transformed.x / transformed.z + pivot.x,
      transformed.y / transformed.z + pivot.y
    )
  }
}
