//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: FindingTheCharacter.projectName,
  targets: [
    FindingTheCharacter.example(),
    FindingTheCharacter.view(),
    FindingTheCharacter.feature(
      dependencies: [
        Presentation_Shared.projectDepedency
      ]
    )
  ]
)