import ProjectDescription
import ProjectEnvironment

//let ADiOSScheme: Scheme = .makeScheme(
//  targetName: MyModule.AD_iOS.name,
//  target: .release,
//  withTest: false
//)
//
//let ADUIScheme: Scheme = .makeScheme(
//  targetName: MyModule.AD_UI.name,
//  target: .release,
//  withTest: false
//)

let workspace = Workspace(
  name: "AnimatedDrawings",
  projects: [
    "Projects/App/AD_iOS"
  ],
  schemes: [
//    ADiOSScheme,
//    ADUIScheme
  ],
  additionalFiles: [
    "README.md"
  ]
)
