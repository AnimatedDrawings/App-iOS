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

  /// 메시의 각 버텍스에 대해 스켈레톤 관절들의 영향을 계산하여 변형된 위치를 반환합니다.
  ///
  /// 이 함수는 스켈레톤 기반 메시 변형의 핵심 함수입니다. 각 버텍스는 여러 관절의 영향을 받을 수 있으며,
  /// 각 관절의 영향력은 거리에 따라 가중치가 계산됩니다. 최종적으로 모든 관절의 영향을 가중 평균하여
  /// 부드러운 변형을 구현합니다.
  ///
  /// 사용 예시:
  /// - 캐릭터의 팔다리를 움직일 때 주변 메시가 자연스럽게 변형됩니다
  /// - 여러 관절이 동시에 움직일 때 각 관절의 영향이 부드럽게 블렌딩됩니다
  ///
  /// - Parameters:
  ///   - originalVertices: 원본 메시의 버텍스 배열
  ///   - skeleton: 스켈레톤 구성 정보
  ///   - jointTransforms: 각 관절의 3D 변환 행렬
  /// - Returns: 변형된 버텍스 배열
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

  /// 관절과 버텍스 사이의 거리에 기반하여 가중치를 계산합니다.
  ///
  /// 이 함수는 관절의 영향력을 거리에 따라 부드럽게 감소시키는 역할을 합니다.
  /// smoothstep 함수를 사용하여 자연스러운 가중치 감소를 구현합니다.
  ///
  /// 사용 예시:
  /// - 관절에서 멀어질수록 영향력이 부드럽게 감소합니다
  /// - influenceRadius를 벗어나면 영향력이 0이 됩니다
  /// - 가까운 관절은 더 큰 영향력을 가집니다
  ///
  /// - Parameters:
  ///   - distance: 관절과 버텍스 사이의 거리
  ///   - joint: 대상 관절
  /// - Returns: 0.0에서 1.0 사이의 가중치 값
  func calculateWeight(distance: Float, joint: SkeletonJoint) -> Float {
    if distance > influenceRadius {
      return 0.0
    }

    // 거리 기반 가중치 (smoothstep falloff)
    let normalizedDistance = distance / influenceRadius
    let t = 1.0 - normalizedDistance
    return t * t * (3.0 - 2.0 * t)  // smoothstep 함수
  }

  /// 3D 변환 행렬(4x4)을 2D 변환 행렬(3x3)로 변환합니다.
  ///
  /// 이 함수는 3D 스켈레톤 애니메이션의 변환을 2D 메시 변형에 적용하기 위해 사용됩니다.
  /// 4x4 행렬에서 2D 변환에 필요한 회전, 스케일, 이동 정보만 추출하여 3x3 행렬로 변환합니다.
  ///
  /// 사용 예시:
  /// - 3D 스켈레톤의 회전을 2D 메시에 적용할 때 사용됩니다
  /// - 3D 관절의 이동을 2D 공간에 투영할 때 사용됩니다
  ///
  /// - Parameter transform: 3D 변환 행렬
  /// - Returns: 2D 변환 행렬
  func convertTo2DTransform(_ transform: simd_float4x4) -> simd_float3x3 {
    // 4x4 행렬에서 2D 변환에 필요한 부분만 추출
    return simd_float3x3(
      simd_float3(transform.columns.0.x, transform.columns.0.y, transform.columns.3.x),
      simd_float3(transform.columns.1.x, transform.columns.1.y, transform.columns.3.y),
      simd_float3(0, 0, 1)
    )
  }

  /// 주어진 2D 버텍스에 변환 행렬을 적용합니다.
  ///
  /// 이 함수는 2D 버텍스에 회전, 스케일, 이동 등의 변환을 적용합니다.
  /// 피벗 포인트를 기준으로 변환을 수행하며, 동차 좌표계를 사용하여
  /// 모든 종류의 변환을 일관되게 처리합니다.
  ///
  /// 사용 예시:
  /// - 관절을 중심으로 메시를 회전할 때 사용됩니다
  /// - 관절의 이동에 따라 메시를 이동시킬 때 사용됩니다
  /// - 메시의 크기를 조절할 때 사용됩니다
  ///
  /// - Parameters:
  ///   - vertex: 변환할 2D 버텍스
  ///   - transform: 적용할 2D 변환 행렬
  ///   - pivot: 변환의 중심점
  /// - Returns: 변환된 2D 버텍스
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
