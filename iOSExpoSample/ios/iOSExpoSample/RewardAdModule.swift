import Foundation
import AdWhaleSDK
import React

@objc(RewardAdModule)
class RewardAdModule: RCTEventEmitter {
  private var rewardAd: AdWhaleRewardAd?

  override func supportedEvents() -> [String]! {
    return [
      "onRewardAdLoaded",
      "onRewardAdFailedToLoad",
      "onRewardAdFailedToShow",
      "onRewardAdWillPresent",
      "onRewardAdDismissed",
      "onRewardAdEarned"
    ]
  }

  override static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc
  func loadAd(_ adUnitId: String, resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.main.async {
      print("[adwhale] [sample Native] 보상형 광고 로드 시작")
      self.rewardAd = AdWhaleRewardAd()
      self.rewardAd?.rewardDelegate = self
      self.rewardAd?.load(adUnitId)
      resolve(nil)
    }
  }

  @objc
  func showAd(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.main.async {
      if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        print("[adwhale] [sample Native] 보상형 광고 표시 시도")
        self.rewardAd?.show(rootViewController)
        resolve(nil)
      } else {
        print("[adwhale] [sample Native] Root view controller를 찾을 수 없음")
        reject("ERROR", "Root view controller not found", nil)
      }
    }
  }
}

extension RewardAdModule: AdWhaleRewardDelegate {
  func adDidReceiveRewardAd(_ ad: AdWhaleRewardAd) {
    print("[adwhale] [sample Native] 보상형 광고 로드 성공")
    rewardAd = ad
    sendEvent(withName: "onRewardAdLoaded", body: nil)
  }

  func adDidFailToReceiveRewardAdWithError(_ error: Error) {
    print("[adwhale] [sample Native] 보상형 광고 로드 실패: \(error.localizedDescription)")
    sendEvent(withName: "onRewardAdFailedToLoad", body: ["error": error.localizedDescription])
  }

  func ad(_ ad: AdWhaleRewardAd, didFailToPresentRewardAdWithError error: Error) {
    print("[adwhale] [sample Native] 보상형 광고 표시 실패: \(error.localizedDescription)")
    sendEvent(withName: "onRewardAdFailedToShow", body: ["error": error.localizedDescription])
  }

  func adWillPresentRewardAd(_ ad: AdWhaleRewardAd) {
    print("[adwhale] [sample Native] 보상형 광고가 표시될 예정")
    sendEvent(withName: "onRewardAdWillPresent", body: nil)
  }

  func adDidDismissRewardAd(_ ad: AdWhaleRewardAd) {
    print("[adwhale] [sample Native] 보상형 광고가 닫힘")
    sendEvent(withName: "onRewardAdDismissed", body: nil)
  }

  func adDidEarnReward(_ reward: AdWhaleReward) {
    print("[adwhale] [sample Native] 보상 획득: \(reward.amount.doubleValue), 타입: \(reward.type)")
    sendEvent(withName: "onRewardAdEarned", body: [
      "amount": reward.amount,
      "type": reward.type
    ])
  }
} 
