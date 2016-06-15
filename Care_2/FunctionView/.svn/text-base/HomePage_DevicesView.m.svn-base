//
//  HomePageDevices_View.m
//  Q2_local
//
//  Created by Vecklink on 14-7-19.
//  Copyright (c) _DevFirstTag+14年 Joe. All rights reserved.
//


#import "HomePage_DevicesView.h"
#import "AppDelegate.h"
#import "DeviceModel.h"
#define _DevButtonWidth 57      //设备按钮高、宽度
#define _DevFirstTag    100     //设备按钮的tag值从100开始递增+1
#define _Left_ArrowTag  200     //左边箭头的tag值
#define _Right_ArrowTag 201     //右边箭头的tag值

@interface HomePage_DevicesView() {
    __weak IBOutlet UIScrollView *_scrollView;
    
    NSArray *devAscKeys;// 设备号数组
    int selIndex;
    
    ASIHTTPRequest *req;
}
- (IBAction)onDeviceButtonPressed:(UIButton *)sender;
- (IBAction)onArrowButtonPressed:(UIButton *)sender;
@end

@implementation HomePage_DevicesView

-(void)awakeFromNib {
    for (int i=0; i<4; i++) {
        UIButton *bt = (UIButton *)[_scrollView viewWithTag:_DevFirstTag+i];
        bt.layer.cornerRadius = 5;
        bt.layer.masksToBounds = YES;
        bt.layer.borderColor = [UIColor whiteColor].CGColor;
        bt.layer.borderWidth = _Avatar_width;
        
        int btWidth = bt.bounds.size.width;
        UIImageView *onlineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(btWidth-15, btWidth-15, 13.5, 13.5)];
        onlineImgView.image = [UIImage imageNamed:@"devices_offline"];
        onlineImgView.tag = 200;
        [bt addSubview:onlineImgView];
        onlineImgView.hidden = YES;
    }
    _scrollView.bounces = YES;
    _scrollView.scrollEnabled = YES;
}

-(void)refreshDevicesView {
    //查看绑定设备列表
    if ([[UserData Instance] isLogin]) {
        [self sendGetDevListHTTPRequest];
    }
}

//刷新设备在线状态
-(void)refreshDevicesOnlineState {
    
    int devCount = [UserData Instance].deviceDic.count;
    int maxCount = devCount<4 ? 4 : devCount;
    for (int i=0; i<maxCount; i++) {
        DeviceModel *devObj;
        if (i < devCount) {
            devObj = [UserData Instance].deviceDic[devAscKeys[i]];
        }
        
        UIButton *bt = (UIButton *)[_scrollView viewWithTag:_DevFirstTag+i];
        
        if (bt) {       //找到DevBt，存放设备
            UIImageView *onlineImgView = (UIImageView *)[bt viewWithTag:200];
            if (onlineImgView) {
                onlineImgView.image = [UIImage imageNamed:(devObj.online ? @"devices_online":@"devices_offline")];
            }
        }
    }
}
-(void)refreshDeviceOnlineState:(DeviceModel *)dev {
    for (int i=0; i<devAscKeys.count; i++) {
        if ([devAscKeys[i] isEqualToString:dev.bindIMEI]) {
            UIButton *bt = (UIButton *)[_scrollView viewWithTag:_DevFirstTag+i];
            if (bt) {
                UIImageView *onlineImgView = (UIImageView *)[bt viewWithTag:200];
                if (onlineImgView) {
                    onlineImgView.image = [UIImage imageNamed:(dev.online ? @"devices_online":@"devices_offline")];
                }
            }
        }
    }
}


