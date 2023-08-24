//
//  Project.swift
//  Config
//
//  Created by minii on 2023/08/23.
//

import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_CropImage,
  platform: .iOS,
//  product: .staticFramework,
  product: .framework,
  dependencies: [
    .AD_Utils
  ],
  resources: ["Resources/**"],
  withTest: false
)
