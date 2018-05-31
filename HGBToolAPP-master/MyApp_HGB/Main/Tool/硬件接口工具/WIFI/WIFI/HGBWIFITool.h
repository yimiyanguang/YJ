//
//  HGBWIFITool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/12/21.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HGBWIFIReslutBlock)(BOOL status,NSDictionary *returnMessage);

@interface HGBWIFITool : NSObject

/**
 ping url

 @param url url
 @param reslutBlock 结果
 */
+(void)pingUrl:(NSString *)url withReslutBlock:(HGBWIFIReslutBlock)reslutBlock;

/**
 获取WiFi的IP地址

 @return WiFi的IP地址
 */
+(NSString *)getLocalWiFiIPAddress;
/**
 获取WIFI名

 @return WIFI名
 */
+ (NSString *)getWIFIName;

/**
 打开WIFI设置界面
 */
+(void)openWIFISet;

/**
 获取当前连接的网络名称

 @return 当前连接的网络名称
 */
+(NSString *)getCurrentWifiSSID;
@end
