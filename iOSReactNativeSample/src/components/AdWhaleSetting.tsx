import React, { useEffect } from 'react';
import { StyleSheet, Text, View, Button } from 'react-native';
import { NativeModules } from 'react-native';

const { AdWhaleSettingModule } = NativeModules;

export default function AdWhaleSetting() {
  useEffect(() => {
    const showGDPR = async () => {
      try {
        const result = await AdWhaleSettingModule.showGDPR();
        console.log(`[adwhale] [sample UI] GDPR 표시 완료. 결과: ${result}`);
      } catch (error) {
        console.error(`[adwhale] [sample UI] GDPR 표시 실패: ${error}`);
      }
    };

    showGDPR();
  }, []);

  const showInspector = async () => {
    try {
      await AdWhaleSettingModule.showAdInspector();
      console.log(`[adwhale] [sample UI] AdInspector 표시 요청 완료`);
    } catch (error) {
      console.error(`[adwhale] [sample UI] AdInspector 표시 실패: ${error}`);
    }
  };

  return (
    <View style={styles.section}>
      <Text style={styles.title}>AdInspector</Text>
      <Button
        title="AdInspector 표시"
        onPress={showInspector}
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