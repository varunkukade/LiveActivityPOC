import React from 'react';
import {
  NativeModules,
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  useColorScheme,
} from 'react-native';

import {Colors} from 'react-native/Libraries/NewAppScreen';

function App(): JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  const onStart = () => {
    NativeModules.FoodDeliveryTrackerModule.startLiveActivity(
      'Jaun C.',
      4.7,
      '8 min',
      3,
    );
  };

  const onUpdate = () => {
    NativeModules.FoodDeliveryTrackerModule.updateLiveActivity(
      'Jaun C.',
      4.7,
      '2 min',
      NativeModules.FoodDeliveryTrackerModule.recordID,
    );
  };

  const onStopImmediate = () => {
    NativeModules.FoodDeliveryTrackerModule.stopLiveActivity(
      true,
      'Jaun C.',
      4.7,
      '0 min',
      NativeModules.FoodDeliveryTrackerModule.recordID,
    );
  };

  const onStopDefault = () => {
    NativeModules.FoodDeliveryTrackerModule.stopLiveActivity(
      false,
      'Jaun C.',
      4.7,
      '0 min',
      NativeModules.FoodDeliveryTrackerModule.recordID,
    );
  };

  return (
    <SafeAreaView style={styles.parent}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <TouchableOpacity style={styles.buttonContainer} onPress={onStart}>
        <Text style={styles.text}>Start Live Activity</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.buttonContainer} onPress={onUpdate}>
        <Text style={styles.text}>Update Live Activity</Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={styles.buttonContainer}
        onPress={onStopImmediate}>
        <Text style={styles.text}>Stop Live Activity .Immediately</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.buttonContainer} onPress={onStopDefault}>
        <Text style={styles.text}>Stop Live Activity .default</Text>
      </TouchableOpacity>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  parent: {
    width: '100%',
    height: '100%',
  },
  buttonContainer: {
    width: '70%',
    backgroundColor: 'grey',
    height: 60,
    marginBottom: 30,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 20,
    alignSelf: 'center',
  },
  text: {
    color: 'white',
    fontSize: 16,
  },
});

export default App;
