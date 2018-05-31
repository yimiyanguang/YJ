//
//  HGBBatteryTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/31.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



#ifdef DEBUG
#define HGBLogFlag YES
#else
#endif


/**
 错误类型
 */
typedef enum HGBBatteryToolErrorType
{
    HGBBatteryToolErrorTypeDevice=10,//设备受限
    HGBBatteryToolErrorTypeAuthority=11//权限问题

}HGBBatteryToolErrorType;
@class HGBBatteryTool;
@protocol HGBBatteryToolDelegate<NSObject>

/**
 电池信息更新

 @param battery 电池
 */
- (void)batteryStatusDidUpdated:(HGBBatteryTool*)battery ;
/**
 电池信息获取失败

 @param battery 电池
 @param errorInfo 错误信息
 */
- (void)batteryStatusUpdate:(HGBBatteryTool*)battery didFailedWithError:(NSDictionary *)errorInfo;;
@end

@interface HGBBatteryTool : NSObject
@property (nonatomic, weak) id<HGBBatteryToolDelegate> delegate;

/**
 电池容量
 */
@property (nonatomic, assign) NSUInteger capacity;
/**
 电压
 */
@property (nonatomic, assign) CGFloat voltage;

/**
 剩余电量百分比
 */
@property (nonatomic, assign) NSUInteger levelPercent;
/**
 剩余电量
 */
@property (nonatomic, assign) NSUInteger levelMAH;
/**
 电池状态
 */
@property (nonatomic, copy)   NSString *status;

/**
 单例

 @return 实例
 */
+ (instancetype)sharedInstance;

/**
 开始监测电池电量
 */
- (void)startBatteryMonitoring;

/**
  停止监测电池电量
 */
- (void)stopBatteryMonitoring;
@end
