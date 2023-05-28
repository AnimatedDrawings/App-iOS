import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_Feature,
  platform: .iOS,
//  product: .staticFramework,
  product: .framework,
  dependencies: [
    .AD_UI,
    .AD_Utils,
    .ComposableArchitecture
  ],
  withTest: true
)
