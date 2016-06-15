//
//  SetClockDetailViewController.m
//  Care_2
//
//  Created by xiaobing on 15/5/13.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "SetClockDetailViewController.h"
#import "CustomPickerView.h"
#import "CustomPickerView.h"
#import "ASIHTTPRequest.h"
#import "NSDate+Expend.h"
#import "ErrorAlerView.h"
#import "SBJson.h"
@interface SetClockDetailViewController ()<ASIHTTPRequestDelegate>
{
    __weak IBOutlet UIView *timeBackView;
   
    CustomPickerView *hourPickerView;
    CustomPickerView *minPickerView;
    CustomPickerView *halfDay;
    NSMutableArray *dataArr;

  
    
    __weak IBOutlet UILabel *weekTitleLabel;
    
    __weak IBOutlet UIButton *mondayBtn;
    __weak IBOutlet UIButton *tuesdayBtn;
    __weak IBOutlet UIButton *WednesdayBtn;
    __weak IBOutlet UIButton *thurdayBtn;
    __weak IBOutlet UIButton *fridayBtn;
    __weak IBOutlet UIButton *SaturdayBtn;
    __weak IBOutlet UIButton *sundayBtn;
    __weak IBOutlet UIButton *neverBtn;
    __weak IBOutlet UIButton *saveBtn;
    
    NSMutableArray *addSelectedTimeArray;
    ASIHTTPRequest *req;
    ASIHTTPRequest *req1;
    
  
    
}
- (IBAction)weekBtnClick:(UIButton *)sender;
- (IBAction)saveBtnClick:(id)sender;

@end

@implementation SetClockDetailViewController

- (void)dealloc
{
    [req clearDelegatesAndCancel];
    [req1 clearDelegatesAndCancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设定闹钟", nil);
    [self LocalizeAllBtnTitle];
    [self setBackButton];
    
    addSelectedTimeArray = [NSMutableArray array];
    [addSelectedTimeArray addObjectsFromArray:self.selDev.repeatDate];

    [self careatTimePickerView];
}

- (void)viewWillAppear:(BOOL)animated{

   
    if (_selDev.repeatDate.count >0) {
               
        for (NSString *obj in addSelectedTimeArray) {
            switch (obj.intValue) {
                case 7:
                    sundayBtn.selected = YES;
                    break;
                case 1:
                    mondayBtn.selected = YES;
                    break;
                case 2:
                    tuesdayBtn.selected = YES;
                    break;
                case 3:
                    WednesdayBtn.selected = YES;
                    break;
                case 4:
                    thurdayBtn.selected = YES;
                    break;
                case 5:
                    fridayBtn.selected = YES;
                    break;
                case 6:
                    SaturdayBtn.selected = YES;
                    break;
                default:
                    
                    break;
            }
            
        }

    }else{
    

        
        [self.view.subviews enumerateObjectsUsingBlock:^(UIButton *obj,NSUInteger idx,BOOL *stop){
            
            UIButton *btn = (UIButton *)[self.view viewWithTag:50+idx];
            btn.selected = NO;
        }];
        
    }

       if (![_selDev.clockTime isEqualToString:@""]){
        
        hourPickerView.value = [_selDev.clockTime substringToIndex:2];
        minPickerView.value = [_selDev.clockTime substringFromIndex:3];
        
       }else{
           
           hourPickerView.value = [NSString stringWithFormat:@"%02d",[NSDate getCurrentHour]];
           minPickerView.value = [NSString stringWithFormat:@"%02d",[NSDate getCurrentMin]];

       }
    
    
    if (_selDev.repeatDate.count == 0 && ![_selDev.clockTime isEqualToString:@""]) {
        neverBtn.selected = YES;
    }

    
}

- (void) LocalizeAllBtnTitle
{
    [mondayBtn setTitle:NSLocalizedString(@"一",nil) forState:UIControlStateNormal];
    [tuesdayBtn setTitle:NSLocalizedString(@"二",nil) forState:UIControlStateNormal];
    [WednesdayBtn setTitle:NSLocalizedString(@"三",nil) forState:UIControlStateNormal];
    [thurdayBtn setTitle:NSLocalizedString(@"四",nil) forState:UIControlStateNormal];
    [fridayBtn setTitle:NSLocalizedString(@"五",nil) forState:UIControlStateNormal];
    [SaturdayBtn setTitle:NSLocalizedString(@"六",nil) forState:UIControlStateNormal];
    [sundayBtn setTitle:NSLocalizedString(@"日",nil) forState:UIControlStateNormal];
    [neverBtn setTitle:NSLocalizedString(@"永不",nil) forState:UIControlStateNormal];
    weekTitleLabel.text = NSLocalizedString(@"选择重复周期", nil);
    
}

#pragma - mark 永不按钮的请求
- (void)sendRequestDeleteData{
    
    NSString *nowTimeString = [NSString stringWithFormat:@"%02ld:%02ld",(long)hourPickerView.value.integerValue,(long)minPickerView.value.integerValue];
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_updateclock forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:_System_Language forKey:@"locale"];
    [signInfo setValue:self.selDev.bindIMEI forKey:@"eqId"];
    [signInfo setObject:@""forKey:@"repeatdate"];
    [signInfo setObject:nowTimeString forKey:@"time"];
    
    
//    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//    NSString *sign = [MD5 createSignWithDictionary:signInfo];
//    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    
    req1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req1 addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req1.tag = 50;
    req1.delegate = self;
    [req1 startAsynchronous];
    //   _Code_ShowLoading
    
}

