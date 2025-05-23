import React, { Component } from 'react';
import { View, Button, StyleSheet, Dimensions, Text, TouchableOpacity } from 'react-native';
import { requireNativeComponent } from 'react-native';

const windowWidth = Dimensions.get('window').width;

const styles = StyleSheet.create({
  container: {
    justifyContent: 'flex-start',
    alignItems: 'center',
    paddingTop: 20,
  },
  buttonContainer: {
    width: '100%',
  },
  buttonWrapper: {
    marginBottom: 5,
    width: '80%',
    alignSelf: 'center',
  },
  adWhaleMediationAdViewStyle: {
    height: 250,
    width: windowWidth,
    backgroundColor: 'yellow',
    marginBottom: 20,
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
});

const radioStyles = StyleSheet.create({
  radioGroup: {
    justifyContent: 'space-around',
    marginBottom: 10,
  },
  radioButton: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  outerCircle: {
    height: 24,
    width: 24,
    borderRadius: 12,
    borderWidth: 2,
    borderColor: '#000',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 10,
  },
  innerCircle: {
    height: 12,
    width: 12,
    borderRadius: 6,
    backgroundColor: '#000',
  },
});

interface BannerAdProps {
  style?: any;
  onAdLoaded?: (event: any) => void;
  onAdLoadFailed?: (event: any) => void;
  onAdClicked?: (event: any) => void;
}

interface BannerAdState {
  isReload: boolean;
  selectedSize: string;
}

const BannerAdView = requireNativeComponent<any>('BannerAdView');

class BannerAd extends Component<BannerAdProps, BannerAdState> {
  state: BannerAdState = {
    isReload: false,
    selectedSize: 'BANNER320x50',
  };

  placementUid = '배너 광고 AD_UNIT_ID 입력';

  onPressBannerLoadButton = () => {
    console.log(`[adwhale] [sample UI] 배너 광고 로드 요청`);
    this.setState(prevState => ({ isReload: !prevState.isReload }));
  }

  _onAdLoaded = (event: any) => {
    console.log(`[adwhale] [sample UI] 배너 광고 로드 성공`);
    this.setState({ isReload: false });
  }

  _onAdLoadFailed = (event: any) => {
    const { statusCode, message } = event.nativeEvent;
    console.error(`[adwhale] [sample UI] 배너 광고 로드 실패: statusCode=${statusCode}, message=${message}`);
    this.setState({ isReload: false });
  }

  _onAdClicked = (event: any) => {
    console.log(`[adwhale] [sample UI] 배너 광고 클릭`);
  }

  handleSizeChange = (size: string) => {
    console.log(`[adwhale] [sample UI] 배너 크기 변경: size=${size}`);
    this.setState({ selectedSize: size });
  }

  getBannerHeight = (size: string) => {
    switch (size) {
      case 'BANNER320x50':
        return 50;
      case 'BANNER320x100':
        return 100;
      case 'BANNER300x250':
        return 250;
      default:
        return 50;
    }
  };

  render() {
    const { selectedSize } = this.state;
    const bannerHeight = this.getBannerHeight(selectedSize);

    return (
      <View style={styles.container}>
        <Text style={styles.title}>배너 광고</Text>
        <View style={radioStyles.radioGroup}>
          {['BANNER320x50', 'BANNER320x100', 'BANNER300x250'].map(size => (
            <TouchableOpacity
              key={size}
              style={radioStyles.radioButton}
              onPress={() => this.handleSizeChange(size)}
            >
              <View style={radioStyles.outerCircle}>
                {selectedSize === size && <View style={radioStyles.innerCircle} />}
              </View>
              <Text>{size}</Text>
            </TouchableOpacity>
          ))}
        </View>

        <View style={styles.buttonContainer}>
          <View style={styles.buttonWrapper}>
            <Button title="Banner load" onPress={this.onPressBannerLoadButton} />
          </View>
        </View>

        <View
          style={{
            width: windowWidth,
            height: 250,
            backgroundColor: 'yellow',
            marginBottom: 20,
            alignItems: 'center',
            justifyContent: 'flex-end',
          }}
        >
          <BannerAdView
            style={{
              width: windowWidth,
              height: bannerHeight,
              backgroundColor: 'transparent',
            }}
            placementUid={this.placementUid}
            adSize={selectedSize}
            shouldLoadAd={this.state.isReload}
            onAdLoaded={this._onAdLoaded}
            onAdLoadFailed={this._onAdLoadFailed}
            onAdClicked={this._onAdClicked}
          />
        </View>
      </View>
    );
  }
}

export default BannerAd; 