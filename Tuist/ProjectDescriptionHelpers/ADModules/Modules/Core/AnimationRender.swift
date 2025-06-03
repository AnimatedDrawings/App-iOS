import Foundation
import ProjectDescription

public struct AnimationRender: uFeatureModule {
  public static let prefixPathString: String = Core.prefixPathString
}

extension AnimationRender {
  public static func featuresTarget() -> Target {
    return .makeTarget(
      name: Self.targetName(.features),
      product: .staticLibrary,
      sources: Self.sourceFilesList([.features]),
      resources: ["Resources/**"],
      dependencies: Self.targetDependencies([.interfaces]) + [
        .sdk(name: "SceneKit", type: .framework),
        .sdk(name: "ImageIO", type: .framework),
        .sdk(name: "MobileCoreServices", type: .framework),
      ]
    )
  }

  public static func exampleTarget() -> Target {
    return .makeTarget(
      name: Self.targetName(.example),
      product: .app,
      infoPlist: .forPresentationLayer,
      sources: Self.sourceFilesList([.example]),
      dependencies: Self.targetDependencies([.features])
    )
  }
}
