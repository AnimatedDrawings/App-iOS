import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  module: .AD_Utils,
  platform: .iOS,
  product: .staticFramework,
  withTest: false
)
