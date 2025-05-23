#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <AdWhaleSDK/AdWhaleSDK.h>
#import <React/RCTUtils.h>

@interface InterstitialAdModule : RCTEventEmitter <RCTBridgeModule, AdWhaleInterstitialDelegate>
@property (nonatomic, strong) AdWhaleInterstitialAd *interstitialAd;
@end

@implementation InterstitialAdModule

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
        @"onInterstitialAdLoaded",
        @"onInterstitialAdFailedToLoad",
        @"onInterstitialAdFailedToShow",
        @"onInterstitialAdWillPresent",
        @"onInterstitialAdDismissed"
    ];
}

RCT_EXPORT_METHOD(loadAd:(NSString *)adUnitId
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.interstitialAd = [[AdWhaleInterstitialAd alloc] init];
        self.interstitialAd.interstitialDelegate = self;
        [self.interstitialAd load:adUnitId];
        if (resolve) resolve(nil);
    });
}

RCT_EXPORT_METHOD(showAd:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootVC = RCTPresentedViewController();
        if (rootVC) {
            [self.interstitialAd show:rootVC];
            if (resolve) resolve(nil);
        } else {
            if (reject) reject(@"ERROR", @"Root view controller not found", nil);
        }
    });
}

// MARK: - AdWhaleInterstitialDelegate
- (void)adDidReceiveInterstitialAd:(AdWhaleInterstitialAd *)ad {
    self.interstitialAd = ad;
    [self sendEventWithName:@"onInterstitialAdLoaded" body:nil];
}
- (void)adDidFailToReceiveInterstitialAdWithError:(NSError *)error {
    [self sendEventWithName:@"onInterstitialAdFailedToLoad" body:@{@"error": error.localizedDescription ?: @""}];
}
- (void)ad:(AdWhaleInterstitialAd *)ad didFailToPresentInterstitialAdWithError:(NSError *)error {
    [self sendEventWithName:@"onInterstitialAdFailedToShow" body:@{@"error": error.localizedDescription ?: @""}];
}
- (void)adWillPresentInterstitialAd:(AdWhaleInterstitialAd *)ad {
    [self sendEventWithName:@"onInterstitialAdWillPresent" body:nil];
}
- (void)adDidDismissInterstitialAd:(AdWhaleInterstitialAd *)ad {
    [self sendEventWithName:@"onInterstitialAdDismissed" body:nil];
}

@end 
