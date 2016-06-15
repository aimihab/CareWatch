//
//  ChildDev.h
//  Care_2
//
//  Created by lq on 15-3-19.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildDev : NSObject

#pragma mark - 轨迹查看模型
@property (nonatomic,copy) NSString * devID;
@property (nonatomic,copy) NSString  *latitude;
@property (nonatomic,copy) NSString  *longitude;
@property (nonatomic,copy) NSString * date;// 采集日期
@property (nonatomic,copy) NSString * locationType; // 定位类型



#pragma mark - 心率模型
@property (atomic, assign) float heartRate;//  心率
@property (nonatomic,copy) NSString *rateTime; // 时间

#pragma mark - 记步模型
@property (nonatomic, assign) NSInteger steps;// 步数
@property (nonatomic,copy) NSString *stepTime;

+(ChildDev *)sharedInstance;
@end
