/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';
import * as ShareUtils from 'react-native-zhb-umeng-share';

export default class examples extends Component {

  constructor(props) {
    super(props);
    ShareUtils.setAppkey('123');
    ShareUtils.setPlatform(ShareUtils.PlatformType.Sina, '123', '123', "http://www.baidu.com");
  }

  share = () => {
    ShareUtils.share(ShareUtils.PlatformType.Sina, {
      type: 0,
      title: '快递圈',
      content: '快递圈-快递员必看的行业圈，这里有最全的快递行业人员',
      url: 'https://pic.ksudi.com:8410/cer/index_shuttle.html'
    }).then(response => {
      console.log(response);
    }).catch(error => {
      console.log(error);
    });
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}
          onPress={this.share}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('examples', () => examples);
