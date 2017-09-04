//
//  RCTUmengShareManage.m
//  RCTUmengShare
//
//  Created by 庄彪 on 2017/9/3.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTUmengShareManage.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation RCTConvert (UMSocialPlatformType)

RCT_ENUM_CONVERTER(UMSocialPlatformType,
                   (@{
                      @"PlatformTypePredefineBegin": @(UMSocialPlatformType_Predefine_Begin),
                      @"PlatformTypeQQ" : @(UMSocialPlatformType_QQ),
                      @"PlatformTypeQzone" : @(UMSocialPlatformType_Qzone),
                      @"PlatformTypeWechatSession" : @(UMSocialPlatformType_WechatSession),
                      @"PlatformTypeWechatTimeLine" : @(UMSocialPlatformType_WechatTimeLine),
                      @"PlatformTypeSina" : @(UMSocialPlatformType_Sina)
                      }
                    ),
                   UMSocialPlatformType_Predefine_Begin,
                   integerValue)
@end


@implementation RCTUmengShareManage

RCT_EXPORT_MODULE(UmengShare);

- (NSDictionary *)constantsToExport {
  return @{
           @"PlatformTypePredefineBegin": @(UMSocialPlatformType_Predefine_Begin),
           @"PlatformTypeQQ" : @(UMSocialPlatformType_QQ),
           @"PlatformTypeQzone" : @(UMSocialPlatformType_Qzone),
           @"PlatformTypeWechatSession" : @(UMSocialPlatformType_WechatSession),
           @"PlatformTypeWechatTimeLine" : @(UMSocialPlatformType_WechatTimeLine),
           @"PlatformTypeSina" : @(UMSocialPlatformType_Sina)
           };
};



RCT_EXPORT_METHOD(share:(UMSocialPlatformType)platform messageObject:(NSDictionary *)object resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  NSInteger type = [[object objectForKey:@"type"] integerValue];
  UMShareObject *shareObject = nil;
  NSString *shareTitle = [object objectForKey:@"title"];
  NSString *shareContent = [object objectForKey:@"content"];
  NSString *shareUrl = [object objectForKey:@"url"];
  id shareImage = [object objectForKey:@"image"];
  switch (type) {
    case 0:
    default:
      if (platform == UMSocialPlatformType_Sina) {
        shareContent = [NSString stringWithFormat:@"%@\n%@", shareContent, shareUrl];
      }
      UMShareWebpageObject *webObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareContent thumImage:shareImage];
      webObject.webpageUrl = shareUrl;
      shareObject = webObject;
      break;
  }
  
  UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObjectWithMediaObject:shareObject];
  id currentVc = [UIApplication sharedApplication].keyWindow.rootViewController;
  //调用分享接口
  [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:currentVc completion:^(id data, NSError *error) {
    if (error) {
      reject([@(error.code) stringValue], error.localizedDescription, error);
    } else {
      resolve(data);
    }
  }];
}

RCT_EXPORT_METHOD(setAppkey:(NSString *)key) {
  [[UMSocialManager defaultManager] setUmSocialAppkey:key];
}

RCT_EXPORT_METHOD(setPlatform:(UMSocialPlatformType)platformType appKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL) {
  [[UMSocialManager defaultManager] setPlaform:platformType appKey:appKey appSecret:appSecret redirectURL:appSecret];
}

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

@end
