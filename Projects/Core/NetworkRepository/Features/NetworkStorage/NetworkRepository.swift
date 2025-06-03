//
//  NetworkRepository.swift
//  NetworkRepository
//
//  Created by minii on 2023/10/09.
//  Copyright 2023 chminipark. All rights reserved.
//

import ADAlamofire
import Foundation
import NetworkRepositoryInterfaces

public class NetworkRepository<T: TargetType> {
  public func request<R: Decodable>(_ target: T)
  async -> Result<R, NetworkRepositoryError>
  {
    do {
      let urlRequest = try target.urlRequest
      
      let decoded = try await AF.request(urlRequest)
        .validate()
        .serializingDecodable(R.self)
        .value
      
      return .success(decoded)
    } catch {
      let networkError = getNetworkRepositoryError(error: error)
      return .failure(networkError)
    }
  }
  
  public func uploadImage<R: Decodable>(
    with data: Data,
    target: T
  ) async -> Result<R, NetworkRepositoryError> {
    do {
      let urlRequest = try target.urlRequest
      
      let decoded = try await AF.upload(
        multipartFormData: { multipartFormData in
          multipartFormData.append(
            data,
            withName: "file",
            fileName: "image.png",
            mimeType: "image/png"
          )
        },
        with: urlRequest
      )
        .validate()
        .serializingDecodable(R.self)
        .value
      
      return .success(decoded)
      
    } catch {
      let networkError = getNetworkRepositoryError(error: error)
      return .failure(networkError)
    }
  }
  
  public func download(
    _ target: T
  ) async -> Result<Data, NetworkRepositoryError> {
    do {
      let urlRequest = try target.urlRequest
      
      let downloadRequest = AF.request(urlRequest)
      downloadRequest.downloadProgress { progress in
        print("다운로드 진행률: \(progress.fractionCompleted * 100)%")
      }
      let data = try await downloadRequest
        .validate()
        .serializingData()
        .value
      
      return .success(data)
    } catch {
      let networkError = getNetworkRepositoryError(error: error)
      return .failure(networkError)
    }
  }
}


extension NetworkRepository {
  private func getNetworkRepositoryError(error: any Error) -> NetworkRepositoryError {
    if let error = error as? NetworkRepositoryError {
      printError("NetworkRepositoryError : \(error)")
      return error
    }
    // Alamofire 호출 중 발생한 에러 확인
    if let afError = error as? AFError {
      printError("AFError : \(afError)")
      let networkError = checkStatusCode(afError: afError)
      return networkError
    }
    // 디코딩 중 발생한 에러 확인
    else if let decodingError = error as? DecodingError {
      let decodeMessage = "DecodingError : \(decodingError.localizedDescription)"
      printError(decodeMessage)
      return .jsonDecode
    }
    // Unknown 에러 확인
    let unknownMessage = error.localizedDescription
    printError("Unknown : \(unknownMessage)")
    return .unknown
  }
  
  private func checkStatusCode(afError: AFError) -> NetworkRepositoryError {
    if let statusCode = afError.responseCode {
      if (400...499).contains(statusCode) {
        printError("client error, statusCode : \(statusCode)")
        return .client(statusCode: statusCode)
      }
      if (500...599).contains(statusCode) {
        printError("server error, statusCode : \(statusCode)")
        return .server(statusCode: statusCode)
      }
    }
    
    printError("unknown status code ...")
    return .unknown
  }
  
  private func printError(_ message: String) {
    print("😈😈😈😈😈😈😈😈😈😈😈😈😈")
    print(message)
    print("😈😈😈😈😈😈😈😈😈😈😈😈😈")
  }
}
