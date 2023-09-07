import ProjectDescription
import ProjectEnvironment

let workspace = Workspace(
  name: "AnimatedDrawings",
  projects: [
    .myModule(.AD_iOS)
  ],
  schemes: [],
  additionalFiles: [
    "README.md"
  ]
)
