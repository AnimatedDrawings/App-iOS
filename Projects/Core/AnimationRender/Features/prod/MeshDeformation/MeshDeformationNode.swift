import AnimationRenderInterfaces
import SpriteKit
import UIKit
import simd

class MeshDeformationNode: SKSpriteNode {
  private var originalVertices: [simd_float2] = []
  private var deformedVertices: [simd_float2] = []
  private var meshGrid: MeshGrid
  private var skeletonConfig: SkeletonConfiguration
  private var renderer: UIGraphicsImageRenderer
  private var originalTexture: SKTexture
  private let deformer: SkeletalMeshDeformerProtocol

  init(
    texture: SKTexture,
    gridResolution: Int = 20,
    skeletonConfig: SkeletonConfiguration
  ) {
    self.meshGrid = MeshGrid(resolution: gridResolution)
    self.skeletonConfig = skeletonConfig
    self.originalTexture = texture
    self.renderer = UIGraphicsImageRenderer(size: texture.size())
    self.deformer = SkeletalMeshDeformer(characterSize: texture.size())
    super.init(texture: texture, color: .clear, size: texture.size())

    setupMeshGrid()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupMeshGrid() {
    let width = size.width
    let height = size.height
    let resolution = meshGrid.resolution

    // 균등한 그리드 포인트 생성
    for y in 0...resolution {
      for x in 0...resolution {
        let u = Float(x) / Float(resolution)
        let v = Float(y) / Float(resolution)

        let vertex = simd_float2(
          Float(width) * (u - 0.5),
          Float(height) * (v - 0.5)
        )

        originalVertices.append(vertex)
        deformedVertices.append(vertex)
      }
    }
  }

  func updateMeshDeformation(jointTransforms: [String: simd_float4x4]) {
    print("🎯 [MeshDeformation] 메시 변형 시작")

    print("🔄 [MeshDeformation] 메시 변형 적용 중...")

    deformedVertices = deformer.deformMesh(
      originalVertices: originalVertices,
      skeleton: skeletonConfig,
      jointTransforms: jointTransforms
    )
    print("✅ [MeshDeformation] 메시 변형 계산 완료 - 버텍스 수: \(deformedVertices.count)")

    // 변형된 버텍스의 범위 확인
    if let firstVertex = deformedVertices.first {
      var minX = firstVertex.x
      var maxX = firstVertex.x
      var minY = firstVertex.y
      var maxY = firstVertex.y

      for vertex in deformedVertices {
        minX = min(minX, vertex.x)
        maxX = max(maxX, vertex.x)
        minY = min(minY, vertex.y)
        maxY = max(maxY, vertex.y)
      }
      print("📊 [MeshDeformation] 변형된 버텍스 범위 - X: \(minX)~\(maxX), Y: \(minY)~\(maxY)")
    }

    print("🎨 [MeshDeformation] 메시 렌더링 시작")
    updateMeshRendering()
    print("✅ [MeshDeformation] 메시 렌더링 완료")
  }

  private func updateMeshRendering() {
    let deformedImage = renderer.image { context in
      drawDeformedMesh(in: context.cgContext)
    }
    texture = SKTexture(image: deformedImage)
  }

  private func drawDeformedMesh(in context: CGContext) {
    // 변형된 버텍스로 이미지 재그리기
    context.setFillColor(UIColor.clear.cgColor)
    context.fill(CGRect(origin: .zero, size: size))

    // 메시 그리드의 삼각형들을 그립니다
    let cgImage = originalTexture.cgImage()
    let width = size.width
    let height = size.height
    var triangleCount = 0

    for i in stride(from: 0, to: meshGrid.indices.count, by: 3) {
      let v1 = deformedVertices[Int(meshGrid.indices[i])]
      let v2 = deformedVertices[Int(meshGrid.indices[i + 1])]
      let v3 = deformedVertices[Int(meshGrid.indices[i + 2])]

      let path = UIBezierPath()
      path.move(to: CGPoint(x: CGFloat(v1.x) + width / 2, y: height - (CGFloat(v1.y) + height / 2)))
      path.addLine(
        to: CGPoint(x: CGFloat(v2.x) + width / 2, y: height - (CGFloat(v2.y) + height / 2)))
      path.addLine(
        to: CGPoint(x: CGFloat(v3.x) + width / 2, y: height - (CGFloat(v3.y) + height / 2)))
      path.close()

      context.saveGState()
      context.addPath(path.cgPath)
      context.clip()
      context.draw(cgImage, in: CGRect(origin: .zero, size: size))
      context.restoreGState()

      triangleCount += 1
    }

    print("📊 [MeshDeformation] 그려진 삼각형 수: \(triangleCount)")
  }

  func draw(in context: CGContext) {
    drawDeformedMesh(in: context)
  }
}

struct MeshGrid {
  let resolution: Int
  var indices: [UInt16] = []

  init(resolution: Int) {
    self.resolution = resolution
    generateIndices()
  }

  private mutating func generateIndices() {
    // 삼각형 메시 인덱스 생성
    for y in 0..<resolution {
      for x in 0..<resolution {
        let topLeft = UInt16(y * (resolution + 1) + x)
        let topRight = topLeft + 1
        let bottomLeft = UInt16((y + 1) * (resolution + 1) + x)
        let bottomRight = bottomLeft + 1

        // 첫 번째 삼각형
        indices.append(contentsOf: [topLeft, bottomLeft, topRight])
        // 두 번째 삼각형
        indices.append(contentsOf: [topRight, bottomLeft, bottomRight])
      }
    }
  }
}
