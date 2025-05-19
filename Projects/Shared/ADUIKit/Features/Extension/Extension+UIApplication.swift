//
//  Extension+UIApplication.swift
//  ADUIKit
//
//  Created by chminii on 5/18/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import UIKit

public extension UIApplication {
  var rootViewController: UIViewController? {
    connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }?
      .rootViewController
  }
}
