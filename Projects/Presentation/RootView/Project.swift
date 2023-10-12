import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: RootView.projectName,
  targets: [
    RootView.example(),
    RootView.views(
      dependencies: [
        OnBoarding.projectDepedency,
        MakeAD.projectDepedency,
        ConfigureAnimation.projectDepedency
      ]
    )
  ]
)
