import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_Utils,
  platform: .iOS,
  product: .framework,
  dependencies: [
    .ComposableArchitecture
  ],
  resources: ["Resources/**"],
  withTest: false
)
