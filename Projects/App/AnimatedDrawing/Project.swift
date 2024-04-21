import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: App.projectName,
  targets: [
    .makeTarget(
      name: App.featureName,
      product: .app,
      infoPlist: .AD,
      resources: .resource,
      dependencies: [
        Presentation.projectDepedency
      ]
    )
  ]
)
