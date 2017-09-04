package com.rctumengshare;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.umeng.socialize.PlatformConfig;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMShareListener;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.media.UMWeb;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Nullable;

/**
 * Created by zhuang on 2017/9/4.
 */
public class UmengShareModule extends ReactContextBaseJavaModule {

    private static final String PlatformTypeQQ = "PlatformTypeQQ";
    private static final String PlatformTypeQzone = "PlatformTypeQzone";
    private static final String PlatformTypeWechatSession = "PlatformTypeWechatSession";
    private static final String PlatformTypeWechatTimeLine = "PlatformTypeWechatTimeLine";
    private static final String PlatformTypeSina = "PlatformTypeSina";

    public UmengShareModule(ReactApplicationContext reactApplicationContext) {
        super(reactApplicationContext);
    }

    @Override
    public String getName() {
        return "UmengShare";
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(PlatformTypeQQ, SHARE_MEDIA.QQ.toString());
        constants.put(PlatformTypeQzone, SHARE_MEDIA.QZONE.toString());
        constants.put(PlatformTypeWechatSession, SHARE_MEDIA.WEIXIN.toString());
        constants.put(PlatformTypeWechatTimeLine, SHARE_MEDIA.WEIXIN_CIRCLE.toString());
        constants.put(PlatformTypeSina, SHARE_MEDIA.SINA.toString());
        return constants;
    }

    @ReactMethod
    public void setPlatform(String platformType, String appKey, String appSecret, String redirectURL) {
        SHARE_MEDIA platform = SHARE_MEDIA.convertToEmun(platformType);
        switch (platform) {
            case QQ:
            case QZONE: {
                PlatformConfig.setQQZone(appKey, appSecret);
                break;
            }
            case WEIXIN:
            case WEIXIN_CIRCLE:
            case WEIXIN_FAVORITE: {
                PlatformConfig.setWeixin(appKey, appSecret);
                break;
            }
            case SINA: {
                PlatformConfig.setSinaWeibo(appKey, appSecret, redirectURL);
                break;
            }
        }
    }

    @ReactMethod
    public void share(String platformType, ReadableMap messageObject, final Promise promise) {
        SHARE_MEDIA platform = SHARE_MEDIA.convertToEmun(platformType);
        UMWeb web = new UMWeb(messageObject.getString("url"));
        web.setTitle(messageObject.getString("title"));//标题
//        web.setThumb(new UMImage(this, "123"));  //缩略图
        web.setDescription(messageObject.getString("content"));//描述
        new ShareAction(getCurrentActivity())
                .setPlatform(platform)
                .withMedia(web)
                .setCallback(new UMShareListener() {
                    @Override
                    public void onStart(SHARE_MEDIA share_media) {

                    }

                    @Override
                    public void onResult(SHARE_MEDIA share_media) {
                        promise.resolve(share_media);
                    }

                    @Override
                    public void onError(SHARE_MEDIA share_media, Throwable throwable) {
                        promise.reject(throwable);
                    }

                    @Override
                    public void onCancel(SHARE_MEDIA share_media) {
                        promise.reject(new Throwable(share_media.toString()));
                    }
                })
                .share();
    }
}
