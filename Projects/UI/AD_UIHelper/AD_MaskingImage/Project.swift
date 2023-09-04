//
//  Project.swift
//  Config
//
//  Created by minii on 2023/08/21.
//

import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_MaskingImage,
  platform: .iOS,
  product: .framework,
  dependencies: [
    .AD_Utils
  ],
  resources: ["Resources/**"],
  withTest: false
)
