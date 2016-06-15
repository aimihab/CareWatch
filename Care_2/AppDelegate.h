//
//  AppDelegate.h
//  Care_2
//
//  Created by JIA on 14-8-11.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


//@property (strong, nonatomic) UIViewController *splashViewController;
@property (nonatomic,copy)NSString *eqPhoneNum;//选中设备的SIM卡号码
@property (nonatomic, assign) BOOL isBleConnect;// 0 未连接 1 连接
@property (nonatomic, copy) NSDate *warnTime; // 告警次数

@end
