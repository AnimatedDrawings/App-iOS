import ProjectDescription
import ProjectEnvironment

let workspace = Workspace(
  name: "AnimatedDrawings",
  projects: [
    .myModule(.AD_App)
  ],
  schemes: [],
  additionalFiles: [
    "README.md"
  ]
)
