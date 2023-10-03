import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: RootView.projectName,
  targets: [
    RootView.example(),
    RootView.view(),
    RootView.feature(
      dependencies: [
        OnBoarding.projectDepedency,
        MakeAD.projectDepedency,
        ConfigureAnimation.projectDepedency
      ]
    )
  ]
)
