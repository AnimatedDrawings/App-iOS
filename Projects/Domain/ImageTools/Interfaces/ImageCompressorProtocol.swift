//
//  ImageCompressorProtocol.swift
//  ImageCompressor
//
//  Created by chminii on 2/26/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import DomainModels

public protocol ImageCompressorProtocol {
  func compress(with data: Data) throws -> CompressResponse
  func compress(with image: UIImage) throws -> CompressResponse
}
