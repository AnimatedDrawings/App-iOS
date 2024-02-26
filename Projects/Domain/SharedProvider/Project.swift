//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/02.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: SharedProvider.projectName,
  targets: [
    SharedProvider.features(
      dependencies: [DomainModel.projectDepedency]
    )
  ]
)
