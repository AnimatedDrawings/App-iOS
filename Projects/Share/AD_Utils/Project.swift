import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_Utils,
  platform: .iOS,
  product: .staticFramework,
  resources: ["Resources/**"],
  withTest: false
)
