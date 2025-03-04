//
//  NetworkStorage.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/09.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADAlamofire
import Foundation
import NetworkStorageInterfaces

public class NetworkStorage<T: TargetType> {
  public func request<R: Decodable>(_ target: T)
    async -> Result<R, NetworkStorageError>
  {
    guard let url = target.fullURL else {
      printError("URL 생성 실패")
      return .failure(.makeURL)
    }
    do {
      let decoded = try await AF.request(
        url,
        method: target.method,
        parameters: target.queryParameters,
        headers: target.headers
      )
      .validate()
      .serializingDecodable(R.self)
      .value

      return .success(decoded)
    } catch {
      // Alamofire 호출 중 발생한 에러 확인
      if let afError = error as? AFError {
        let networkStorageError = checkStatusCode(afError: afError)
        return .failure(networkStorageError)
      }
      // 디코딩 중 발생한 에러 확인
      else if let decodingError = error as? DecodingError {
        let decodeMessage = "DecodingError 발생: \(decodingError.localizedDescription)"
        printError(decodeMessage)
        return .failure(.jsonDecode)
      }
      let unknownMessage = error.localizedDescription
      printError(unknownMessage)
      return .failure(.unknown)
    }
  }

  private func checkStatusCode(afError: AFError) -> NetworkStorageError {
    let message: String = afError.responseCode?.description ?? ""

    if let statusCode = afError.responseCode {
      if (400...499).contains(statusCode) {
        printError("client error : \(message)")
        return .client(statusCode: statusCode)
      }
      if (500...599).contains(statusCode) {
        printError("server error : \(message)")
        return .server(statusCode: statusCode)
      }
    }

    printError("unknown error : \(message)")
    return .unknown
  }
  
  private func printError(_ message: String) {
    print("😈😈😈😈😈😈😈😈😈😈😈😈😈")
    print(message)
    print("😈😈😈😈😈😈😈😈😈😈😈😈😈")
  }
}