#pragma mark - 创建时间选择器

-(void)careatTimePickerView{
    NSMutableArray *hourArr = [NSMutableArray array];
    for (int i =0; i<24; i++) {
        if (i<10) {
            [hourArr addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [hourArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
    }
    hourPickerView = [[CustomPickerView alloc]initWithFrame:CGRectMake(50, 0,(timeBackView.frame.size.width-100)/2,timeBackView.frame.size.height) andDataArr:hourArr];
    [timeBackView addSubview:hourPickerView];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hour"]){
        
        hourPickerView.value = [[NSUserDefaults standardUserDefaults]objectForKey:@"hour"];
    }else
    {
        hourPickerView.value = [NSString stringWithFormat:@"%02d",[NSDate getCurrentHour]];
    }
    NSMutableArray *minArr = [NSMutableArray array];
    for (int i = 0; i<60; i++) {
        if (i<10) {
            [minArr addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [minArr addObject:[NSString stringWithFormat:@"%2d",i]];
        }
        
    }
    minPickerView = [[CustomPickerView alloc]initWithFrame:CGRectMake(timeBackView.frame.size.width/2, 0, (timeBackView.frame.size.width-100)/2,timeBackView.frame.size.height) andDataArr:minArr];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"min"]){
        
        minPickerView.value = [[NSUserDefaults standardUserDefaults]objectForKey:@"min"];
    }else
    {
        minPickerView.value = [NSString stringWithFormat:@"%02d",[NSDate getCurrentMin]];
    }
      [timeBackView addSubview:minPickerView];
    //创建4根横线
    
     UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 73, 45,2)];
    lineLabel.backgroundColor = [UIColor colorWithRed:248/255.0 green:142/255.0 blue:59/255.0 alpha:1.0];
    [timeBackView addSubview:lineLabel];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 110, 45,2)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:248/255.0 green:142/255.0 blue:59/255.0 alpha:1.0];
    [timeBackView addSubview:lineLabel1];
    
    UILabel *lineLabe2 = [[UILabel alloc] initWithFrame:CGRectMake(157, 73, 45,2)];
    lineLabe2.backgroundColor = [UIColor colorWithRed:248/255.0 green:142/255.0 blue:59/255.0 alpha:1.0];
    [timeBackView addSubview:lineLabe2];
    
    UILabel *lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(157, 110, 45,2)];
    lineLabel3.backgroundColor = [UIColor colorWithRed:248/255.0 green:142/255.0 blue:59/255.0 alpha:1.0];
    [timeBackView addSubview:lineLabel3];
    
    
    }

//-(void)setRightButton {
//    
//    
//    NSString *stringWidth = [UserData Instance].nickName;
//    // CGFloat strW = _StringWidth(stringWidth);
//    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    submitButton.frame = CGRectMake(0, 2, 44, 44);
//    [submitButton setImage:[UIImage imageNamed:@"nav_btn_drop-down"] forState:UIControlStateNormal];
//    [submitButton setImage:[UIImage imageNamed:@"nav_btn_drop-down-_pre"] forState:UIControlStateHighlighted];
//   // [submitButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    submitButton.imageEdgeInsets = (UIEdgeInsets){0,16,0,-16};
//    
//    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(18, -10, 40, 45)];
//    lb.text = stringWidth;
//    lb.textAlignment = NSTextAlignmentCenter;
//    lb.font = [UIFont boldSystemFontOfSize:14];
//    lb.textColor = _Color_font1;
//    [submitButton addSubview:lb];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
//}

