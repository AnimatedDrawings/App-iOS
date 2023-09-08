import ProjectDescription

public extension Project {
  static func makeProject(
    myModule: MyModule,
    organizationName: String = "chminipark",
    options: Project.Options = .options(),
    packages: [Package] = [],
    settings: ProjectDescription.Settings? = nil,
    targets: [Target],
    schemes: [Scheme] = [],
    fileHeaderTemplate: ProjectDescription.FileHeaderTemplate? = nil,
    additionalFiles: [FileElement] = [],
    resourceSynthesizers: [ProjectDescription.ResourceSynthesizer] = .default
  )
  -> Project {
    let name: String = myModule.name
    
    return Project(
      name: name,
      organizationName: organizationName,
      options: options,
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes,
      fileHeaderTemplate: nil,
      additionalFiles: additionalFiles,
      resourceSynthesizers: resourceSynthesizers
    )
  }
}

public extension Target {
  static func makeTestTarget(
    targetName: String,
    platform: Platform = .iOS,
    organizationName: String = "chminipark",
    deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.0", devices: [.iphone]),
    sources: SourceFilesList = ["Tests/**"]
  ) -> Target
  {
    return Target(
      name: "\(targetName)Tests",
      platform: platform,
      product: .unitTests,
      bundleId: "\(organizationName).\(targetName)Tests".replaceBar,
      deploymentTarget: deploymentTarget,
      infoPlist: .default,
      sources: sources,
      dependencies: [.target(name: targetName)]
    )
  }
  
  static func makeTarget(
    targetName: String,
    platform: ProjectDescription.Platform = .iOS,
    product: ProjectDescription.Product,
    productName: String? = nil,
    organizationName: String = "chminipark",
    deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "16.0", devices: [.iphone]),
    infoPlist: InfoPlist = .default,
    sources: SourceFilesList = ["Sources/**"],
    resources: ResourceFileElements? = ["Resources/**"],
    copyFiles: [ProjectDescription.CopyFilesAction]? = nil,
    headers: ProjectDescription.Headers? = nil,
    entitlements: ProjectDescription.Path? = nil,
    scripts: [ProjectDescription.TargetScript] = [],
    dependencies: [TargetDependency] = [],
    settings: ProjectDescription.Settings? = nil,
    coreDataModels: [ProjectDescription.CoreDataModel] = [],
    environment: [String : String] = [:],
    launchArguments: [ProjectDescription.LaunchArgument] = [],
    additionalFiles: [ProjectDescription.FileElement] = [],
    buildRules: [ProjectDescription.BuildRule] = []
  ) -> Target
  {
    return Target(
      name: targetName,
      platform: platform,
      product: product,
      productName: productName,
      bundleId: "\(organizationName).\(targetName)".replaceBar,
      deploymentTarget: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      copyFiles: copyFiles,
      headers: headers,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies,
      settings: settings,
      coreDataModels: coreDataModels,
      environment: environment,
      launchArguments: launchArguments,
      additionalFiles: additionalFiles,
      buildRules: buildRules
    )
  }
}

public extension Scheme {
  static func makeScheme(
    targetName: String,
    target: ConfigurationName,
    withTest: Bool
  ) -> Scheme {
    let testAction: TestAction? = withTest ?
      .targets(
        ["\(targetName)Tests"],
        configuration: target,
        options: .options(coverage: true, codeCoverageTargets: ["\(targetName)"])
      ) :
    nil
    
    return Scheme(
      name: targetName,
      shared: true,
      buildAction: .buildAction(targets: ["\(targetName)"]),
      testAction: testAction,
      runAction: .runAction(configuration: target),
      archiveAction: .archiveAction(configuration: target),
      profileAction: .profileAction(configuration: target),
      analyzeAction: .analyzeAction(configuration: target)
    )
  }
}

extension String {
  var replaceBar: String {
    self.replacingOccurrences(of: "_", with: "-")
  }
}
