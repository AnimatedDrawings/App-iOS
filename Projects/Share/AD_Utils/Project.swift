import ProjectDescription
import ProjectEnvironment

let myModule: MyModule = .AD_Utils
let releaseTarget: Target = .makeTarget(
  targetName: myModule.name,
  product: .staticLibrary
)

let project: Project = .makeProject(
  myModule: myModule,
  targets: [
    releaseTarget
  ],
  schemes: []
)
