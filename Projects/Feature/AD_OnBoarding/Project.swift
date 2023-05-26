import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_OnBoarding,
  platform: .iOS,
//  product: .staticFramework,
  product: .framework,
  dependencies: [
    .AD_Utils,
    .ComposableArchitecture
  ],
  withTest: true
)
