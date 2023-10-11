import ProjectDescription
import ProjectEnvironment

let project: Project = .make(
  name: App.projectName,
  targets: [
    .makeTarget(
      targetName: App.targetName,
      product: .app,
      productName: "AD",
      infoPlist: .AD,
      dependencies: [
        Presentation.projectDepedency
      ]
    )
  ]
)
