//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: SeparatingCharacter.projectName,
  targets: [
    SeparatingCharacter.example(),
    SeparatingCharacter.views(),
    SeparatingCharacter.features(
      dependencies: [
        Presentation_Shared.projectDepedency
      ]
    )
  ]
)