-(void)getDevListFinishAndRefreshUI {
    int devCount = [UserData Instance].deviceDic.count;
    if (devCount) {
        //设备排序
        NSArray *keyArr = [[UserData Instance].deviceDic allKeys];
        devAscKeys = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
            return result==NSOrderedDescending;
        }];
        //找到常用设备排序后的位置
        for (int i=0; i<devAscKeys.count; i++) {
            if ([[UserData Instance].likeDevIMEI isEqualToString:devAscKeys[i]]) {
                selIndex = i;
                break;
            }
        }
    }
    
    //无：all.enabled=NO
    //有：selected.alpha=1, other.alpha=0.5
    if (devCount < 4) {     //设置contentSize并把多的DevButton释放
        _scrollView.contentSize = _scrollView.bounds.size;
    } else {
        _scrollView.contentSize = CGSizeMake((_DevButtonWidth+10)*devCount, _DevButtonWidth);
        if (_scrollView.subviews.count>4 && _scrollView.subviews.count>devCount) {
            //滚动视图里面的设备比存储的在用户模型里面的设备多，就把多余的给删除，
            for (int i=devCount; i<_scrollView.subviews.count; i++) {
                [[_scrollView viewWithTag:_DevFirstTag+i] removeFromSuperview];
            }
        }
    }
    NSArray *imgsName = @[@"icon_default_head_1", @"icon_default_head_2", @"icon_default_head_3", @"icon_default_head_4"];
    if (!devCount) {        //没有设备时，设置按钮不可用
        ((UIButton *)[_scrollView viewWithTag:_DevFirstTag+selIndex]).layer.borderColor = [UIColor whiteColor].CGColor;
        [self onDeviceButtonPressed:nil];
        for (int i=0; i<_scrollView.subviews.count; i++) {
            UIButton *bt = (UIButton *)[_scrollView viewWithTag:_DevFirstTag+i];
            bt.enabled = NO;
            bt.hidden = NO;
            bt.alpha = 1;
            ((UIImageView *)[bt viewWithTag:200]).hidden = YES;
            if (i<4) {
                [bt setImage:[UIImage imageNamed:imgsName[i]] forState:UIControlStateNormal];
            }
        }
    } else {
        //有设备时
        int maxCount = devCount<4 ? 4 : devCount;
        int j=0;
        for (int i=0; i<maxCount; i++,j++) {
            DeviceModel *devObj;
            if (i < devCount) {
                devObj = [UserData Instance].deviceDic[devAscKeys[i]];
            }
            UIButton *bt = (UIButton *)[_scrollView viewWithTag:_DevFirstTag+i];
            
            if (bt) {       //找到DevBt，存放设备
                if (devObj) {//设备图标更换
                    bt.hidden = NO;
                    bt.enabled = YES;
                    ((UIImageView *)[bt viewWithTag:200]).hidden = NO;
                    if(devObj.avatar)
                    {
                       [bt setImage:[UIImage imageWithData:devObj.avatar] forState:UIControlStateNormal];
                    }else
                    {
                        j=(j==4)?0:j;
                        [bt setImage:[UIImage imageNamed:imgsName[j]] forState:UIControlStateNormal];
                    }
                    
                } else {
                    ((UIImageView *)[bt viewWithTag:200]).hidden = YES;
                    bt.hidden = YES;
                    continue;
                }
            } else {        //没有足够的DevBt存放多于DevBt的设备时
                bt = [UIButton buttonWithType:UIButtonTypeCustom];
                bt.frame = CGRectMake((_DevButtonWidth+10)*i+5, 0, _DevButtonWidth, _DevButtonWidth);
                bt.layer.cornerRadius = 5;
                bt.layer.masksToBounds = YES;
                bt.layer.borderColor = [UIColor whiteColor].CGColor;
                bt.layer.borderWidth = _Avatar_width;
                [bt addTarget:self action:@selector(onDeviceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                if(devObj.avatar)
                {
                    [bt setImage:[UIImage imageWithData:devObj.avatar] forState:UIControlStateNormal];
                }else
                {
                    j=(j==4)?0:j;
                    [bt setImage:[UIImage imageNamed:imgsName[j]] forState:UIControlStateNormal];
                }
                bt.tag = _DevFirstTag+i;
                [_scrollView addSubview:bt];
                
                int btWidth = bt.bounds.size.width;
                UIImageView *onlineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(btWidth-15, btWidth-15, 13.5, 13.5)];
                onlineImgView.image = [UIImage imageNamed:@"devices_offline"];
                onlineImgView.tag = 200;
                [bt addSubview:onlineImgView];
            }
            bt.layer.borderColor = [UIColor whiteColor].CGColor;
            if (bt.enabled) {
                bt.alpha = 0.5; //所有DevBt半透明
            }
        }
    }
    
    //选中常用按钮
    [self onDeviceButtonPressed:(UIButton *)[_scrollView viewWithTag:_DevFirstTag+selIndex]];
    [self refreshDevicesOnlineState];
}

