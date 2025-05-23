//
//  AdWhaleSettingModule.swift
//  iOSReactNativeSample
//
//  Created by FSN on 5/21/25.
//

import Foundation
import AdWhaleSDK
import React

@objc(AdWhaleSettingModule)
class AdWhaleSettingModule: NSObject {
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc
  func showAdInspector(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.main.async {
      if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        print("[adwhale] [sample Native] AdInspector 표시 시도")
        AdWhaleAds.sharedInstance.showAdInspector(viewController: rootViewController) { error in
          if error != nil {
            print("[adwhale] [sample Native] AdInspector 표시 실패: \(error?.localizedDescription ?? "Unknown error")")
          }
        }
        resolve(nil)
      } else {
        print("[adwhale] [sample Native] Root view controller를 찾을 수 없음")
        reject("ERROR", "Root view controller not found", nil)
      }
    }
  }

  @objc
  func showGDPR(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let workItem = DispatchWorkItem {
      if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        print("[adwhale] [sample Native] GDPR 표시 시도")
        AdWhaleAds.sharedInstance.gdpr(rootViewController, testDevices: nil) { result in
          print("[adwhale] [sample Native] GDPR 표시 완료: \(result)")
          resolve(result)
        }
      } else {
        print("[adwhale] [sample Native] Root view controller를 찾을 수 없음")
        reject("ERROR", "Root view controller not found", nil)
      }
    }
    DispatchQueue.main.async(execute: workItem)
  }

  // 네이티브 코드에서 직접 호출 가능한 SDK 초기화 메서드
  @objc
  public static func initializeSDK(appKey: String, completion: (() -> Void)? = nil) {
    AdWhaleAds.sharedInstance.initialize(appKey) {
      completion?()
    }
  }
}
