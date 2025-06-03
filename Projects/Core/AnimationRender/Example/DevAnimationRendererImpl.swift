import AnimationRender
import AnimationRenderInterfaces
import UIKit

class DevAnimationRendererImpl: AnimationRendererProtocol {
  let characterImage: UIImage
  let skeletonConfiguration: SkeletonConfiguration
  private var _bvhFileName: String

  var bvhFileName: String {
    get { _bvhFileName }
    set { _bvhFileName = newValue }
  }

  init() {
    // 테스트용 리소스 로드
    self.characterImage =
      UIImage(named: "example1", in: AnimationRenderResources.bundle, compatibleWith: nil)
      ?? UIImage()
    self.skeletonConfiguration = SkeletonConfiguration.mockExample1()
    self._bvhFileName = "dab"  // 기본값
  }

  func render() async throws -> AnimationGIF {
    let renderer = AnimationRendererImpl(
      characterImage: characterImage,
      skeletonConfiguration: skeletonConfiguration,
      bvhFileName: bvhFileName
    )

    return try await renderer.render()
  }

  func updateBVHFileName(_ fileName: String) {
    self._bvhFileName = fileName
  }
}
