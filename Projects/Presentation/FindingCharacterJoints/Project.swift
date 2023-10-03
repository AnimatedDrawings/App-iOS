//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: FindingCharacterJoints.projectName,
  targets: [
    FindingCharacterJoints.example(),
    FindingCharacterJoints.view(),
    FindingCharacterJoints.feature(
      dependencies: [
        Presentation_Shared.projectDepedency
      ]
    )
  ]
)
