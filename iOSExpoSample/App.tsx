import React from 'react';
import { StyleSheet, View, SafeAreaView, ScrollView } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import InterstitialAd from './src/components/InterstitialAd';
import RewardAd from './src/components/RewardAd';
import AdWhaleSetting from './src/components/AdWhaleSetting';
import BannerAd from './src/components/BannerAd';

export default function App() {
  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.mainViewStyle}>
        <ScrollView>
          <StatusBar style="auto" />
          <View style={styles.contentViewStyle}>
              <BannerAd />
              <InterstitialAd />
              <RewardAd />
              <AdWhaleSetting />
          </View>
        </ScrollView>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: 'white'
  },
  mainViewStyle: {
    flex: 1,
    marginTop: 50
  },
  contentViewStyle: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'                
  },
}); 
