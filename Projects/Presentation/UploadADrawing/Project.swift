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
  options: .enableCodeCoverage,
  targets: [
    UploadADrawing.example(),
    UploadADrawing.views(),
    UploadADrawing.features(
      dependencies: [
        PresentationShared.projectDepedency
      ]
    ),
    UploadADrawing.tests()
  ]
)
