import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = ADEnv.makeProject(
  targets: [
    .makeTarget(
      name: ADEnv.projectName,
      product: .staticLibrary,
      resources: ["EnvFiles/**"],
      dependencies: []
    )
  ]
)
