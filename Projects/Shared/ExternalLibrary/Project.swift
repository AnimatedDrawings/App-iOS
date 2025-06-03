import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = ExternalLibrary.makeProject(
  targets: [
    .makeTarget(
      name: ExternalLibrary.projectName,
      product: .staticLibrary,
      dependencies: [
        ADComposableArchitecture.projectDepedency,
        ADAsyncAlgorithms.projectDepedency,
        ADAlamofire.projectDepedency,
        .external(name: "GoogleMobileAds"),
        .external(name: "Yams"),
      ]
    )
  ]
)
