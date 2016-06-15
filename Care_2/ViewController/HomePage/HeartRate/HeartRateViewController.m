//
//  HeartRateViewController.m
//  Care_2
//
//  Created by xiaobing on 15/5/14.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "HeartRateViewController.h"
#import "MNCustomCircleView.h"
@interface HeartRateViewController ()<UIScrollViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

    __weak IBOutlet UIImageView *circleImage;

   
    //建议文本内容
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UITextView *infoLabel;

    //底部的视图
    
    __weak IBOutlet UIButton *bottonBtn;
    
    MNCustomCircleView *circleView;
    
    __weak IBOutlet UIView *pickerView;
    __weak IBOutlet UIDatePicker *dataPicker;
    __weak IBOutlet UIButton *sureBtn;
    __weak IBOutlet UIButton *cancleBtn;
    
    UIButton * submitButton;
    IBOutlet UITableView *_devList;
     NSArray *devAscKeys;
    NSMutableArray *addbtnTimeArray;//添加时间时间的数组
    
}

/**
 *  底部按钮点击事件
 */
- (IBAction)sureBtnClick:(id)sender;
- (IBAction)cancleBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrView;
- (IBAction)bottomBtnClick:(id)sender;
@end

@implementation HeartRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    [self setSubmitButton];
    self.title = NSLocalizedString(@"心率", nil);
    titleLabel.text = NSLocalizedString(@"建议:",nil);
    infoLabel.text = NSLocalizedString(@"              在此分区中保持交替剧烈运动和非剧烈运动可长一些，每次运动保持在30分钟到60分钟以上（包括日常活动以及打球或者游泳等爱好或者娱乐），通过长期持续的运动习惯，达到改善心血管功能，身体灵活性，身体其他素质，有限有效减肥的效果。",nil);
    infoLabel.delegate = self;
    
    [self initCircleUI];
    [self creatBottomScrollView];
    
    pickerView.frame = CGRectMake(10,HEIGHT(self.view)-240, WIDTH(self.view)-20, 200);
    pickerView.hidden = YES;
    pickerView.alpha = 0;
    dataPicker.date = [NSDate dateWithTimeInterval:-
                       60*60*24 sinceDate:[NSDate date]];
    [self.view addSubview:pickerView];
  
    
    sureBtn.layer.cornerRadius = 5.0;
    sureBtn.clipsToBounds = YES;
    
    cancleBtn.layer.cornerRadius = 5.0;
    cancleBtn.clipsToBounds = YES;
    
    
#if 0
    // 心率数据更新
    [[SocketClient Instance] setDidDevHeartrateChange:^(DeviceModel *dev){
        [self refreshHeartLabel:dev];
    }];
    //   开启Socket
    [[SocketClient Instance] connectToHost];
    
#endif
    
    
    
    
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
    addbtnTimeArray = [NSMutableArray array];
}

