import ADEnv
import GoogleMobileAds

protocol RewardADManagerProtocol {
  func loadAD() async -> LoadADResult
  func showAD() async -> ShowADResult
}

enum LoadADResult {
  case success
  case failure
}

enum ShowADResult {
  case failPrepare
  case failPresent
  case dismissWhileAD
  case finishWatch
}

final class TestRewardADManager: NSObject, RewardADManagerProtocol {
  private let adUnitID = "ca-app-pub-3940256099942544/1712485313"
  private var rewardedAd: RewardedAd?
  private var showADContinuation: CheckedContinuation<ShowADResult, Never>?

  func loadAD() async -> LoadADResult {
    let request = GoogleMobileAds.Request()

    return await withCheckedContinuation { continuation in
      RewardedAd.load(with: adUnitID, request: request) { [weak self] ad, error in
        guard let self = self,
          let ad = ad
        else {
          continuation.resume(returning: .failure)
          return
        }
        if let error = error {
          print("Ad load error: \(error)")
          continuation.resume(returning: .failure)
          return
        }
        print("Ad loaded")
        self.rewardedAd = ad
        ad.fullScreenContentDelegate = self
        continuation.resume(returning: .success)
      }
    }
  }

  @MainActor
  func showAD() async -> ShowADResult {
    guard let ad = rewardedAd,
      let rootVC = UIApplication.shared.rootViewController
    else {
      return .failPrepare
    }

    return await withCheckedContinuation { [weak self] continuation in
      guard let self = self else {
        continuation.resume(returning: .failPrepare)
        return
      }

      self.showADContinuation = continuation
      ad.fullScreenContentDelegate = self  // 굳이?

      ad.present(from: rootVC) { [weak self] in
        guard let self = self else {
          continuation.resume(returning: .failPrepare)
          return
        }

        let reward = ad.adReward
        print("User rewarded: \(reward.amount) \(reward.type)")
        self.showADContinuation?.resume(returning: .finishWatch)
      }
    }
  }
}

extension TestRewardADManager: FullScreenContentDelegate {
  // 전체화면 콘텐츠 표시 실패
  @MainActor
  func fullScreenContent(
    _ ad: FullScreenPresentingAd,
    didFailToPresentFullScreenContentWithError error: Error
  ) {
    self.rewardedAd = nil
    self.showADContinuation?.resume(returning: .failPresent)
    //    self.showADContinuation = nil
    print("Presentation error: \(error)")
  }

  // 전체화면 콘텐츠가 닫힘
  @MainActor
  func fullScreenContentDidDismiss(_ ad: FullScreenPresentingAd) {
    self.rewardedAd = nil
    self.showADContinuation?.resume(returning: .dismissWhileAD)
    //    self.showADContinuation = nil
    print("dismiss Reward AD View")
  }
}
