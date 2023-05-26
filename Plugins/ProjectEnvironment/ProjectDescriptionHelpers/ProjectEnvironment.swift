import ProjectDescription

public extension Project {
  static func makeModule(
    myModule: MyModule,
    platform: Platform,
    product: Product,
    organizationName: String = "chminipark",
    packages: [Package] = [],
    deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "16.0", devices: [.iphone, .ipad]),
    dependencies: [TargetDependency] = [],
    sources: SourceFilesList = ["Sources/**"],
    resources: ResourceFileElements? = nil,
    infoPlist: InfoPlist = .default,
    withTest: Bool
  ) -> Project {
    let settings: Settings = .settings(
      base: [:],
      configurations: [
        .debug(name: .debug),
        .release(name: .release)
      ],
      defaultSettings: .recommended
    )
    
    let name = myModule.rawValue
    
    let appTarget = Target(
      name: name,
      platform: platform,
      product: product,
      bundleId: "\(organizationName).\(name)".replaceBar,
      deploymentTarget: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      dependencies: dependencies
    )
    
    var targets: [Target] = [appTarget]
    
    if withTest {
      let testTarget = Target(
        name: "\(name)Tests",
        platform: platform,
        product: .unitTests,
        bundleId: "\(organizationName).\(name)Tests".replaceBar,
        deploymentTarget: deploymentTarget,
        infoPlist: .default,
        sources: ["Tests/**"],
        dependencies: [.target(name: name)]
      )
      targets.append(testTarget)
    }
    
    let schemes: [Scheme] = [.makeScheme(target: .debug, name: name, withTest: withTest)]
    
    return Project(
      name: name,
      organizationName: organizationName,
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}

extension Scheme {
  static func makeScheme(
    target: ConfigurationName,
    name: String,
    withTest: Bool
  ) -> Scheme {
    let testAction: TestAction? = withTest ? .targets(
      ["\(name)Tests"],
      configuration: target,
      options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
    ) : nil
    
    return Scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
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