_Method_SetBackButton(nil, NO)




- (IBAction)weekBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 50:
        {
            sundayBtn.selected = !sundayBtn.selected;
             neverBtn.selected = NO;
            if (sundayBtn.selected){
                [addSelectedTimeArray addObject:@"7"];
            }else{
                
                [addSelectedTimeArray removeObject:@"7"];
            }
            
        }
            break;
        case 51:
            NSLog(@"1");
        {
            mondayBtn.selected = !mondayBtn.selected;
            neverBtn.selected = NO;
            if (mondayBtn.selected){
                [addSelectedTimeArray addObject:@"1"];
            }else{
                
                [addSelectedTimeArray removeObject:@"1"];
            }

        }
            break;
        case 52:
            NSLog(@"2");
        {
            tuesdayBtn.selected = !tuesdayBtn.selected;
            neverBtn.selected = NO;
            if (tuesdayBtn.selected){
                [addSelectedTimeArray addObject:@"2"];
            }else{
                
                [addSelectedTimeArray removeObject:@"2"];
            }

        }
            
            break;
        case 53:
            NSLog(@"3");
        {
            WednesdayBtn.selected = !WednesdayBtn.selected;
            neverBtn.selected = NO;
            if (WednesdayBtn.selected){
                [addSelectedTimeArray addObject:@"3"];
            }else{
                
                [addSelectedTimeArray removeObject:@"3"];
            }

        }
            break;
        case 54:
            NSLog(@"4");
        {
            thurdayBtn.selected = !thurdayBtn.selected;
             neverBtn.selected = NO;
            if (thurdayBtn.selected){
                [addSelectedTimeArray addObject:@"4"];
            }else{
                
                [addSelectedTimeArray removeObject:@"4"];
            }

            
        }
            break;
        case 55:
            NSLog(@"5");
        {
            fridayBtn.selected = !fridayBtn.selected;
            neverBtn.selected = NO;
            if (fridayBtn.selected){
                [addSelectedTimeArray addObject:@"5"];
            }else{
                
                [addSelectedTimeArray removeObject:@"5"];
            }

            
        }
            break;
        case 56:
            NSLog(@"6");
        {
            SaturdayBtn.selected = !SaturdayBtn.selected;
             neverBtn.selected = NO;
            if (SaturdayBtn.selected){
                [addSelectedTimeArray addObject:@"6"];
            }else{
                
                [addSelectedTimeArray removeObject:@"6"];
            }

            
        }
            break;
            case 57:
            NSLog(@"永不");
        {
            neverBtn.selected = !neverBtn.selected;
            mondayBtn.selected = NO;
            tuesdayBtn.selected = NO;
            WednesdayBtn.selected = NO;
            fridayBtn.selected = NO;
            thurdayBtn.selected = NO;
            SaturdayBtn.selected = NO;
            sundayBtn.selected = NO;
            if (neverBtn.selected){
            
            //删除闹钟
                [self sendRequestDeleteData];
   
            
            }
        }
            break;
        default:
            break;
    }
    

    
}

