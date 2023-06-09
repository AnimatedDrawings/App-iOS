import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_UI,
  platform: .iOS,
//  product: .staticFramework,
  product: .framework,
  dependencies: [
    .AD_Feature,
    .AD_Utils,
    .ComposableArchitecture
  ],
  withTest: false
)
