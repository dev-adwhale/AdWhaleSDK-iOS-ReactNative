#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <AdWhaleSDK/AdWhaleSDK.h>
#import <React/RCTUtils.h>

@interface RewardAdModule : RCTEventEmitter <RCTBridgeModule, AdWhaleRewardDelegate>
@property (nonatomic, strong) AdWhaleRewardAd *rewardAd;
@end

@implementation RewardAdModule

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
        @"onRewardAdLoaded",
        @"onRewardAdFailedToLoad",
        @"onRewardAdFailedToShow",
        @"onRewardAdWillPresent",
        @"onRewardAdDismissed",
        @"onRewardAdEarned"
    ];
}

RCT_EXPORT_METHOD(loadAd:(NSString *)adUnitId
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.rewardAd = [[AdWhaleRewardAd alloc] init];
        self.rewardAd.rewardDelegate = self;
        [self.rewardAd load:adUnitId];
        if (resolve) resolve(nil);
    });
}

RCT_EXPORT_METHOD(showAd:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootVC = RCTPresentedViewController();
        if (rootVC) {
            [self.rewardAd show:rootVC];
            if (resolve) resolve(nil);
        } else {
            if (reject) reject(@"ERROR", @"Root view controller not found", nil);
        }
    });
}

// MARK: - AdWhaleRewardDelegate
- (void)adDidReceiveRewardAd:(AdWhaleRewardAd *)ad {
    self.rewardAd = ad;
    [self sendEventWithName:@"onRewardAdLoaded" body:nil];
}
- (void)adDidFailToReceiveRewardAdWithError:(NSError *)error {
    [self sendEventWithName:@"onRewardAdFailedToLoad" body:@{@"error": error.localizedDescription ?: @""}];
}
- (void)ad:(AdWhaleRewardAd *)ad didFailToPresentRewardAdWithError:(NSError *)error {
    [self sendEventWithName:@"onRewardAdFailedToShow" body:@{@"error": error.localizedDescription ?: @""}];
}
- (void)adWillPresentRewardAd:(AdWhaleRewardAd *)ad {
    [self sendEventWithName:@"onRewardAdWillPresent" body:nil];
}
- (void)adDidDismissRewardAd:(AdWhaleRewardAd *)ad {
    [self sendEventWithName:@"onRewardAdDismissed" body:nil];
}
- (void)adDidEarnReward:(AdWhaleReward *)reward {
    [self sendEventWithName:@"onRewardAdEarned" body:@{
        @"amount": reward.amount ?: @0,
        @"type": reward.type ?: @""
    }];
}

@end 
