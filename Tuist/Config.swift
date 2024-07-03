import ProjectDescription

extension PluginLocation {
  private static func relativeToRoot(_ name: String) -> Self {
    return .local(path: .relativeToRoot("Tuist/Plugins/\(name)"))
  }
  
  static let ADModules = relativeToRoot("ADModules")
}

let config = Config(
  plugins: [
    .ADModules
  ]
)
