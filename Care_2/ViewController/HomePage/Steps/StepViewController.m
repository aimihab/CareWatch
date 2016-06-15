//
//  StepViewController.m
//  Care_2
//
//  Created by xiaobing on 15/5/24.
//  Copyright (c) 2015年 Joe. All rights reserved.
//
#import "DLLineChart.h"
#import "StepViewController.h"
#import "MNCustomCircleView.h"
#import "MNAdaptAlertView.h"
#import "MD5.h"
@interface StepViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MNCustomCircleView *circleView;
    
    IBOutlet UIView *cutomDataPickerView;

    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UIButton *surnBtn;
    __weak IBOutlet UIButton *cancleBtn;
    
    DLLineChart *chart;
    
    IBOutlet UITableView *_devList;
    NSArray *devAscKeys;
    UIButton *submitButton;

}

@property(nonatomic,strong)MNAdaptAlertView *CWSharePopViewForChinese;
@end

@implementation StepViewController

- (IBAction)cancleBtnClick:(id)sender {
    
    [self hiddePickView];
}
- (IBAction)sureBtnClick:(id)sender {
    
    [self hiddePickView];
}
- (IBAction)mangerCalories:(id)sender {
}
- (IBAction)share:(id)sender {
    //判断语言环境
    if (![MD5 isChina]){
    
        [self.CWSharePopViewForChinese show];
    }
    
    
}
- (IBAction)bottomBtnClick:(id)sender {
    
    if (cutomDataPickerView.hidden)
    {
    
        [UIView animateWithDuration:0.5 animations:^{
            
            cutomDataPickerView.alpha = 1.0;
            cutomDataPickerView.hidden = NO;
            
        }];
        
    }else
    {
        [self hiddePickView];
        
    }

}
- (void)hiddePickView{
    
    [UIView animateWithDuration:0.6 animations:^{
        cutomDataPickerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        cutomDataPickerView.hidden = YES;
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"记步", nil);
    [self setBackButton];
    [self setSubmitButton];
   
    [self setChartUI];
    circleView = [[MNCustomCircleView alloc] initWithFrame:CGRectMake(56, 10, 202, 202)];
    [self.view addSubview:circleView];
   // circleView.textLabel.text = @"步数";
   // circleView.msgLabel.text = @"8000";
   // circleView.percentLabel.text = @"80";
    circleView.isStep = YES;
    [circleView setPercent:80 animated:NO];
    
    cutomDataPickerView.frame = CGRectMake(10,HEIGHT(self.view)-200, WIDTH(self.view)-20, 200);
    cutomDataPickerView.hidden = YES;
    
    cutomDataPickerView.alpha = 0;
    [self.view addSubview:cutomDataPickerView];
    
    
    surnBtn.layer.cornerRadius = 5.0;
    surnBtn.clipsToBounds = YES;
    
    cancleBtn.layer.cornerRadius = 5.0;
    cancleBtn.clipsToBounds = YES;
    
    datePicker.date = [NSDate dateWithTimeInterval:-
                       60*60*24 sinceDate:[NSDate date]];
    
    //选择设备TableView
    {
        int devCount = [UserData Instance].deviceDic.count;
        if (devCount > 4) {
            _devList.frame = CGRectMake(320-100, -4*40, 100, 4*40);
        } else {
            _devList.frame = CGRectMake(320-100, -devCount*40, 100, devCount*40);
        }
        UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:_devList.bounds];
        backgroundImgView.image = [UIImage imageNamed:@"03_around_dropDownList"];
        _devList.backgroundView = backgroundImgView;
        _devList.layer.borderWidth = 1;
        _devList.layer.borderColor = _Color_font1.CGColor;
        [self.view addSubview:_devList];
        
        devAscKeys = [UserData Instance].deviceDic.allKeys;
    }
    if ([UserData Instance].deviceDic.count) {
        //设备排序
        NSArray *keyArr = [[UserData Instance].deviceDic allKeys];
        devAscKeys = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
            return result==NSOrderedDescending;
        }];
    }
    
}

 - (void)setChartUI
 {
     if (chart )
     {
         [chart removeFromSuperview];
         chart = nil;
     }
    
     chart = [[DLLineChart alloc] initWithFrame:CGRectMake(20,HEIGHT(self.view)-160,WIDTH(self.view)-40,150)];
     chart.backgroundColor = [UIColor clearColor];
      chart.isStep = YES;
     [self.view addSubview:chart];
     
     NSArray *xArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
     //y轴文字
     NSArray *yArray = @[@"1000",@"2000",@"3000",@"4000",@"5000",@"6000"];
     
     NSArray *dataArray = @[@"1000",@"2000",@"3000",@"2500",@"5000",@"6000",@"5300"];
     NSArray *dataArray1 = @[@"1",@"3000",@"2000",@"3500",@"3000",@"4000",@"5000",@"3000",@"2000",@"10"];
     
     [self setXcoordinate:xArray Ycoordinate:yArray andData1:dataArray Data2:dataArray1];

    
 }


#pragma - mark 设置折线图参数
-(void)setXcoordinate:(NSArray*)xCoordinateArray Ycoordinate:(NSArray*)yCoordinateArray andData1:(NSArray*)data Data2:(NSArray*)data1
{
    chart.xCoordinateLabelValues = xCoordinateArray;
    //y轴文字
    chart.yCoordinateLabelValues = yCoordinateArray;
    
    
    
    //折线2
    [chart addLDLineChartWithDatas:data1 strokeColor:[UIColor colorWithRed:112/255.0 green:156/255.0 blue:190/255.0 alpha:1.0]];
    
    
    
}

_Method_SetBackButton(nil, NO);
-(void)setSubmitButton {
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 2, 44, 44);
    if (self.selDev.avatar) {
        [submitButton setImage:[UIImage imageWithData:self.selDev.avatar] forState:UIControlStateNormal];
    } else {
        [submitButton setImage:[UIImage imageNamed:@"icon_default_head_1"] forState:UIControlStateNormal];
    }
    [submitButton addTarget:self action:@selector(onSubmitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    submitButton.imageEdgeInsets = (UIEdgeInsets){0,16,0,-16};
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
}
-(void)onSubmitButtonClick {
    submitButton.selected = !submitButton.selected;
    [UIView animateWithDuration:0.15 animations:^{
        if (submitButton.selected) {
            _devList.center = CGPointMake(320-_devList.bounds.size.width/2, _devList.bounds.size.height/2-1);
        } else {
            _devList.center = CGPointMake(320-_devList.bounds.size.width/2, -(_devList.bounds.size.height/2));
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [UserData Instance].deviceDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
        imgView.tag = 100;
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100-45, 40)];
        lb.font = [UIFont systemFontOfSize:10];
        lb.textColor = _Color_font2;
        lb.lineBreakMode = NSLineBreakByCharWrapping;
        lb.tag = 101;
        
        [cell addSubview:imgView];
        [cell addSubview:lb];
        
    }
    DeviceModel *dev = [UserData Instance].deviceDic[devAscKeys[indexPath.row]];
    ((UIImageView *)[cell viewWithTag:100]).image =[UIImage imageWithData:dev.avatar];
    ((UILabel *)[cell viewWithTag:101]).text =dev.nickName;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _devList) {
        self.selDev = [UserData Instance].deviceDic[devAscKeys[indexPath.row]];
        [submitButton setImage:[UIImage imageWithData:self.selDev.avatar] forState:UIControlStateNormal];
        
        [tableView reloadData];
        
        [self onSubmitButtonClick];
    } }



@end
