//
//  Extension+UINavigationController.swift
//  AD_Utils
//
//  Created by minii on 2023/05/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
