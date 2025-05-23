import React, { useState, useEffect } from 'react';
import { StyleSheet, Text, View, Button, NativeEventEmitter, NativeModules } from 'react-native';

const { RewardAdModule } = NativeModules;

const REWARD_AD_UNIT_ID = '리워드 광고 AD_UNIT_ID 입력';

export default function RewardAd() {
  const [rewardLoaded, setRewardLoaded] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const eventEmitter = new NativeEventEmitter(RewardAdModule);
    
    const subscriptions = [
      eventEmitter.addListener('onRewardAdLoaded', () => {
        console.log(`[adwhale] [sample UI] 보상형 광고 로드 성공`);
        setRewardLoaded(true);
        setIsLoading(false);
      }),
      eventEmitter.addListener('onRewardAdFailedToLoad', (event) => {
        console.error(`[adwhale] [sample UI] 보상형 광고 로드 실패: ${event.error}`);
        setRewardLoaded(false);
        setIsLoading(false);
      }),
      eventEmitter.addListener('onRewardAdFailedToShow', (event) => {
        console.error(`[adwhale] [sample UI] 보상형 광고 표시 실패: ${event.error}`);
        setRewardLoaded(false);
      }),
      eventEmitter.addListener('onRewardAdWillPresent', () => {
        console.log(`[adwhale] [sample UI] 보상형 광고가 표시될 예정`);
      }),
      eventEmitter.addListener('onRewardAdDismissed', () => {
        console.log(`[adwhale] [sample UI] 보상형 광고가 닫힘`);
        setRewardLoaded(false);
      }),
      eventEmitter.addListener('onRewardAdEarned', (event) => {
        console.log(`[adwhale] [sample UI] 보상 획득: amount=${event.amount}, type=${event.type}`);
      })
    ];

    return () => {
      subscriptions.forEach(subscription => subscription.remove());
    };
  }, []);

  const loadReward = async () => {
    try {
      setIsLoading(true);
      await RewardAdModule.loadAd(REWARD_AD_UNIT_ID);
    } catch (error) {
      console.error(`[adwhale] [sample UI] 보상형 광고 로드 실패: ${error}`);
      setIsLoading(false);
    }
  };

  const showReward = async () => {
    try {
      await RewardAdModule.showAd();
    } catch (error) {
      console.error(`[adwhale] [sample UI] 보상형 광고 표시 실패: ${error}`);
    }
  };

  return (
    <View style={styles.section}>
      <Text style={styles.title}>보상형 광고</Text>
      <Button
        title="보상형 광고 로드"
        onPress={loadReward}
        disabled={isLoading || rewardLoaded}
      />
      <Button
        title="보상형 광고 표시"
        onPress={showReward}
        disabled={!rewardLoaded}
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