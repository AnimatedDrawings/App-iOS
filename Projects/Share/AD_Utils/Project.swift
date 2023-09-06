import ProjectDescription
import ProjectEnvironment

let myModule: MyModule = .AD_Utils

let project: Project = .makeProject(
  myModule: myModule,
  targets: [
    .makeTarget(
      targetName: myModule.name,
      product: .staticFramework
    )
  ],
  schemes: []
)
