//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/18.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: CropImage.projectName,
  targets: [
    .makeTarget(
      targetName: CropImage.targetName,
      product: .staticLibrary,
      dependencies: [
        AD_UIKit.projectDepedency
      ]
    )
  ]
)
