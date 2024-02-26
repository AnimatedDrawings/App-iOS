//
//  Project.swift
//  Config
//
//  Created by chminii on 2/26/24.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: ADUIKit.projectName,
  targets: [
//    .makeTarget(
//      name: ADUIKit.targetName(.example),
//      product: .app,
//      infoPlist: .AD,
//      sources: ADUIKit.sourceFilesList([.example, .features]),
//      dependencies: [.target(name: ADUIKit.sources)]
//    ),
//    .makeTarget(
//      name: ADUIKit.sources,
//      product: .staticLibrary,
//      sources: ADUIKit.sourceFilesList([.features]),
//      dependencies: [.target(name: ADUIKit.resources)]
//    ),
    .makeTarget(
      name: ADUIKit.resources,
      product: .staticLibrary,
      sources: nil,
      resources: .resource,
      dependencies: []
    )
  ]
)

