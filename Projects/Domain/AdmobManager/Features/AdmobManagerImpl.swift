//
//  AdmobManagerImpl.swift
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

public class AdmobManagerImpl: NSObject, AdmobManagerProtocol {
  public var adUnitID = AdEnv.admobRewardId
  private var rewardedAd: RewardedAd?
  private var showADContinuation: CheckedContinuation<AdmobResult, any Error>?

  public func getRewardADResult() async -> AdmobResult {
    do {
      try await loadAD()

      guard let ad = rewardedAd,
        let rootVC = await UIApplication.shared.rootViewController
      else {
        throw AdmobError.notReady
      }

      let showADResult = try await showAD(ad: ad, vc: rootVC)
      return showADResult
    } catch {
      print("getRewardADResult: \(error)")
      // return .failure
      return .success
    }
  }
}

extension AdmobManagerImpl {
  private func loadAD() async throws {
    do {
      rewardedAd = try await RewardedAd.load(
        with: adUnitID,
        request: GoogleMobileAds.Request()
      )
      rewardedAd?.fullScreenContentDelegate = self
    } catch {
      print("Failed to load : \(error.localizedDescription)")
      throw AdmobError.loadFailed
    }
  }

  @MainActor
  private func showAD(
    ad: RewardedAd,
    vc: UIViewController
  ) async throws -> AdmobResult {
    try await withCheckedThrowingContinuation { [weak self] continuation in
      guard let self = self else {
        continuation.resume(returning: .failure)
        return
      }

      self.showADContinuation = continuation

      ad.present(from: vc) {
        let reward = ad.adReward
        print("User rewarded: \(reward.amount) \(reward.type)")
        continuation.resume(returning: .success)
      }
    }
  }
}

extension AdmobManagerImpl: FullScreenContentDelegate {
  public func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
    print("\(#function) called")
  }

  public func adDidRecordClick(_ ad: FullScreenPresentingAd) {
    print("\(#function) called")
  }

  public func ad(
    _ ad: FullScreenPresentingAd,
    didFailToPresentFullScreenContentWithError error: Error
  ) {
    print("\(#function) called")
    print("didFailToPresentFullScreenContentWithError: \(error.localizedDescription)")
    showADContinuation?.resume(returning: .failure)
    rewardedAd = nil
  }

  public func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
    print("\(#function) called")
  }

  public func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
    print("\(#function) called")
  }

  public func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
    print("\(#function) called")
    rewardedAd = nil
  }
}
