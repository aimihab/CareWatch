//
//  SearchDeviceViewController.m
//  Care_2
//
//  Created by xiaobing on 15/5/28.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "ConnetBlueAnimationCircle.h"
#import "Ble.h"
#import "DeviceModel.h"
#import "AppDelegate.h"
#import "MD5.h"
#import "ErrorAlerView.h"

@interface SearchDeviceViewController ()<bleDidConnectionsDelegate>
{
    
    __weak IBOutlet UIImageView *blueImage;//蓝牙图标

    __weak IBOutlet UIImageView *blueBackGround;
    
    __weak IBOutlet UILabel *StartCareLable;//开启在身边
    __weak IBOutlet UIButton *closeConnectionBtn;//断开蓝牙按钮
     UILabel *InfoLabel;
    
    __weak IBOutlet UILabel *lookingForDeviceLabel;//正在寻找设备
    
    NSTimer *circleTimer;
    
    BOOL isDisconnect;//是否主动断开
    
    __weak IBOutlet UIButton *SearchBleBtn;
    
    ConnetBlueAnimationCircle *circleAnimation;
    CBPeripheral *peripheral_;
}

@property (nonatomic,strong)UIImageView *bindingHaloView;
@end
@implementation SearchDeviceViewController

- (IBAction)clearBtnClick:(id)sender {//点击按钮连接蓝牙
    
    
    StartCareLable.text = NSLocalizedString(@"开启在身边", nil);
    InfoLabel.text = NSLocalizedString(@"请将手机和设备靠近来激活您的蓝牙设备", nil);
    InfoLabel.frame = CGRectMake(15, 55, 291, 62);
    [self.view addSubview:InfoLabel];
    lookingForDeviceLabel.text = NSLocalizedString(@"正在寻找设备", nil);
  //  lookingForDeviceLabel.frame = CGRectMake(109, 243, 102, 21);
    blueBackGround.image = [UIImage imageNamed:@"连接硬件_1"];
    blueImage.hidden = NO;
    
    [self bleConnecting];
    

}

- (void)setFailureUI
{
    if (![MD5 isChina]) {
        StartCareLable.font = [UIFont systemFontOfSize:15.0];
        InfoLabel.font = [UIFont systemFontOfSize:12];
    }
    StartCareLable.text = NSLocalizedString(@"无法连接蓝牙无法开启在身边", nil);
    
    
    InfoLabel.frame = CGRectMake(15, 70, 291, 62);
    InfoLabel.text = NSLocalizedString(@"请确定手机蓝牙是否打开,再尝试将您的手表贴近手机之后重新搜索", nil);
   // lookingForDeviceLabel.frame = CGRectMake(109, 255, 102, 21);
    blueImage.hidden = YES;
    SearchBleBtn.enabled = YES;// 激活蓝牙搜索按钮
    closeConnectionBtn.hidden = YES;
    blueBackGround.image = [UIImage imageNamed:@"组-10"];
    lookingForDeviceLabel.text = NSLocalizedString(@"重新搜索", nil);

}
- (void)setSuccessUI{

    DeviceModel *selectdDev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
    NSString *nameStr = selectdDev.nickName;
    StartCareLable.text = [NSString stringWithFormat:NSLocalizedString(@"已开启 %@ 在身边",nil),nameStr];
    lookingForDeviceLabel.text = NSLocalizedString(@"连接成功", nil);
    SearchBleBtn.enabled = NO;// 禁用蓝牙搜索按钮
   
    InfoLabel.text = NSLocalizedString(@"当设备远离您的手机,将会预警提醒", nil);
    [circleTimer invalidate];
    circleTimer = nil;
    [self.bindingHaloView.layer removeAllAnimations];
    closeConnectionBtn.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{

    [[Ble sharedInstance] pubControlSetup];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
   
    self.title = NSLocalizedString(@"搜索设备", nil);
    [closeConnectionBtn setTitle:NSLocalizedString(@"关闭在身边", nil) forState:UIControlStateNormal];
    
    
    InfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 291, 62)];
    InfoLabel.font = [UIFont systemFontOfSize:14];
    InfoLabel.textColor = [UIColor blackColor];
    InfoLabel.numberOfLines = 0;
    InfoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:InfoLabel];
   
    
    [self setBackButton];

    
    if (__APP.isBleConnect == YES) {
        [self setSuccessUI];
    }else{
    
        InfoLabel.text = NSLocalizedString(@"请将手机和设备靠近来激活您的蓝牙设备", nil);
        //转圈动画
        self.bindingHaloView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        self.bindingHaloView.image = [UIImage imageNamed:@"连接硬件_圈-动态光晕"];
        [self.view addSubview:self.bindingHaloView];
        self.bindingHaloView.center = blueBackGround.center;
        
        [self clearBtnClick:nil];//连接蓝牙，本地化文字

    }
    
}
_Method_SetBackButton(nil, NO)


