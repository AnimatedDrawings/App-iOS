import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = AdmobManager.makeProject(
  options: .enableCodeCoverage,
  targets: AdmobManager.uFeatureTargets(
    dependencies: [DomainModels.projectDepedency]
  )
)
