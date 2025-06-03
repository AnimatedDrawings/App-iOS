import Foundation

public enum WebSocketError: Error, Equatable {
  case decodeMessage
  case invalidURL
  case unknown
}
