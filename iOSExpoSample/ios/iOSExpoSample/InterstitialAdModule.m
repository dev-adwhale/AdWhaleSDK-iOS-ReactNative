#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(InterstitialAdModule, NSObject)

RCT_EXTERN_METHOD(loadAd:(NSString *)adUnitId
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(showAd:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end 