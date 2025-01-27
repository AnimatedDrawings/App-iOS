import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = Root.makeProject(
  options: .enableCodeCoverage,
  targets: Root.uPresentationTargets(
    dependencies: [
      OnBoarding.projectDepedency,
      MakeAD.projectDepedency,
      ConfigureAnimation.projectDepedency
    ]
  )
)
