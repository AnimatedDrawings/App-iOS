import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  name: "AD_OnBoarding",
  platform: .iOS,
  product: .staticFramework,
  dependencies: [
    .ComposableArchitecture
  ],
  withTest: false
)
