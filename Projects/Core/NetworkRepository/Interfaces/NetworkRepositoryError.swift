import Foundation

public enum NetworkRepositoryError: Error, Equatable {
  case client(statusCode: Int)
  case server(statusCode: Int)
  case makeFullURL
  case toDictionary
  case queryParameter
  case bodyParameter
  case jsonDecode
  case unknown
}
