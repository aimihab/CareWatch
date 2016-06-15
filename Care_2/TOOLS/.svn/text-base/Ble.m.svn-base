//
//  Ble.m
//  Care_2
//
//  Created by baoyx on 15/6/8.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

static NSString* braceletScanService1 = @"0xCC01";
static NSString* braceletScanService2 = @"0000FEE9-0000-1000-8000-00805F9B34FB";
static NSString* braceletScanService3 = @"00001802-0000-1000-8000-00805f9b34fb";

#import "Ble.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface Ble()<CBCentralManagerDelegate,CBPeripheralDelegate>
@end
@implementation Ble
{
    CBPeripheral *peripheral_;
    CBCentralManager *manager_;
    NSString *address_;
    WKLBleState bleState_;
    NSArray *scaneServices_;  //搜索服务数组
    NSTimer *scanTimer_;      //扫描定时器
    NSTimer *connectTimer_;   //连接定时器
    ConnectSuccess  connectSuccessBlock_;
    CoreFailure  coreFailureBlock_;
    
}

+(Ble *)sharedInstance
{
    static Ble *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[Ble alloc] init];
    });
    return client;
}

-(instancetype)init
{
    if (self = [super init]) {
        scaneServices_ = @[[CBUUID UUIDWithString:braceletScanService1],[CBUUID UUIDWithString:braceletScanService2],[CBUUID UUIDWithString:braceletScanService3]];
        
        
    }
    return self;
}

-(void)pubControlSetup
{
    manager_ = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

}

-(void)pubConnectPeripheralWithDuration:(NSInteger)timeOut WithAddress:(NSString *)address withSuccess:(void (^)())success withError:(CoreFailure)failure
{
    connectSuccessBlock_  = [success copy];
    coreFailureBlock_ = [failure copy];
    
    address_ = address;
    [self privateStopScanTimer];
    [manager_ scanForPeripheralsWithServices:nil options:nil];
    scanTimer_ = [NSTimer scheduledTimerWithTimeInterval:timeOut target:self selector:@selector(privateScanTimerOut) userInfo:nil repeats:NO];
}

-(void)pubCancelPeripheral
{
    if (peripheral_) {
        if (peripheral_.state == CBPeripheralStateConnected) {
            [manager_ cancelPeripheralConnection:peripheral_];
        }
    }
}



#pragma mark 判断蓝牙状态

-(void)privateIsLECapableHardware
{
    switch ([manager_ state]) {
        case CBCentralManagerStateUnknown:
            bleState_ = WKLBleStateUnknown;
            break;
        case CBCentralManagerStateResetting:
            bleState_ = WKLBleStateUnsupported;
            break;
        case CBCentralManagerStateUnsupported:
            bleState_ = WKLBleStateUnsupported;
            break;
        case CBCentralManagerStateUnauthorized:
            bleState_ = WKLBleStateUnsupported;
            break;
        case CBCentralManagerStatePoweredOff:
            bleState_ = WKLBleStatePoweredOff;
            break;
        case CBCentralManagerStatePoweredOn:
            bleState_ = WKLBleStatePoweredOn;
            break;
        default:
            break;
    }
}

#pragma mark 判断手机蓝牙的状态
-(void)privateDecideBleState
{
    switch (bleState_) {
        case WKLBleStateUnsupported:
        {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"不支持的蓝牙"  forKey:NSLocalizedDescriptionKey];
            NSError *aError = [NSError errorWithDomain:@"com.wkl.ble" code:WKLBleErrorTypeUnsupported userInfo:userInfo];
            coreFailureBlock_(aError);
            return;
        }
            break;
        case WKLBleStatePoweredOff:
        {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"蓝牙未打开" forKey:NSLocalizedDescriptionKey];
            NSError *aError = [NSError errorWithDomain:@"com.wkl.ble" code:WKLBleErrorTypePoweredOff userInfo:userInfo];
            coreFailureBlock_(aError);
            return;
        }
            break;
        default:
            break;
    }
}

#pragma mark 停止搜索定时器
-(void)privateStopScanTimer
{
    if (scanTimer_) {
        [scanTimer_  invalidate];
        scanTimer_ = nil;
    }
}

#pragma mark 搜索定时器超时
-(void)privateScanTimerOut
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"搜索超时"  forKey:NSLocalizedDescriptionKey];
    NSError *aError = [NSError errorWithDomain:@"com.wkl.ble" code:WKLBleErrorTypeScan userInfo:userInfo];
    coreFailureBlock_(aError);
}

#pragma mark 停止连接定时器
-(void)privateStopConnectTimer
{
    if (connectTimer_) {
        [connectTimer_ invalidate];
        connectTimer_ = nil;
    }
}

#pragma mark 连接定时器超时
-(void)privateConnectTimerOut
{
    [self privateStopConnectTimer];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"连接超时" forKey:NSLocalizedDescriptionKey];
    NSError *aError = [NSError errorWithDomain:@"com.wkl.ble" code:WKLBleErrorTypeConnect userInfo:userInfo];
    coreFailureBlock_(aError);
}

#pragma mark  ----------------------中心设备代理 CBCentralManagerDelegate---------------------------------------

#pragma mark  蓝牙状态改变代理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self privateIsLECapableHardware];
}
#pragma mark  扫描外设代理
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([RSSI intValue] < -90 || [RSSI intValue] >90) {
        return;
    }
    
    DLog(@"advertisementData=%@",advertisementData);
    if ([[advertisementData allKeys] containsObject:@"kCBAdvDataManufacturerData"]) {
        
        
         NSData *manufacturerData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        const char *valueString = [[manufacturerData description] cStringUsingEncoding: NSUTF8StringEncoding];
        NSString *encrypted = [[NSString alloc] initWithCString:(const char*)valueString encoding:NSASCIIStringEncoding];
        
        
        if (encrypted.length >=15) {
            NSString *encrypted1 = [encrypted substringWithRange:NSMakeRange(1,8)];
            NSString *encrypted2 = [encrypted substringWithRange:NSMakeRange(10,4)];
            
            NSString *bleAddress = [NSString stringWithFormat:@"%@%@",encrypted1,encrypted2];
             DLog(@"bleAddress====%@",bleAddress);
            
            if ([bleAddress isEqualToString:address_]) {
                [self privateStopConnectTimer];
                [manager_ stopScan];
                peripheral_ = peripheral;
                [manager_ connectPeripheral:peripheral_ options:nil];
            }
        }
    }
}
#pragma mark 蓝牙连接成功代理
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self privateStopConnectTimer];
    connectSuccessBlock_();
    
}

#pragma mark  蓝牙连接失败代理
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self privateStopConnectTimer];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"连接失败" forKey:NSLocalizedDescriptionKey];
    NSError *aError = [NSError errorWithDomain:@"com.wkl.ble" code:WKLBleErrorTypeConnect userInfo:userInfo];
    coreFailureBlock_(aError);
}

#pragma mark  断开蓝牙连接回调
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(wklBleDisConnectPeripheral:)]) {
        [_delegate wklBleDisConnectPeripheral:peripheral];
        
        //断连报警音乐
//        DeviceModel *dev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
//        [[MusicPlayerController Instance] playWithMusicItem:dev.musicItem isStop:YES];
        DLog(@"断开蓝牙连接..")
    }
    
    
}



@end
