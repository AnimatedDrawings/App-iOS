//
//  NetworkStorage.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/09.
//  Copyright 2023 chminipark. All rights reserved.
//

import ADAlamofire
import Foundation
import NetworkStorageInterfaces

public class NetworkStorage<T: TargetType> {
  public func request<R: Decodable>(_ target: T)
  async -> Result<R, NetworkStorageError>
  {
    do {
      let urlRequest = try target.urlRequest
      
      let decoded = try await AF.request(urlRequest)
        .validate()
        .serializingDecodable(R.self)
        .value
      
      return .success(decoded)
    } catch {
      let networkStorageError = getNetworkStorageError(error: error)
      return .failure(networkStorageError)
    }
  }
  
  public func uploadImage<R: Decodable>(
    with data: Data,
    target: T
  ) async -> Result<R, NetworkStorageError> {
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
      let networkStorageError = getNetworkStorageError(error: error)
      return .failure(networkStorageError)
    }
  }
  
  public func download(
    _ target: T
  ) async -> Result<Data, NetworkStorageError> {
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
      let networkStorageError = getNetworkStorageError(error: error)
      return .failure(networkStorageError)
    }
  }
}


extension NetworkStorage {
  private func getNetworkStorageError(error: any Error) -> NetworkStorageError {
    if let error = error as? NetworkStorageError {
      printError("NetworkStorageError : \(error)")
      return error
    }
    // Alamofire 호출 중 발생한 에러 확인
    if let afError = error as? AFError {
      printError("AFError : \(afError)")
      let networkStorageError = checkStatusCode(afError: afError)
      return networkStorageError
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
  
  private func checkStatusCode(afError: AFError) -> NetworkStorageError {
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
