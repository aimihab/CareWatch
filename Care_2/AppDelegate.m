//
//  AppDelegate.m
//  Care_2
//
//  Created by JIA on 14-8-11.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "AppDelegate.h"
#import "Nav_ViewController.h"
#import "HomePage_ViewController.h"
#import "UserData.h"
#import "Ble.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
#if 0
    //设置splashVC，显示splashVC.view。不使用其他splashVC的功能
    self.splashViewController=[[UIViewController alloc]init];
    NSString * splashImageName=@"en_LanuchImage640";
    if(self.window.bounds.size.height>480){
        splashImageName=@"en_load_page";
    }
    self.splashViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:splashImageName]];
    //把splashVC添加进去
    [self.window addSubview:self.splashViewController.view];
    //⬇️ 让splashimage显示2s，让用户看一眼得了。
    [self performSelector:@selector(splashAnimate:) withObject:@0.0 afterDelay:2.0];
#endif
    
 //   [[Ble sharedInstance] pubControlSetup];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    HomePage_ViewController *homePageVC = [[HomePage_ViewController alloc] initWithNibName:@"HomePage_ViewController" bundle:nil];
    Nav_ViewController *nav = [[Nav_ViewController alloc] initWithRootViewController:homePageVC];
    [self.window setRootViewController:nav];
    
    //设置状态栏
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
 
    // 注册推送通知功能,形式:标记，声音，提示
//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert |UIUserNotificationTypeBadge)  categories:nil]];
//    [[UIApplication sharedApplication]registerForRemoteNotifications];
//    application.applicationIconBadgeNumber = 0;
    
    if(IOS8){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge                                                                               |UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeNewsstandContentAvailability)];
    }
    

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
   // 判断程序是不是由推送服务完成的
    if (launchOptions) {
        
        //获取应用程序消息通知标记数（即小红圈中的数字）
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        
        
            NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
            if (pushNotificationKey) {
            
            // 这是通过推送窗口启动的程序，你可以在这里处理推送内容
            NSString *pushString = [NSString stringWithFormat:@"%@",[pushNotificationKey objectForKey:@"aps"]];
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"finish Loaunch" message:pushString delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
            [alert show];
                
            }
        
        }
        
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[UserData Instance] saveCustomObject:[UserData Instance]];
    [[UserData Instance] save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[UserData Instance] saveCustomObject:[UserData Instance]];
    [[UserData Instance] save];
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSLog(@"regisger success:%@",deviceToken);
    
    
     //注册成功，将deviceToken保存到应用服务器数据库中
    if (![deviceToken length])
    {
        return;
    }
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"-- -- --token====%@",token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{

    DLog(@"Register fail %@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary*)userInfo{
    
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]);
    
    /* eg.
     key: aps, value: {
     alert = "\U8fd9\U662f\U4e00\U6761\U6d4b\U8bd5\U4fe1\U606f";
     badge = 1;
     sound = default;
     }
     */
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    if (application.applicationState == UIApplicationStateActive) {
        // 转换成一个本地通知，显示到通知栏，你也可以直接显示出一个alertView，只是那样稍显aggressive：）
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else {
       
    }
    
}

#if 0
-(void) splashAnimate:(NSNumber *)alpha{
    // ⬇️ 只能用UIViewAnimationOptionCurveEaseInOut和ViewAnimationOptionTransitionNone两种效果
    UIView * splashView=self.splashViewController.view;
    [UIView animateWithDuration:1.0 animations:^{
        splashView.transform=CGAffineTransformScale(splashView.transform, 1.5, 1.5);
        splashView.alpha=alpha.floatValue;
    } completion:^(BOOL finished) {
        //ARC通过赋值nil释放内存，动画中不能removeFromSuperview.
        [splashView removeFromSuperview];
        self.splashViewController=nil;
    }];
}
#endif

@end