- (IBAction)onDeviceButtonPressed:(UIButton *)bt {
    if (!devAscKeys.count) {
        return;
    }
    UIButton *lastDevButton = (UIButton *)[_scrollView viewWithTag:_DevFirstTag+selIndex];
    lastDevButton.alpha = 0.5;
    lastDevButton.layer.borderColor = [UIColor whiteColor].CGColor;
    selIndex = bt.tag-_DevFirstTag;//经常使用的设备在设备列表的位置号
    bt.alpha = 1;
    bt.layer.borderColor = [UIColor blackColor].CGColor; // 选中的设备为黑框啊
    
    //保存常用设备号
    if (devAscKeys.count > selIndex) {
        [UserData Instance].likeDevIMEI = devAscKeys[selIndex];
    }
    //滚动_scrollView
    if (selIndex > 2) {
        [UIView animateWithDuration:0.25 animations:^{
            
            _scrollView.contentOffset = CGPointMake((selIndex-2)*(_DevButtonWidth+10), 0);
            
        }];
    } else if (selIndex > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
    
    if (_didDevSelected != NULL) {
        self.didDevSelected();//设备已经选中的block
    }
}
- (IBAction)onArrowButtonPressed:(UIButton *)bt {
    if (bt.tag == _Left_ArrowTag) {             //向左箭头
        if (selIndex > 0) {
            [UIView animateWithDuration:0.25 animations:^{
                if (_scrollView.contentOffset.x/(_DevButtonWidth+10) == selIndex) {
                    _scrollView.contentOffset = CGPointMake((selIndex-1)*(_DevButtonWidth+10), 0);
                }
            }];
            [self onDeviceButtonPressed:((UIButton *)[_scrollView viewWithTag:selIndex+_DevFirstTag-1])];
        }
    } else if (bt.tag == _Right_ArrowTag) {     //向右箭头
        if (selIndex < devAscKeys.count-1) {
            [UIView animateWithDuration:0.25 animations:^{
                if (_scrollView.contentOffset.x/(_DevButtonWidth+10) == selIndex-3) {
                    _scrollView.contentOffset = CGPointMake((selIndex-2)*(_DevButtonWidth+10), 0);
                }
            }];
            [self onDeviceButtonPressed:((UIButton *)[_scrollView viewWithTag:selIndex+_DevFirstTag+1])];
        }
    }
}

//获取设备列表HTTP
-(void)sendGetDevListHTTPRequest {
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_my forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:_System_Language forKey:@"locale"];
    
//    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//    NSString *sign = [MD5 createSignWithDictionary:signInfo];
//    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
     NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.delegate = self;
    [req startAsynchronous];
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    _Code_HTTPResponseCheck(jsonDic, {
        NSLog(@"获取设备列表成功！");
        DLog(@"jsonDic = %@",jsonDic);
        NSMutableDictionary *newDeviceDic = [NSMutableDictionary dictionary];
        for (NSDictionary *devDic in jsonDic[@"list"]) {
            
            NSString *titleStr;
            if([devDic[@"eqTitle"] isKindOfClass:[NSNull class]]){
            
                titleStr = @"";
            }else{
            
                titleStr = devDic[@"eqTitle"];
            }
            
            NSString *PicStr;
            if([devDic[@"eqPic"] isKindOfClass:[NSNull class]]){
                
                PicStr = @"";
            }else{
                
                PicStr = devDic[@"eqPic"];
            }
           
            DeviceModel *devObj = [UserData Instance].deviceDic[devDic[@"eqId"]];//得到设备
            
            //设置设备参数
            if (!devObj) {
             
                devObj = [[DeviceModel alloc] initWithName:titleStr phone:devDic[@"eqPhone"] imei:devDic[@"eqId"] bleMac:devDic[@"eqBluetoothMAC"] withUrl:PicStr];
                
            }else{
            
                devObj.avatarUrl = devDic[@"eqPic"];
              //  NSString *url = devDic[@"eqPic"];
                
                if([NSData dataWithContentsOfURL:[NSURL URLWithString:PicStr]])
                {
                    devObj.avatar = [NSData dataWithContentsOfURL:[NSURL URLWithString:PicStr]];
                    
                } else {
                    
                    devObj.avatar = UIImagePNGRepresentation([UIImage imageNamed:@"icon_default_head_3"]);
                }
            }
            
             [newDeviceDic setValue:devObj forKey:devObj.bindIMEI];
            
        }
        //得到设备列表并且把它存到用户模型中
        [UserData Instance].deviceDic = newDeviceDic;
        [[UserData Instance] saveCustomObject:[UserData Instance]];
        
        [self getDevListFinishAndRefreshUI];// 获取设备列表并刷新UI
        
        if (_didRequestDevListFinish != NULL) {
            self.didRequestDevListFinish();
        }
    })
}

_Method_RequestFailed()

@end
