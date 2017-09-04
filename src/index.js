'use strict';

import {
  NativeModules,
  Platform
} from 'react-native';

const UmengShare = NativeModules.UmengShare;

export const PlatformType = {
    QQ: UmengShare.PlatformTypeQQ,
    Qzone: UmengShare.PlatformTypeQzone,
    WechatSession: UmengShare.PlatformTypeWechatSession,
    WechatTimeLine: UmengShare.PlatformTypeWechatTimeLine,
    Sina: UmengShare.PlatformTypeSina
}

/**
 * iOS only
 * @param {*} appKey 
 */
export const setAppkey = (appKey) => {
    if (Platform.OS === 'ios') {
        UmengShare.setAppkey(appKey);
    }
};

export const setPlatform = (platformType, appKey, appSecret, redirectURL) => {
    UmengShare.setPlatform(platformType, appKey, appSecret, redirectURL);
};

/**
 * 分享信息到其他平台
 * @param {*} platformType 
 * @param {*} messageObject 
 * @return Promise
 */
export const share = (platformType, messageObject) => {
    return UmengShare.share(platformType, messageObject);
};