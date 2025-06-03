//
//  TestAdmobManager.swift
//  AdmobManager
//
//  Created by chminii on 5/18/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import ADEnv
import ADUIKit
import AdmobManagerInterfaces
import Foundation
import GoogleMobileAds

public final class TestAdmobManagerImpl: AdmobManagerImpl {
  private var testAdUnitID = "ca-app-pub-3940256099942544/1712485313"

  public override var adUnitID: String {
    get {
      return testAdUnitID
    }
    set {
      testAdUnitID = newValue
    }
  }
}
