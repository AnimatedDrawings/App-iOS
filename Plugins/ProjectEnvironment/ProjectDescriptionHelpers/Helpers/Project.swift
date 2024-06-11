//
//  Project.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/9/24.
//

import ProjectDescription
import ProjectEnvironment

//public extension Project {
//  static func makeProject(
//    name: String,
//    path: Path,
//    options: ProjectDescription.Project.Options = .options(),
//    packages: [ProjectDescription.Package] = [],
//    settings: ProjectDescription.Settings? = .settings(configurations: [.dev, .prd]),
//    targets: [ProjectDescription.Target] = [],
//    fileHeaderTemplate: ProjectDescription.FileHeaderTemplate? = nil,
//    additionalFiles: [FileElement] = [],
//    resourceSynthesizers: [ProjectDescription.ResourceSynthesizer] = .default
//  )
//  -> Project {
//    let schemes: [ProjectDescription.Scheme] = [
//      .makeScheme(
//        name: name,
//        targets: targets.map { .project(path: path, target: $0.name)},
//        type: .dev
//      ),
//      .makeScheme(
//        name: name,
//        targets: targets.map { .project(path: path, target: $0.name)},
//        type: .prd
//      )
//    ]
//    
//    return Project(
//      name: name,
//      organizationName: .chminipark,
//      options: options,
//      packages: packages,
//      settings: settings,
//      targets: targets,
//      schemes: schemes,
//      fileHeaderTemplate: fileHeaderTemplate,
//      additionalFiles: additionalFiles,
//      resourceSynthesizers: resourceSynthesizers
//    )
//  }
//}

public extension Project.Options {
  static var enableCodeCoverage: Self {
    return .options(
      automaticSchemesOptions: .enabled(
        codeCoverageEnabled: true
      )
    )
  }
}

public extension ProjectDescription.ResourceFileElements {
  static var resource: Self {
    ["Resources/**"]
  }
}
