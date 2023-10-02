import ProjectDescription
import ProjectEnvironment

//let infoPlist: InfoPlist = .AD
//let myModule: Layer = .App
//let displayAppName = "AD"
//
//let project = Project.makeProject(
//  name: myModule.projectName,
//  targets: [
//    .makeTarget(
//      targetName: myModule.targetName,
//      product: .app,
//      productName: displayAppName,
//      infoPlist: infoPlist,
//      dependencies: [
//        Layer.Presentation.projectDepedency
//      ]
//    )
//  ]
//)

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