- (void)bleConnecting
{
    [circleTimer invalidate];
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:-M_PI];
    rotationAnimation.duration = 4.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount =INT_MAX;
    [self.bindingHaloView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    if (circleTimer == nil)
    {
        circleTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(playAnimationView) userInfo:nil repeats:YES];
        [circleTimer fire];
    }

    DeviceModel *dev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
    NSString *bleStr = dev.bleMac;
    DLog(@"-------bleStr = %@",dev.bleMac);
      //00cdff0013fb // 00cdff0013fc
    [[Ble sharedInstance] pubConnectPeripheralWithDuration:100.f WithAddress:bleStr withSuccess:^{
        
        DLog(@"蓝牙连接成功");
        [self performSelector:@selector(setSuccessUI) withObject:nil afterDelay:1.0];
        __APP.isBleConnect = YES;
        [Ble sharedInstance].delegate = self;// 设置外设代理
        
    } withError:^(NSError *error) {
        switch ([error code]) {
            case WKLBleErrorTypeUnsupported:
            case WKLBleErrorTypePoweredOff:
            {
                NSLog(@"蓝牙未打开");
                [[Ble sharedInstance] pubControlSetup];// 提示打开手机蓝牙服务
              
            }
                break;
            case WKLBleErrorTypeScan:
            case WKLBleErrorTypeConnect:
            {
                NSLog(@"蓝牙连接失败");
                [circleTimer invalidate];
                circleTimer = nil;
                [self.bindingHaloView.layer removeAllAnimations];
                [self performSelector:@selector(setFailureUI) withObject:nil afterDelay:1.0];
                __APP.isBleConnect = NO;
        
            }
                break;
                
            default:
                break;
        }
    }];
    
}

- (void)playAnimationView
{
    
    circleAnimation = [[ConnetBlueAnimationCircle alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    [circleAnimation setCenter:blueBackGround.center];
    [self.view addSubview:circleAnimation];
    [circleAnimation stratAnimation];
    
}


#pragma mark - bleDidConnectionsDelegate 蓝牙外设断开代理
-(void)wklBleDisConnectPeripheral : (CBPeripheral *)aPeripheral
{
    
    if (isDisconnect == YES) {
        DLog(@"主动断开蓝牙连接..");
        [ErrorAlerView showWithMessage:NSLocalizedString(@"成功关闭", nil) sucOrFail:NO];
        StartCareLable.text = NSLocalizedString(@"开启在身边", nil);
        InfoLabel.text = NSLocalizedString(@"请将手机和设备靠近来激活您的蓝牙设备", nil);
        lookingForDeviceLabel.text = NSLocalizedString(@"重新搜索", nil);
        SearchBleBtn.enabled = YES;
        closeConnectionBtn.hidden = YES;
    }else{
    
        DLog(@"蓝牙被动断开...");
        //断连报警音乐
        DeviceModel *dev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
        [[MusicPlayerController Instance] playWithMusicItem:dev.musicItem isStop:YES];

        StartCareLable.text = NSLocalizedString(@"开启在身边", nil);
        InfoLabel.text = NSLocalizedString(@"请将手机和设备靠近来激活您的蓝牙设备", nil);
        lookingForDeviceLabel.text = NSLocalizedString(@"重新搜索", nil);
        SearchBleBtn.enabled = YES;
        closeConnectionBtn.hidden = YES;

        NSString *MgStr = [NSString stringWithFormat:NSLocalizedString(@"%@离开在身边范围,请立刻查看处理", nil),dev.nickName];
        MessageModel *msg = [[MessageModel alloc] initWithContent:MgStr];
        [dev.messageArr addObject:msg];
        
        CustomIOS7AlertView *alerView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:@"%@%@",dev.nickName,NSLocalizedString(@"在身边预警已触发,请确认设备安全", nil)]];
        [alerView show];
        return;
        
    //本地推送
        
    }
    
}

- (IBAction)closeBleConnectionClick:(UIButton *)sender {
    
    // 主动断开蓝牙连接
    [[Ble sharedInstance] pubCancelPeripheral];
//    [self.navigationController popViewControllerAnimated:YES];
    isDisconnect = YES;
    DLog(@"蓝牙成功断开...");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  }



@end
