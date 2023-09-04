import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_Feature,
  platform: .iOS,
  product: .staticLibrary,
  dependencies: [
    .AD_Utils,
    .ComposableArchitecture,
    .Moya
  ],
  withTest: true
)
