import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  module: .AD_OnBoarding,
  platform: .iOS,
  product: .staticFramework,
  dependencies: [
    .AD_Utils,
    .ComposableArchitecture
  ],
  withTest: false
)
