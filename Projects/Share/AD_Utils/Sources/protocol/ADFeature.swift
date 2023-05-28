//
//  ADFeature.swift
//  AD_Utils
//
//  Created by minii on 2023/05/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public protocol ADFeature: View {
  associatedtype _ADUI: ADUI
  var ui: _ADUI { get }
}
