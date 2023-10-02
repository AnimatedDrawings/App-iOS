import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: Presentation.projectName,
  targets: [
    .makeTarget(
      targetName: Presentation.targetName,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        OnBoarding.projectDepedency,
        MakeAD.projectDepedency,
        ConfigureAnimation.projectDepedency
      ]
    )
  ]
)
