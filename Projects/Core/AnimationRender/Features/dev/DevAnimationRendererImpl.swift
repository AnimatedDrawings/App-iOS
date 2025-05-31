import AnimationRenderInterfaces
import ImageIO
import MobileCoreServices
import SceneKit
import UIKit
import UniformTypeIdentifiers

public class DevAnimationRendererImpl: AnimationRendererImpl {
  public override init(
    characterImage: UIImage? = nil,
    skeletonConfiguration: SkeletonConfiguration? = nil,
    bvhFileName: String? = nil
  ) {
    let characterImage =
      characterImage
      ?? {
        guard
          let image = UIImage(
            named: "example1",
            in: Bundle.module,
            compatibleWith: nil
          )
        else {
          fatalError("example1.png 이미지를 찾을 수 없습니다. Resources/cutout/ 디렉토리를 확인해주세요.")
        }
        return image
      }()
    let skeletonConfiguration = skeletonConfiguration ?? .mockExample1()
    let bvhFileName =
      bvhFileName
      ?? {
        guard let bvhPath = Bundle.module.path(forResource: "dab", ofType: "bvh") else {
          fatalError("dab.bvh 파일을 찾을 수 없습니다. Resources/bvh/ 디렉토리를 확인해주세요.")
        }
        return bvhPath
      }()

    super.init(
      characterImage: characterImage,
      skeletonConfiguration: skeletonConfiguration,
      bvhFileName: bvhFileName
    )
  }
}
