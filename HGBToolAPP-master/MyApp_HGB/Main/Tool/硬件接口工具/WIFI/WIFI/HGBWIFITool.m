//
//  HGBWIFITool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/12/21.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBWIFITool.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>

#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIKit.h>
@interface HGBWIFITool ()
@property(copy,nonatomic)HGBWIFIReslutBlock resultBlock;
@end

@implementation HGBWIFITool

#pragma mark init
static HGBWIFITool *instance=nil;
/**
 单例

 @return 实例
 */
+(instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBWIFITool alloc]init];
    }
    return instance;
}
#pragma mark func
/**
 ping url

 @param url url
 @param reslutBlock 结果
 */
+(void)pingUrl:(NSString *)url withReslutBlock:(void(^)(BOOL status,NSDictionary *returnMessage))reslutBlock;
{

}

/**
 获取WiFi的IP地址

 @return WiFi的IP地址
 */
+(NSString *)getLocalWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;

    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}
/**
 获取WIFI名

 @return WIFI名
 */
+ (NSString *)getWIFIName{

    NSString *wifiName = @"Not Found";

    CFArrayRef myArray = CNCopySupportedInterfaces();

    if (myArray != nil) {

        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));

        if (myDict != nil) {

            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);

            wifiName = [dict valueForKey:@"SSID"];

        }


    }
    return wifiName;
}

/**
 打开WIFI设置界面
 */
+(void)openWIFISet{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}
+(void)openSystemSetting:(NSString *)settingName{
    //iOS8 才有效
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
#define SETTING_URL @"app-settings:"
#else
#define SETTING_URL   UIApplicationOpenSettingsURLString
#endif

    //  NSLog(UIApplicationOpenSettingsURLString);
    if (version >= 8.0){
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:SETTING_URL]];
    }
}

/**
 获取当前连接的网络名称

 @return 当前连接的网络名称
 */
+(NSString *)getCurrentWifiSSID
{
#if TARGET_OS_SIMULATOR
    return @"(simulator)";
#else
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();

    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"] ;

    return ssid;
#endif
}
@end
