import ProjectDescription

public extension Project {
  static func makeProject(
    name: String,
    options: ProjectDescription.Project.Options = .options(),
    packages: [ProjectDescription.Package] = [],
    settings: ProjectDescription.Settings? = nil,
    targets: [ProjectDescription.Target] = [],
    schemes: [ProjectDescription.Scheme] = [],
    fileHeaderTemplate: ProjectDescription.FileHeaderTemplate? = nil,
    additionalFiles: [FileElement] = [],
    resourceSynthesizers: [ProjectDescription.ResourceSynthesizer] = .default
  )
  -> Project {
    return Project(
      name: name,
      organizationName: .chminipark,
      options: options,
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes,
      fileHeaderTemplate: fileHeaderTemplate,
      additionalFiles: additionalFiles,
      resourceSynthesizers: resourceSynthesizers
    )
  }
}

public extension Target {
  static func makeTarget(
    name: String,
    product: ProjectDescription.Product,
    infoPlist: ProjectDescription.InfoPlist = .default,
    sources: ProjectDescription.SourceFilesList? = ["Sources/**"],
    resources: ProjectDescription.ResourceFileElements? = nil,
    dependencies: [TargetDependency]
  ) -> Target {
    let bundleId = "\(String.chminipark).\(name)".replaceBar
    
    return .target(
      name: name,
      destinations: .iOS,
      product: product,
      bundleId: bundleId,
      deploymentTargets: .iOS("16.0"),
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      dependencies: dependencies
    )
  }
}

public extension ProjectDescription.ResourceFileElements {
  static var resource: Self {
    ["Resources/**"]
  }
}

public extension ProjectDescription.InfoPlist {
  static var AD: Self {
    return .extendingDefault(with: [
      "UIMainStoryboardFile": "",
      "UILaunchStoryboardName": "LaunchScreen",
      "ENABLE_TESTS": .boolean(true),
      "NSPhotoLibraryUsageDescription": "We need access to photo library so that photos can be selected",
      "NSPhotoLibraryAddUsageDescription": "This app requires access to the photo library.",
      "UIUserInterfaceStyle": "Light",
      "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
    ])
  }
}

public extension Project.Options {
  static var enableCodeCoverage: Self {
    return .options(
      automaticSchemesOptions: .enabled(
        codeCoverageEnabled: true
      )
    )
  }
}

extension String {
  static let chminipark = "chminipark"
  
  var replaceBar: String {
    self.replacingOccurrences(of: "_", with: "-")
  }
}
