//
//  StepStatusBarEnvironment.swift
//  AD_UI
//
//  Created by minii on 2023/06/13.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public class StepStatusBarEnvironment: ObservableObject {
  public init() {}
  @Published public var isHide: Bool = false
}
