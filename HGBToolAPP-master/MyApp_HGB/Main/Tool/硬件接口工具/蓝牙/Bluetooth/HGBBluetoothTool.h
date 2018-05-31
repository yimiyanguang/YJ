//
//  HGBBluetoothTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/11/5.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


#define MyPeripheralName @"MyPeripheralName"
#define MySUUID @"XXXX"
#define MyCUUID @"XXXX"

#define kNotificationConnected @"kNotificationConnected"
#define kNotificationDisconnected @"kNotificationDisconnected"




typedef enum _HGB_Command_Type
{
    HGB_Command_Invalid = -1,
    HGB_Command_Start = 0x0,
    HGB_Command_Mode1 = 0x1,
    HGB_Command_Mode2,
    HGB_Command_Mode3,
    HGB_Command_Mode4,
    HGB_Command_Mode5,
    HGB_Command_Mode6,
    HGB_Command_Mode7,
    HGB_Command_Mode8,
    HGB_Command_Mode9,
    HGB_Command_Stop,
    HGB_Command_Shutdown,//关机
}HGB_CommandType;


@class HGBBluetoothTool;
@protocol HGBBluetoothToolDelegate<NSObject>

- (void)bluetoothTool:(HGBBluetoothTool *)bluetooth didFailedWithError:(NSDictionary *)errorInfo;
@end

@interface HGBBluetoothTool : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
/**
 代理
 */
@property(strong,nonatomic)id<HGBBluetoothToolDelegate>delegate;

@property (nonatomic,assign)BOOL bluetoothPowerOn;

/**
 *  单例方法
 *
 *  @return 单例
 */
+(HGBBluetoothTool*)shareInstance;

/**
 *  开始扫描
 */
-(void)startScan;

/**
 *  停止扫描
 */
-(void)stopScan;


/**
 *  连接
 */
-(void)startconnect;

/**
 *  取消连接
 */
-(void)cancelConnect;


/**
 *  向设备写数据
 */
-(BOOL)writeData:(NSData*)data;

/**
 *  是否可以准备好写数据
 *
 *  @return 是否可以准备好写数据
 */
-(BOOL)isReady;

/**
 *  发送命令
 *
 *  @param command 命令内容
 *
 *  @return 是否发送成功
 */
-(BOOL)sendCommand:(HGB_CommandType)command;


@end

