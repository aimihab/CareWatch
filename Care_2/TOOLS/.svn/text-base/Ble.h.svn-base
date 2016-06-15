//
//  Ble.h
//  Care_2
//
//  Created by baoyx on 15/6/8.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ConnectSuccess)(void);
typedef void (^CoreFailure)(NSError *error);
typedef NS_ENUM(NSInteger, WKLBleErrorType) {
    WKLBleErrorTypeUnsupported = 0,  //不支持蓝牙错误
    WKLBleErrorTypePoweredOff,  //蓝牙未打开
    WKLBleErrorTypeScan, //搜索失败错误
    WKLBleErrorTypeConnect,  //连接失败错误
};

typedef NS_ENUM(NSInteger,WKLBleState){
    WKLBleStateUnknown = 0, //初始化中状态
    WKLBleStateUnsupported , //不支持蓝牙状态
    WKLBleStatePoweredOff,  //未打开蓝牙状态
    WKLBleStatePoweredOn,  //蓝牙已启动状态
};

@class CBPeripheral;
@protocol bleDidConnectionsDelegate<NSObject>
/**
 *  外设断开代理
 *
 *  @param aPeripheral 外设对象
 */
-(void)wklBleDisConnectPeripheral : (CBPeripheral *)aPeripheral;
@end
@interface Ble : NSObject
@property (nonatomic,weak) id<bleDidConnectionsDelegate>delegate;

#pragma mark ---------纬科联蓝牙连接单例
/**
 *  纬科联蓝牙连接单例
 *
 *  @return 纬科联蓝牙连接单例对象
 */
+(Ble*)sharedInstance;

#pragma mark -----------开启中心设备(在AppDelegates设置)
/**
 *  开启中心设备(在AppDelegates设置)
 */
-(void)pubControlSetup;

/**
 *  连接外设
 *
 *  @param timeOut 连接时长
 *  @param address 蓝牙地址
 *  @param success 成功
 *  @param failure 失败
 */

-(void)pubConnectPeripheralWithDuration:(NSInteger)timeOut WithAddress:(NSString *)address withSuccess:(void (^)())success withError:(CoreFailure)failure;

-(void)pubCancelPeripheral;
@end
