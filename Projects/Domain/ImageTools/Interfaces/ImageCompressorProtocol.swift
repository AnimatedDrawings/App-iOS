//
//  ImageCompressorProtocol.swift
//  ImageCompressor
//
//  Created by chminii on 2/26/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import UIKit
import DomainModel

public protocol ImageCompressorProtocol {
  func compress(with data: Data) throws -> CompressedInfo
  func compress(with image: UIImage) throws -> CompressedInfo
}
