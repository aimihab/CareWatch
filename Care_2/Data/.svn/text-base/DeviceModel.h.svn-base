//
//  DeviceModel.h
//  Q2_local
//
//  Created by Vecklink on 14-7-15.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MessageModel.h"

@interface DeviceModel : NSObject

// 设备信息
@property (nonatomic, copy) NSString *nickName;       //名字
@property (nonatomic, strong) NSData *avatar;         //头像
@property (nonatomic,strong) NSString *avatarUrl;     //头像url

@property (atomic, assign) int electricity;           //设备电量
@property (atomic, assign) BOOL online;               //在线状态
@property (atomic, assign) BOOL isGpsOn;              //GPS开关: 0 关 1 开
@property (atomic, assign) BOOL isFallOff;            //脱落状态: 0 脱落 1 带上   (要做远程推送)
@property (atomic, assign) double heartRate;          //心率数据


@property (nonatomic, copy) NSString *phoneNumber;    //设备手机号
@property (nonatomic,copy) NSString *devHeight;       //身高
@property (nonatomic,copy) NSString *devWeight;       //体重
@property (nonatomic,assign)int devSex;               //性别 0 女 1 男

@property (nonatomic, assign) int modeType;           //设备情景模式:0 标准 1 静音
@property (nonatomic, assign) int locationType;       //定位模式:0 普通 1 高精准
@property (nonatomic, assign) int isAdmin;            //管理员权限:否:0 是:1


@property (nonatomic, copy) NSString *bindIMEI;       //设备IMEI
@property (nonatomic, copy) NSString *bleMac;         //设备蓝牙MAC地址
@property (nonatomic, strong) NSObject *musicItem;    //预警音乐

//设备所在经纬度
@property (nonatomic, assign) CGFloat la;
@property (nonatomic, assign) CGFloat lo;
@property (nonatomic,copy) NSString *locateTime;      //定位的时间
@property (nonatomic, assign) int positioningType;   //定位类型：0 gps, 1 lbs, 2 wifi

//关爱
@property (nonatomic, assign) NSInteger careInterval; //关爱间隔
@property (nonatomic, assign) int careDist;           //关爱距离
@property (atomic, strong) NSNumber *nowDist;         //当前距离
@property (nonatomic, assign) int careType;           //关爱类型  0离开预警范围  1进入预警范围

//围栏
@property (nonatomic,assign) int fenceDist;    //围栏半径
@property (nonatomic,assign) int fenceType;    //1、进入报警  2、离开报警
@property (nonatomic,assign) double lat;       //围栏中心纬度
@property (nonatomic,assign) double lng;       //围栏中心经度
@property (nonatomic, copy) NSString *fenceId; //围栏编号

//远程看护
@property (nonatomic, strong) NSMutableArray *remoteCare; //记录设备的历史位置信息
@property (nonatomic,assign) int type;   //1、围栏设备  2、关爱设备

@property (nonatomic,strong) NSString *clockTime;       // 闹钟时间
@property (nonatomic,strong) NSMutableArray *repeatDate;// 闹钟重复周期

//消息中心
@property (strong) NSMutableArray *messageArr;

@property (strong) NSMutableArray *setPhoneNumberArr;//亲情号码集合
@property (strong) NSMutableArray *trustPhoneNumberArr;// 可信号码集合

//记步
@property (nonatomic, assign) NSInteger goalSteps; //目标步数

-(instancetype)initWithName:(NSString *)name phone:(NSString *)phone imei:(NSString *)imei bleMac:(NSString *)bleMac withUrl:(NSString *)url;

@end
