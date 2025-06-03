import Foundation
import NetworkRepositoryInterfaces

public class WebSocketManager: WebSocketManagerProtocol {
  private let url: URL
  private var webSocketTask: URLSessionWebSocketTask?
  private let pong = """
      {
        "type": "PONG",
        "message": "",
        "data": {}
      }
      """
  
  public init<T: TargetType>(_ targetType: T) throws {
    guard let url = try? targetType.webSocketURL else {
      throw WebSocketError.invalidURL
    }
    self.url = url
  }
  
  public init(url: URL) {
    self.url = url
  }
  
  public func connect() {
    webSocketTask = URLSession.shared.webSocketTask(with: url)
    webSocketTask?.resume()
  }
  
  public func disconnect() {
    webSocketTask?.cancel(with: .normalClosure, reason: nil)
  }
  
  func decodeMessage<S: RawRepresentable>(
    _ message: URLSessionWebSocketTask.Message
  ) -> WebSocketMessage<S>? where S.RawValue == String {
    switch message {
    case .string(let jsonString):
      print("메시지 : \(jsonString)")
      guard let jsonData = jsonString.data(using: .utf8) else {
        return nil
      }
      guard let decodedMessage = try? JSONDecoder().decode(
        WebSocketMessage<S>.self,
        from: jsonData
      )
      else {
        return nil
      }
      
      return decodedMessage
    default:
      return nil
    }
  }
  
  func checkMessageIfPing<S: RawRepresentable>(
    _ message: WebSocketMessage<S>
  ) async {
    guard let type = message.type.rawValue as? String else {
      print("checkMessageIfPing, type 체크 실패")
      return
    }
    if type == "PING" {
      print("PING 메시지 수신")
      
      do {
        try await self.webSocketTask?.send(.string(self.pong))
      } catch {
        print("PONG 메시지 전송 실패: \(error)")
      }
    }
  }
  
  public func messages<S: RawRepresentable>()
  -> AsyncStream<WebSocketMessage<S>> where S.RawValue == String
  {
    return AsyncStream { [weak self] continuation in
      @Sendable func receive() {
        self?.webSocketTask?.receive { result in
          switch result {
          case .failure(let error):
            print("메시지 수신 실패: \(error)")
            continuation.finish()
          case .success(let message):
            let decodedMessage: WebSocketMessage<S>? = self?.decodeMessage(message)
            guard let decodedMessage = decodedMessage
            else {
              print("메시지 디코딩 실패")
              continuation.finish()
              return
            }
            
            Task {
              await self?.checkMessageIfPing(decodedMessage)
            }
            
            continuation.yield(decodedMessage)
            receive()
          }
        }
      }
      receive()
    }
  }
}

public class MockWebSocketManager: WebSocketManagerProtocol {
  public init() {}
  
  public func messages<S: RawRepresentable>()
  -> AsyncStream<WebSocketMessage<S>>
  where S.RawValue: StringProtocol
  {
    return AsyncStream { _ in }
  }
  public func connect() {
    print("websocke connect")
  }
  public func disconnect() {
    print("websocke disconnect")
  }
}
