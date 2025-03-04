import Foundation

public enum NetworkStorageError: Error, Equatable {
  case client(statusCode: Int)
  case server(statusCode: Int)
  case makeURL
  case jsonDecode
  case unknown
}