- (void)creatBottomScrollView{
    _bottomScrView.delegate = self;
    NSInteger labelWidth = (_bottomScrView.frame.size.width)/6;

    _bottomScrView.contentSize = CGSizeMake(_bottomScrView.frame.size.width+labelWidth*2, 0);
  
   
       for (int i = 0; i < 8; i++) {
      //  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2+ labelWidth * i,0, labelWidth, CGRectGetHeight(_bottomScrView.frame))];
        
           UIButton *timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(2+ labelWidth * i,0, labelWidth, CGRectGetHeight(_bottomScrView.frame))];

        timeBtn.userInteractionEnabled = YES;
        timeBtn.backgroundColor = [UIColor clearColor];
        timeBtn.tag = 70 + i;
        timeBtn.font = [UIFont systemFontOfSize:10];
           [timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [timeBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
       
       
        if (i == 0){
            [timeBtn setTitle:[NSString stringWithFormat:@"%02d:00",0] forState:UIControlStateNormal];
        
        }else
        {
            [timeBtn setTitle:[NSString stringWithFormat:@"%02d:00",i*3]forState:UIControlStateNormal];
        }
        [_bottomScrView addSubview:timeBtn];
           
           [timeBtn addTarget:self action:@selector(touchScrollView:) forControlEvents:UIControlEventTouchUpInside];
        
    }

}

#pragma - mark 手势点击
- (void)touchScrollView:(UIButton *)gesture
{
    
    
//    for (int i = 0; i < 8; i++) {
//        
//         UIButton *tapLabelBtn =(UIButton *)[self.view viewWithTag:70+i];
//        [tapLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//    }
//    UILabel *tapLabel =(UILabel *)[_bottomScrView viewWithTag:gesture.view.tag];
//    tapLabel.textColor = [UIColor redColor];
      UIButton *tapLabelBtn =(UIButton *)[_bottomScrView viewWithTag:gesture.tag];
    if (addbtnTimeArray.count <2){
      
        tapLabelBtn.selected = YES;

        [addbtnTimeArray addObject:[NSNumber numberWithInteger:tapLabelBtn.tag]];

    }else{
        
    UIButton * btn = (UIButton *)[_bottomScrView viewWithTag:[addbtnTimeArray[0] integerValue]];
        [addbtnTimeArray removeObjectAtIndex:0];

        btn.selected = NO;
        [addbtnTimeArray addObject:[NSNumber numberWithInteger:tapLabelBtn.tag]];
        tapLabelBtn.selected = YES;
    }
   
}


_Method_SetBackButton(nil, NO)

- (void)initCircleUI{

    circleView = [[MNCustomCircleView alloc] initWithFrame:CGRectMake(56, 50, 202, 202)];
    [self.view addSubview:circleView];
    [circleView setPercent:80 animated:YES];

    
    /**
     *  创建圆环上的标题
     *  日常,警告Label
     */
    UILabel *warningLable = [[UILabel alloc] initWithFrame:CGRectMake(90,50, 50, 30)];
    warningLable.text = NSLocalizedString(@"警告", nil);
    warningLable.textColor = _Heartrate_font;
    warningLable.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:warningLable];
    warningLable.transform = CGAffineTransformIdentity;
    warningLable.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIANS(-35));

    UILabel *dailyLable = [[UILabel alloc] initWithFrame:CGRectMake(200,60, 50, 30)];
    dailyLable.text = NSLocalizedString(@"日常", nil);
    dailyLable.textColor = _Heartrate_font;
    dailyLable.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:dailyLable];
    dailyLable.transform = CGAffineTransformIdentity;
    dailyLable.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIANS(35));
    /**
     
     无氧运动Label
     */
    UILabel *anaerobicSportLable = [[UILabel alloc] initWithFrame:CGRectMake(54,135,100,15)];
    anaerobicSportLable.text = NSLocalizedString(@"无", nil) ;
    anaerobicSportLable.textColor = _Heartrate_font;
    anaerobicSportLable.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:anaerobicSportLable];
    anaerobicSportLable.transform = CGAffineTransformIdentity;
    anaerobicSportLable.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIANS(-10));
    
    UILabel *anaerobicSportLable1 = [[UILabel alloc] initWithFrame:CGRectMake(57,150,100,15)];
    anaerobicSportLable1.text = NSLocalizedString(@"氧", nil) ;
    anaerobicSportLable1.textColor = _Heartrate_font;
    anaerobicSportLable1.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:anaerobicSportLable1];
    anaerobicSportLable1.transform = CGAffineTransformIdentity;
    anaerobicSportLable1.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIANS(-10));

    UILabel *anaerobicSportLable2 = [[UILabel alloc] initWithFrame:CGRectMake(60,165,100,15)];
    anaerobicSportLable2.text = NSLocalizedString(@"运", nil) ;
    anaerobicSportLable2.textColor = _Heartrate_font;
    anaerobicSportLable2.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:anaerobicSportLable2];
    anaerobicSportLable2.transform = CGAffineTransformIdentity;
    anaerobicSportLable2.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIANS(-10));

    UILabel *anaerobicSportLable3 = [[UILabel alloc] initWithFrame:CGRectMake(64,180,100,15)];
    anaerobicSportLable3.text = NSLocalizedString(@"动", nil) ;
    anaerobicSportLable3.textColor = _Heartrate_font;
    anaerobicSportLable3.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:anaerobicSportLable3];
    anaerobicSportLable3.transform = CGAffineTransformIdentity;
    anaerobicSportLable3.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIANS(-10));

    
    /**
     
     脂肪燃烧Label
     */
    
    UILabel *fatBurnLable = [[UILabel alloc] initWithFrame:CGRectMake(254,143,100, 15)];
    fatBurnLable.text = NSLocalizedString(@"脂", nil) ;
    fatBurnLable.textColor = _Heartrate_font;
    fatBurnLable.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:fatBurnLable];
    fatBurnLable.transform = CGAffineTransformIdentity;
    fatBurnLable.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIANS(7));
    
    UILabel *fatBurnLable1 = [[UILabel alloc] initWithFrame:CGRectMake(251,158,100, 15)];
    fatBurnLable1.text = NSLocalizedString(@"肪", nil) ;
    fatBurnLable1.textColor = _Heartrate_font;
    fatBurnLable1.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:fatBurnLable1];
    fatBurnLable1.transform = CGAffineTransformIdentity;
    fatBurnLable1.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIANS(7));

    UILabel *fatBurnLable2 = [[UILabel alloc] initWithFrame:CGRectMake(249,173,100, 15)];
    fatBurnLable2.text = NSLocalizedString(@"燃", nil) ;
    fatBurnLable2.textColor = _Heartrate_font;
    fatBurnLable2.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:fatBurnLable2];
    fatBurnLable2.transform = CGAffineTransformIdentity;
    fatBurnLable2.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIANS(7));

    UILabel *fatBurnLable3 = [[UILabel alloc] initWithFrame:CGRectMake(245,188,100, 15)];
    fatBurnLable3.text = NSLocalizedString(@"烧", nil) ;
    fatBurnLable3.textColor = _Heartrate_font;
    fatBurnLable3.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:fatBurnLable3];
    fatBurnLable3.transform = CGAffineTransformIdentity;
    fatBurnLable3.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIANS(7));

    /**
     有氧运动Label
     */
    UILabel *aerobicSportLable = [[UILabel alloc] initWithFrame:CGRectMake(133,233,100, 30)];
    aerobicSportLable.text = NSLocalizedString(@"有氧运动", nil) ;
    aerobicSportLable.textColor = _Heartrate_font;
    aerobicSportLable.font = [UIFont boldSystemFontOfSize:14.0];
    [self.view addSubview:aerobicSportLable];
    
    
  }


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



#pragma - mark UIscrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView==infoLabel) {
        
        titleLabel.hidden = YES;
        
    }
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if (scrollView.contentOffset.y == 0.0&&scrollView == infoLabel)
    {
        titleLabel.hidden = NO;
    }


}
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

- (IBAction)bottomBtnClick:(id)sender {
    
    if (pickerView.hidden)
    {
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            pickerView.alpha = 1.0;
            pickerView.hidden = NO;
           
        }];
        
        
        }else
    {
        [self hiddePickView];
    
    }
    
}

- (void)hiddePickView{
    
    [UIView animateWithDuration:0.6 animations:^{
        pickerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        pickerView.hidden = YES;
    }];
    
    
}

- (IBAction)sureBtnClick:(id)sender {
    
    [self hiddePickView];
    //取出选中的时间，取数据库里面查询心率数据，然后刷新圆环数据
    
    
}

- (IBAction)cancleBtnClick:(id)sender {
    
    [self hiddePickView];
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
