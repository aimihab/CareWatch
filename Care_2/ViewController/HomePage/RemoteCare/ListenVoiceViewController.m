//
//  ListenVoiceViewController.m
//  Care_2
//
//  Created by xiaobing on 15/5/12.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ListenVoiceViewController.h"
#import "DLLineChart.h"
#import "ASIHTTPRequest.h"
#import "UserData.h"
#import "AppDelegate.h"
@interface ListenVoiceViewController ()<ASIHTTPRequestDelegate>
{
     DLLineChart*dLchart;
    NSArray *xArray;
    NSArray *yArray;
    __weak IBOutlet UIImageView *vioceImage;
    NSTimer *timer;
    ASIHTTPRequest *req;
    NSString *isListen;
    
    UIWebView *phoneView;
}
@property (nonatomic,strong)NSMutableArray *arr;

@end

@implementation ListenVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"声音监听", nil);
    [self setBackButton];
    //[self setRightButton];
    [self setLineChart];
    isListen = @"1";
    
    [self sendRequestData];
    
    
}

- (UIWebView *)phoneView
{
    if (phoneView == nil) {
        phoneView = [[UIWebView alloc]initWithFrame:CGRectZero];
    }
    return phoneView;
}

-(void)sendRequestData{
    
    DeviceModel *dev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
    
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_user_monitor forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:_System_Language forKey:@"locale"];
    [signInfo setValue: dev.bindIMEI forKey:@"eqId"];
    [signInfo setValue: isListen forKey:@"listentime"];
    
//    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//    NSString *sign = [MD5 createSignWithDictionary:signInfo];
//    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    if ([isListen isEqualToString:@"1"]){
         req.tag = 71;
    }else{
        req.tag = 70;
    }
   
    req.delegate = self;
    [req startAsynchronous];
    _Code_ShowLoading
}


-(void)viewWillAppear:(BOOL)animated{

    isListen = @"1";
   // [self sendRequestData];

}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    if (request.tag == 71){
        
        phoneView = [[UIWebView alloc] initWithFrame:self.view.frame];
     //   [phoneView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"15219494801"]]]];
        [phoneView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",__APP.eqPhoneNum]]]];
    }else{}
   
    _Code_HTTPResponseCheck(jsonDic, {
        
        if (request.tag == 71)
        {
            
        }else{
        
        
        }
        NSLog(@"开始监听或者断开监听");
        NSLog(@"jsonDic=%@",jsonDic);
        
    })
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [timer invalidate];
    timer = nil;

}

- (void)viewWillDisappear:(BOOL)animated{

    [timer invalidate];
    
    timer = nil;
    

}

- (void)setLineChart
{
    if (dLchart){
        
        [dLchart removeFromSuperview];
        
        dLchart = nil;
        
    }
    dLchart = [[DLLineChart alloc] initWithFrame:CGRectMake(0,CGRectGetMidX(vioceImage.frame)-100,self.view.frame.size.width, 200)];
   
    NSLog(@"self.view.fram= %@",NSStringFromCGRect(vioceImage.frame)) ;
    dLchart.backgroundColor = [UIColor clearColor];
    [self.view addSubview:dLchart];
    xArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
    //y轴文字
    yArray = @[@"1000",@"2000",@"3000",@"4000",@"5000",@"6000"];
    [self refeshDataForchart];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refeshDataForchart) userInfo:nil repeats:YES];
    
}

#pragma - mark 定时刷新数据
-(void)refeshDataForchart
{
    if (dLchart){
        
        [dLchart removeFromSuperview];
        
        dLchart = nil;
        
    }
    dLchart = [[DLLineChart alloc] initWithFrame:CGRectMake(0,CGRectGetMidX(vioceImage.frame)-100,self.view.frame.size.width, 200)];
    dLchart.backgroundColor = [UIColor clearColor];
    [self.view addSubview:dLchart];
    NSString *data1 = [NSString stringWithFormat:@"%d",arc4random()%4000+2000];
     NSString *data2 = [NSString stringWithFormat:@"%d",2000-arc4random()%4000];
    NSString *data3 = [NSString stringWithFormat:@"%d",2000-arc4random()%1000];
    NSArray *dataArray = @[@"1000",@"1000",@"1000",data1,data2,data3,data1,data3,data1,@"1000",@"1000",@"1000"];
    
    [self setXcoordinate:xArray Ycoordinate:yArray andData1:dataArray];


}

#pragma - mark 设置折线图参数
-(void)setXcoordinate:(NSArray*)xCoordinateArray Ycoordinate:(NSArray*)yCoordinateArray andData1:(NSArray*)data
{
    dLchart.xCoordinateLabelValues = xCoordinateArray;
    //y轴文字
    dLchart.yCoordinateLabelValues = yCoordinateArray;
    
    //折线1
    [dLchart addLDLineChartWithDatas:data strokeColor:[UIColor colorWithRed:226/255.0 green:177/255.0 blue:100/255.0 alpha:1.0]];
    
 
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
//   
//    
//    submitButton.imageEdgeInsets = (UIEdgeInsets){0,16,0,-16};
//    
//    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(18, -10, 40, 45)];
//    lb.text = stringWidth;
//    lb.textAlignment = NSTextAlignmentCenter;
//    lb.font = [UIFont boldSystemFontOfSize:14];
//    lb.textColor = _Color_font1;
//    [submitButton addSubview:lb];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
//}

_Method_SetBackButton(nil, NO);
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
