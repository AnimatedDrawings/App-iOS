//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by minii on 2023/05/23.
//

import ProjectDescription
//import ProjectEnvironment
//
//let workspace = Workspace(
//  name: env.name,
//  projects: [
//    "App/iOS + TCA",
//    "App/iOS + RIBs"
//  ],
//  schemes: [],
//  additionalFiles: [
//    "README.md"
//  ]
//)

let workspace = Workspace(
  name: "AnimatedDrawings",
  projects: [
    "App/iOS"
  ],
  schemes: [],
  additionalFiles: [
    "README.md"
  ]
)

//public init(
//    name: String,
//    projects: [ProjectDescription.Path],
//    schemes: [ProjectDescription.Scheme] = [],
//    fileHeaderTemplate: ProjectDescription.FileHeaderTemplate? = nil,
//    additionalFiles: [ProjectDescription.FileElement] = [],
//    generationOptions: ProjectDescription.Workspace.GenerationOptions = .options()
//)
