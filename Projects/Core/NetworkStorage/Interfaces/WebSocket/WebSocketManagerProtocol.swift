import Foundation

public protocol WebSocketManagerProtocol {
  func messages<S: RawRepresentable>() -> AsyncStream<WebSocketMessage<S>> where S.RawValue: StringProtocol
  func connect()
  func disconnect()
}
