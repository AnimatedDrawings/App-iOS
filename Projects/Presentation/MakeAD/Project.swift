//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/12.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: MakeAD.projectName,
  targets: [
    MakeAD.example(),
    MakeAD.views(),
    MakeAD.features(
      dependencies: [
        Presentation_Shared.projectDepedency
      ]
    )
  ]
)