#pragma - mark 设置闹钟
- (void)sendRequestData{

    
    NSString *nowTimeString = [NSString stringWithFormat:@"%02ld:%02ld",(long)hourPickerView.value.integerValue,(long)minPickerView.value.integerValue];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:hourPickerView.value forKey:@"hour"];
    [userDefault setValue:minPickerView.value forKey:@"min"];
    [userDefault synchronize];
    
        NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
        [signInfo setValue:_Interface_tracker_updateclock forKey:@"method"];
        [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
        [signInfo setValue:self.selDev.bindIMEI forKey:@"eqId"];
        [signInfo setValue:_System_Language forKey:@"locale"];
  //  NSString *addArrayString = [addSelectedTimeArray JSONRepresentation];
    
        DLog(@"-------arr is %@",addSelectedTimeArray);
        NSString *addArrayString = [addSelectedTimeArray componentsJoinedByString:@","];// 将数组中的元素拼接成字符串
        DLog(@".......addArraystring is %@",addArrayString);
        DLog(@"......nowTimeString is %@",nowTimeString);
    
        [signInfo setObject:addArrayString forKey:@"repeatdate"];
        [signInfo setObject:nowTimeString forKey:@"time"];
        [signInfo setValue: [NSNumber numberWithInt:self.selDev.modeType] forKey:@"scene"];
    
    
    
//        [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//        NSString *sign = [MD5 createSignWithDictionary:signInfo];
//        NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
 
        NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    
        req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
        req.delegate = self;
        [req startAsynchronous];
        _Code_ShowLoading


}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    NSString *devClock  = [NSString stringWithFormat:@"%02ld:%02ld",(long)hourPickerView.value.integerValue,(long)minPickerView.value.integerValue];
    
    NSLog(@"self.selDev.repeatDate = %@",self.selDev.repeatDate);
    NSLog(@"addSelectedTimeArray = %@",addSelectedTimeArray);
    
    _Code_HTTPResponseCheck(jsonDic, {
        
        if (request.tag == 50) {
            
            [self.selDev.repeatDate removeAllObjects];
            [addSelectedTimeArray removeAllObjects];
            
        }else
        {
            NSLog(@"jsonDic=%@",jsonDic);
            //发送设置闹钟的请求，请求结束保存，最后返回上个控制器
            if (addSelectedTimeArray.count >0){
                [self.selDev.repeatDate removeAllObjects];
                [self.selDev.repeatDate addObjectsFromArray:addSelectedTimeArray];
                
                NSLog(@"self.selDev.repeatDate = %@",self.selDev.repeatDate);
                self.selDev.clockTime = devClock;
                
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        
        [[UserData Instance]saveCustomObject:[UserData Instance]];
        
        
    })
        // 记录添加闹钟的记录
        NSString *reStr = [self getRepeatDateFromArray:addSelectedTimeArray];
        NSString *infoStr = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"设置闹钟提醒在", nil),reStr,devClock];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"date",
                             infoStr,@"location",
                             self.selDev,@"devL",nil];
        DLog(@"------%@",self.selDev);
    
        [self.selDev.remoteCare addObject:dic];
        
}

- (IBAction)saveBtnClick:(id)sender {
   
//    if (neverBtn.selected == NO && mondayBtn.selected==NO&&tuesdayBtn.selected == NO&&WednesdayBtn.selected==NO&&thurdayBtn.selected==NO&&fridayBtn.selected==NO&&SaturdayBtn.selected==NO&&sundayBtn.selected == NO) {
//        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请选择重复周期", nil)];
//        [alertView show];
//        return;
//    }
    //发送设置闹钟的请求，请求结束保存，最后返回上个控制器
    [self sendRequestData];
    
}


- (NSString *)getRepeatDateFromArray:(NSArray *)arr{

     NSString *repeatStr = @"";
    
    if (arr.count >0) {
        
        for (NSString *obj in _selDev.repeatDate) {
            switch (obj.intValue) {
                case 7:
                    repeatStr = [NSString stringWithFormat:@"%@ %@",repeatStr,NSLocalizedString(@"星期日", nil)];
                    break;
                case 1:
                    repeatStr = [NSString stringWithFormat:@"%@ %@",repeatStr,NSLocalizedString(@"星期一", nil)];
                    break;
                case 2:
                    repeatStr = [NSString stringWithFormat:@"%@ %@",repeatStr,NSLocalizedString(@"星期二", nil)];
                    break;
                case 3:
                    repeatStr = [NSString stringWithFormat:@"%@ %@",repeatStr,NSLocalizedString(@"星期三", nil)];
                    break;
                case 4:
                    repeatStr = [NSString stringWithFormat:@"%@ %@",repeatStr,NSLocalizedString(@"星期四", nil)];
                    break;
                case 5:
                    repeatStr = [NSString stringWithFormat:@"%@ %@",repeatStr,NSLocalizedString(@"星期五", nil)];
                    break;
                case 6:
                    repeatStr = [NSString stringWithFormat:@"%@ %@",repeatStr,NSLocalizedString(@"星期六", nil)];
                    break;
                default:
                    
                    break;
            }
            
        }
    
    }
    
    return repeatStr;

}


@end
