//
//  MaskableFeature.swift
//  MaskingImageFeatures
//
//  Created by chminii on 1/10/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ThirdPartyLib
import UIKit

public struct MaskableFeature: Reducer {
  public init() {}
  
  public var body: some Reducer<State, Action> {
    MainReducer()
  }
}

public extension MaskableFeature {
  struct State: Equatable {
    @BindingState public var maskedImage: UIImage?
    
    public init(maskedImage: UIImage? = nil) {
      self.maskedImage = maskedImage
    }
  }
}

public extension MaskableFeature {
  enum Action: Equatable {
    case mask(UIImage)
  }
}

extension MaskableFeature {
  func MainReducer() -> some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .mask(let maskedImage):
        return .none
      }
    }
  }
}
