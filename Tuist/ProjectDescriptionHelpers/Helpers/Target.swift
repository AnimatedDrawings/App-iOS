//
//  Target.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/9/24.
//

import ProjectDescription

public extension Target {
  static func makeTarget(
    name: String,
    product: ProjectDescription.Product,
    infoPlist: ProjectDescription.InfoPlist = .default,
    sources: ProjectDescription.SourceFilesList? = ["Features/**"],
    resources: ProjectDescription.ResourceFileElements? = nil,
    dependencies: [TargetDependency]
  ) -> Target {
    let bundleId = "\(String.chminipark).\(name)".replaceBar
    
    return .target(
      name: name,
      destinations: .iOS,
      product: product,
      bundleId: bundleId,
      deploymentTargets: .iOS("18.0"),
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      dependencies: dependencies
    )
  }
}
