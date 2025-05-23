import React, { useState, useEffect } from 'react';
import { StyleSheet, Text, View, Button, NativeEventEmitter, NativeModules } from 'react-native';

const { InterstitialAdModule } = NativeModules;

const INTERSTITIAL_AD_UNIT_ID = '전면 광고 AD_UNIT_ID 입력';

export default function InterstitialAd() {
  const [interstitialLoaded, setInterstitialLoaded] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const eventEmitter = new NativeEventEmitter(InterstitialAdModule);
    
    const subscriptions = [
      eventEmitter.addListener('onInterstitialAdLoaded', () => {
        console.log(`[adwhale] [sample UI] 전면 광고 로드 성공`);
        setInterstitialLoaded(true);
        setIsLoading(false);
      }),
      eventEmitter.addListener('onInterstitialAdFailedToLoad', (event) => {
        console.error(`[adwhale] [sample UI] 전면 광고 로드 실패: ${event.error}`);
        setInterstitialLoaded(false);
        setIsLoading(false);
      }),
      eventEmitter.addListener('onInterstitialAdFailedToShow', (event) => {
        console.error(`[adwhale] [sample UI] 전면 광고 표시 실패: ${event.error}`);
        setInterstitialLoaded(false);
      }),
      eventEmitter.addListener('onInterstitialAdWillPresent', () => {
        console.log(`[adwhale] [sample UI] 전면 광고가 표시될 예정`);
      }),
      eventEmitter.addListener('onInterstitialAdDismissed', () => {
        console.log(`[adwhale] [sample UI] 전면 광고가 닫힘`);
        setInterstitialLoaded(false);
      })
    ];

    return () => {
      subscriptions.forEach(subscription => subscription.remove());
    };
  }, []);

  const loadInterstitial = async () => {
    try {
      setIsLoading(true);
      await InterstitialAdModule.loadAd(INTERSTITIAL_AD_UNIT_ID);
    } catch (error) {
      console.error(`[adwhale] [sample UI] 전면 광고 로드 실패: ${error}`);
      setIsLoading(false);
    }
  };

  const showInterstitial = async () => {
    try {
      await InterstitialAdModule.showAd();
    } catch (error) {
      console.error(`[adwhale] [sample UI] 전면 광고 표시 실패: ${error}`);
    }
  };

  return (
    <View style={styles.section}>
      <Text style={styles.title}>전면 광고</Text>
      <Button
        title="전면 광고 로드"
        onPress={loadInterstitial}
        disabled={isLoading || interstitialLoaded}
      />
      <Button
        title="전면 광고 표시"
        onPress={showInterstitial}
        disabled={!interstitialLoaded}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  section: {
    marginBottom: 20,
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
}); 