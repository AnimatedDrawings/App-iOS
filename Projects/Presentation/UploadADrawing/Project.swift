//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: UploadADrawing.projectName,
  targets: [
    UploadADrawing.example(),
    UploadADrawing.view(),
    UploadADrawing.feature(
      dependencies: [
        Presentation_Shared.projectDepedency
      ]
    )
  ]
)
