//
//  SetClockViewController.m
//  Care_2
//
//  Created by xiaobing on 15/5/12.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "SetClockViewController.h"
#import "SetClockDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "ErrorAlerView.h"
#import "MD5.h"
#import "NSDate+Expend.h"
@interface SetClockViewController ()
{
    
    __weak IBOutlet UIImageView *headImageView;

    __weak IBOutlet UIButton *deleteBtn;

    __weak IBOutlet UILabel *deleteTitleLabel;
    
    __weak IBOutlet UILabel *countDownLabel; // 倒计时Label
    
    __weak IBOutlet UILabel *clockTimeLabel; // 闹钟时间
    __weak IBOutlet UILabel *repeatDateLabel;// 重复周期
    
    ASIHTTPRequest *req;
    ASIHTTPRequest *req1;
    
    NSTimer *distanceTimer; //到计时
    NSMutableArray *array1;
    NSMutableArray *addArray ;
    
     NSString *rightBtnTitle;
    
    IBOutlet UITableView *_devList;
    UIButton *submitButton;
  //  NSArray *devAscKeys;//设备的唯一标识
  //  UIButton *submitButton;//右按钮
}
- (IBAction)deleteBtnClick:(id)sender;
@end

@implementation SetClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"闹钟", nil);
    deleteTitleLabel.text = NSLocalizedString(@"删除闹钟", nil);
    
    NSString *time =  NSLocalizedString(@"距离闹钟时间还有:", nil);
    countDownLabel.text = [NSString stringWithFormat:@"%@ %@",time,@"7:07"];
    countDownLabel.hidden = YES;// 屏蔽倒计时功能
    
    [self setBackButton];
//    rightBtnTitle = NSLocalizedString(@"记录闹钟", nil);
    [self setSubmitButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    headImageView.userInteractionEnabled = YES;
    [headImageView addGestureRecognizer:tapGesture];
    
    array1 = [NSMutableArray array];
    addArray = [NSMutableArray array];
    
/*
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
*/
    
}

/*
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"[UserData Instance].deviceDic.count= %ld",[UserData Instance].deviceDic.count);
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
        [self distanceTime];
        
        [self onSubmitButtonClick];
    }
}


#pragma - mark 右按钮点击
-(void)onSubmitButtonClick {
    
    
    submitButton.selected = !submitButton.selected;
    NSLog(@"submitButton.selected = %d",  submitButton.selected);
    [UIView animateWithDuration:0.15 animations:^{
        if (submitButton.selected) {
            _devList.center = CGPointMake(320-_devList.bounds.size.width/2, _devList.bounds.size.height/2-1);
            
        } else {
            _devList.center = CGPointMake(320-_devList.bounds.size.width/2, -(_devList.bounds.size.height/2));
            
        }
    }];
}
*/

_Method_SetBackButton(nil, NO)
//_Method_SetSubmitButton(rightBtnTitle, (@selector(rightBtnClick)), _StringWidth(rightBtnTitle))

#if 0
-(void)rightBtnClick{
    DLog(@"记录闹钟....");
    if (![repeatDateLabel.text isEqualToString:@""] && ![clockTimeLabel.text isEqualToString:@""]) {
        
        NSString *infoStr = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"设置闹钟提醒在", nil),repeatDateLabel.text,clockTimeLabel.text];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"date",
                             infoStr,@"location",
                             self.selDev,@"devL",nil];
        DLog(@"------%@",self.selDev);
        DLog(@"%@",dic);
        
        [self.selDev.remoteCare addObject:dic];
        CustomIOS7AlertView *alerView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"记录成功", nil)];
        [alerView show];
    }else{
    
        CustomIOS7AlertView *alerView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"闹钟时间为空,无法记录", nil)];
        [alerView show];
    
    }
    
}
#endif

-(void)setSubmitButton {
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 2, 44, 44);
    if (self.selDev.avatar) {
        [submitButton setImage:[UIImage imageWithData:self.selDev.avatar] forState:UIControlStateNormal];
    } else {
        [submitButton setImage:[UIImage imageNamed:@"icon_default_head_1"] forState:UIControlStateNormal];
    }
//    [submitButton addTarget:self action:@selector(onSubmitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    submitButton.imageEdgeInsets = (UIEdgeInsets){0,16,0,-16};
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
}


- (void)refishTime
{
    [self distanceTime];

}

- (void)viewWillDisappear:(BOOL)animated
{

    [distanceTimer invalidate];
    distanceTimer = nil;

}
- (void)viewWillAppear:(BOOL)animated
{
    
    DLog(@"deleteBtn is %f",deleteBtn.frame.size
         .height);
     [self getClockDataRequest];// 请求获取闹钟
    
    //计算闹钟时间
//    [self distanceTime];
//    if (distanceTimer == nil){
//    
//        distanceTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(refishTime) userInfo:nil repeats:YES];
//
//    }
   
    countDownLabel.hidden = YES;
}
- (void)distanceTime
{
    //计算现在是星期几
    int weekDay = [NSDate getWeekdayFromDate:[NSDate date]]-1;
    if (weekDay == 0){
        weekDay = 7;
    }
    if (array1.count > 0){
        
        [array1 removeAllObjects];
    }
 //   countDownLabel.hidden = NO;
    
    if (self.selDev.repeatDate.count == 0)
    {
        countDownLabel.hidden = NO;
        countDownLabel.text = [NSString stringWithFormat:NSLocalizedString(@"设备没有设定闹钟", nil)];
        return;
    }
    
    
    [array1 addObjectsFromArray:self.selDev.repeatDate];
    
    
    if ([array1 containsObject:@"0"]){
        
        NSInteger index = [array1 indexOfObject:@"0"];
        [array1 replaceObjectAtIndex:index withObject:@"7"];
        
    }
    
    //    if ([array1 containsObject:@"7"]){
    //
    //        NSInteger index = [array1 indexOfObject:@"7"];
    //        [array1 replaceObjectAtIndex:index withObject:@"8"];
    //
    //    }
    
    
    
    NSArray * array = [array1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        return result==NSOrderedDescending;
    }];
    
    
    int hour = [NSDate getCurrentHour];
    int min = [NSDate getCurrentMin];
    
    
    if (![_selDev.clockTime isEqualToString:@""]) {
        NSString *setColckHour = [_selDev.clockTime substringToIndex:2];
        NSString *setColckMin = [_selDev.clockTime substringFromIndex:3];
        NSString *distanceTime = nil;
        
        //遍历数组找出最近时间
        for (NSString *obj in array) {
            if (obj.intValue == weekDay)//当天
            {
                
                //计算相差多少小时多少分钟
                if(setColckHour.intValue > hour)//设定小时大于当前小时
                {
                    if (setColckMin.intValue >= min) {
                        distanceTime = [NSString stringWithFormat:@"%d:%02d",setColckHour.intValue-hour,setColckMin.intValue -min];
                        break;
                    }else if (setColckMin.intValue < min)//设定分钟小于当前分钟
                    {
                        distanceTime = [NSString stringWithFormat:@"%d:%02d",setColckHour.intValue-hour-1,setColckMin.intValue + 60 -min];
                        break;
                    }
                    
                    
                }else if (setColckHour.integerValue == hour){//当天当小时
                    if (setColckMin.intValue >=min) {
                        
                        distanceTime = [NSString stringWithFormat:@"%d:%02d",0,setColckMin.intValue -min];
                        break;
                    }else if (setColckMin.intValue <min)
                    {
                        if(array.count == 1)
                        {
                            distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",6,23,setColckMin.intValue+60 -min];
                            break;
                        }
                        else if (array.count > 1)
                        {
                            //得到设置时间所在下标
                            if (obj != array[array.count-1])//不是最后一个元素
                            {
                                int index = [array indexOfObject:obj];
                                NSString *nextObj = array[index + 1];
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",[nextObj intValue]-weekDay-1,setColckHour.intValue +24-hour-1,setColckMin.intValue+60 -min];
                                break;
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }else if (setColckHour.integerValue < hour){//设定小时小于当前小时
                    
                    if (setColckMin.intValue >=min) {
                        
                        if (array.count == 1){
                            distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",6,setColckHour.intValue +24-hour,setColckMin.intValue -min];
                            break;
                        }else if (array.count >1)
                        {
                            if (obj != array[array.count-1])//不是最后一个元素
                            {
                                int index = [array indexOfObject:obj];
                                NSString *nextObj = array[index + 1];
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",[nextObj intValue]-weekDay-1,setColckHour.intValue +24-hour,setColckMin.intValue-min];
                                break;
                            }
                            
                            
                        }
                        
                    }else if (setColckMin.intValue <min)
                    {
                        if (array.count == 1){
                            
                            distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",6,setColckHour.intValue +24-hour-1,setColckMin.intValue+60 -min];
                            break;
                        }else if (array.count > 1)
                        {
                            //得到设置时间所在下标
                            if (obj != array[array.count-1])//不是最后一个元素
                            {
                                int index = [array indexOfObject:obj];
                                NSString *nextObj = array[index + 1];
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",[nextObj intValue]-weekDay-1,setColckHour.intValue +24-hour-1,setColckMin.intValue+60 -min];
                                break;
                            }
                            
                        }
                        
                    }
                    
                    
                    
                }
                
            }
            else//不是当天
            {
                if(obj.intValue - weekDay > 0)//设定闹钟的天 大于现在的天
                {
                    //距离的天
                    NSInteger dayTime = obj.intValue-weekDay;
                    
                    
                    if(setColckHour.intValue > hour)//设定小时大于当前小时已经ok
                    {
                        if (setColckMin.intValue >= min) {
                            distanceTime = [NSString stringWithFormat:@"%ld天%d:%02d",dayTime,setColckHour.intValue-hour,setColckMin.intValue -min];
                            break;
                        }else if (setColckMin.intValue < min)//设定分钟小于当前分钟
                            
                        {
                            distanceTime = [NSString stringWithFormat:@"%ld天%d:%02d",dayTime,setColckHour.intValue-hour-1,setColckMin.intValue + 60 -min];
                            break;
                        }
                        
                        
                    }else if (setColckHour.integerValue == hour){//设置闹钟的小时相等
                        
                        if (setColckMin.intValue >= min) {
                            distanceTime = [NSString stringWithFormat:@"%ld天%d:%02d",dayTime,setColckHour.intValue-hour,setColckMin.intValue -min];
                            break;
                        }else if (setColckMin.intValue < min)//设定分钟小于当前分钟
                        {
                            if (setColckHour.intValue - hour -1 >= 0){//不需要减一天
                                distanceTime = [NSString stringWithFormat:@"%ld天%d:%02d",dayTime,setColckHour.intValue-hour-1,setColckMin.intValue + 60 -min];
                            }else if (setColckHour.intValue - hour -1 < 0){//需要减一天
                                
                                distanceTime = [NSString stringWithFormat:@"%ld天%d:%02d",dayTime-1,setColckHour.intValue+24-hour-1,setColckMin.intValue + 60 -min];
                            }
                            
                            break;
                        }
                    }else if (setColckHour.integerValue < hour){//设置闹钟的小时小于当前小时
                        
                        
                        if (setColckMin.intValue >=min) {
                            
                            if (array.count == 1){
                                distanceTime = [NSString stringWithFormat:@"%ld天%d:%02d",dayTime-1,setColckHour.intValue +24-hour,setColckMin.intValue -min];
                                break;
                            }else if (array.count >1)
                            {
                                
                                
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",[obj intValue]-weekDay-1,setColckHour.intValue +24-hour,setColckMin.intValue-min];
                                break;
                                
                            }
                            
                        }else if (setColckMin.intValue <min)
                        {
                            if (array.count == 1){
                                
                                distanceTime = [NSString stringWithFormat:@"%ld天%d:%02d",dayTime-1,setColckHour.intValue +24-hour-1,setColckMin.intValue+60 -min];
                                break;
                            }else if (array.count > 1)
                            {
                                //得到设置时间所在下标
                                if (obj != array[array.count-1])//不是最后一个元素
                                {
                                    
                                    distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",[obj intValue]-weekDay-1,setColckHour.intValue +24-hour-1,setColckMin.intValue+60 -min];
                                    break;
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                else if(obj.intValue < weekDay)//设定闹钟时间小于当前时间
                {
                    
                    //1找到比设定闹钟大的元素
                    NSString *nextObj = nil;
                    NSString *oneObj = nil;
                    [addArray removeAllObjects];
                    for (NSString *obj in array) {
                        if (obj.intValue >= weekDay)
                        {
                            nextObj = [array objectAtIndex:[array indexOfObject:obj]];
                            [addArray addObject:nextObj];
                        }
                        
                        
                    }
                    
                    //距离的天
                    int dayTime = 0;
                    
                    oneObj = array[0];
                    if (nextObj==nil)//没有设定比当前时间更大的时间
                    {
                        dayTime  = oneObj.intValue +7-weekDay;
                        
                    }else   //有比当前星期大的时间
                    {
                        if  ([addArray[0] integerValue] == weekDay)
                        {
                            if(setColckHour.intValue <hour)//如果日期相等时间相等取第一个值
                            {
                                if (addArray.count == 1){//设定的闹钟就一个值比现在时间大
                                    dayTime  = oneObj.intValue +7-weekDay;
                                }else if (addArray.count > 1)
                                {
                                    dayTime = [addArray[1] integerValue]-weekDay;
                                }
                            }else if (setColckHour.intValue == hour){
                                
                                
                                if (addArray.count == 1){//设定的闹钟就一个值
                                    if (setColckMin.intValue < min) {
                                        dayTime  = oneObj.intValue +7-weekDay;
                                    }else
                                    {
                                        dayTime = [addArray[0]intValue] -weekDay;
                                        
                                    }
                                    
                                }else if (addArray.count > 1)//有多个值大于当前时间星期
                                {
                                    if (setColckMin.intValue < min) {
                                        dayTime = [addArray[1]intValue] -weekDay;
                                    }else
                                    {
                                        dayTime = [addArray[0]intValue] -weekDay;
                                    }
                                    
                                }
                                
                            }
                            else if(setColckHour.intValue > hour)
                            {
                                
                                dayTime = [addArray[0] integerValue] - weekDay;
                            }
                            
                        }else if ([addArray[0] intValue]> weekDay)
                        {
                            
                            dayTime = [addArray[0] integerValue] - weekDay;
                            
                        }
                        
                    }
                    
                    
                    
                    
                    if(setColckHour.intValue > hour)//设定小时大于当前小时已经ok
                    {
                        if (setColckMin.intValue >= min) {
                            distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime,setColckHour.intValue-hour,setColckMin.intValue -min];
                            break;
                        }else if (setColckMin.intValue < min)//设定分钟小于当前分钟
                            
                        {
                            distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime,setColckHour.intValue-hour-1,setColckMin.intValue + 60 -min];
                            break;
                        }
                        
                        
                    }else if (setColckHour.integerValue == hour){//设置闹钟的小时相等
                        
                        if (setColckMin.intValue >= min) {
                            distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime,setColckHour.intValue-hour,setColckMin.intValue -min];
                            break;
                        }else if (setColckMin.intValue < min)//设定分钟小于当前分钟
                        {
                            if (setColckHour.intValue - hour -1 >= 0){//不需要减一天
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime,setColckHour.intValue-hour-1,setColckMin.intValue + 60 -min];
                            }else if (setColckHour.intValue - hour -1 < 0){//需要减一天
                                
                                if (obj.intValue == 7){
                                    
                                    distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime,setColckHour.intValue+24-hour-1,setColckMin.intValue + 60 -min];
                                }else
                                {
                                    distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime-1,setColckHour.intValue+24-hour-1,setColckMin.intValue + 60 -min];//刚刚改这里
                                }
                            }
                            
                            break;
                        }
                    }else if (setColckHour.integerValue < hour){//设置闹钟的小时小于当前小时
                        
                        
                        if (setColckMin.intValue >min) {
                            
                            if (array.count == 1){
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime-1,setColckHour.intValue +24-hour,setColckMin.intValue -min];
                                break;
                            }else if (array.count >1)
                            {
                                
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime-1,setColckHour.intValue +24-hour,setColckMin.intValue-min];
                                break;
                            }
                            
                        }else if (setColckMin.intValue == min){
                            
                            
                            if (array.count == 1){
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime-1,setColckHour.intValue +24-hour,setColckMin.intValue -min];
                                break;
                            }else if (array.count >1)
                            {
                                
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime-1,setColckHour.intValue +24-hour,setColckMin.intValue-min];
                                break;
                            }
                            
                            
                            
                        }
                        
                        else if (setColckMin.intValue <min)
                        {
                            if (array.count == 1){
                                
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime-1,setColckHour.intValue +24-hour-1,setColckMin.intValue+60 -min];
                                break;
                            }else if (array.count > 1)
                            {
                                //得到设置时间所在下标
                                
                                distanceTime = [NSString stringWithFormat:@"%d天%d:%02d",dayTime-1,setColckHour.intValue +24-hour-1,setColckMin.intValue+60 -min];
                                break;
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
        }
        
        NSString *time =  NSLocalizedString(@"距离闹钟时间还有:", nil);
        
          NSMutableString *dateTimeString = [distanceTime mutableCopy];
            if ([dateTimeString rangeOfString:@"0天"].location != NSNotFound)
                 {
                     [dateTimeString deleteCharactersInRange:NSMakeRange(0, 2)];
                      countDownLabel.text = [NSString stringWithFormat:@"%@ %@",time,dateTimeString];
                 }else
                 {
                      countDownLabel.text = [NSString stringWithFormat:@"%@ %@",time,distanceTime];
                     
                 }
        
       
    }
    
}
#pragma -mark 闹钟头像点击
-(void)tapGesture
{
    SetClockDetailViewController *clockDetailVc = [[SetClockDetailViewController alloc] initWithNibName:@"SetClockDetailViewController" bundle:nil];
    clockDetailVc.selDev = self.selDev;
    [self.navigationController pushViewController:clockDetailVc animated:YES];

}

- (IBAction)deleteBtnClick:(id)sender {
     NSLog(@"删除闹钟");
//    if (self.selDev.repeatDate.count == 0) {
//        [ErrorAlerView showWithMessage:NSLocalizedString(@"未设定闹钟", nil) sucOrFail:NO];
//        return;
//    }
    
    // 记录删除闹钟的操作
    if (![repeatDateLabel.text isEqualToString:@""] && ![clockTimeLabel.text isEqualToString:@""]) {
        
        NSString *infoStr = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"删除了闹钟", nil),repeatDateLabel.text,clockTimeLabel.text];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"date",
                             infoStr,@"location",
                             self.selDev,@"devL",nil];
        DLog(@"%@",infoStr);
        
        [self.selDev.remoteCare addObject:dic];
    }
    
    [self sendRequestDeleteData];//删除闹钟请求
    
}


- (void)sendRequestDeleteData{
    
   
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_updateclock forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:_System_Language forKey:@"locale"];
    [signInfo setValue:self.selDev.bindIMEI forKey:@"eqId"];
    [signInfo setObject:@""forKey:@"repeatdate"];
    [signInfo setObject:@"" forKey:@"time"];
    
//    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//    NSString *sign = [MD5 createSignWithDictionary:signInfo];
//    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    
    req1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req1 addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req1.tag = 21;
    req1.delegate = self;
    [req1 startAsynchronous];
 //   _Code_ShowLoading
    
}

- (void)getClockDataRequest{

 
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_getclock forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:self.selDev.bindIMEI forKey:@"eqId"];
    [signInfo setValue:_System_Language forKey:@"locale"];

//    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//    NSString *sign = [MD5 createSignWithDictionary:signInfo];
//    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.tag = 20;
    req.delegate = self;
    [req startAsynchronous];
 //   _Code_ShowLoading
}


#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    
    _Code_HTTPResponseCheck(jsonDic, {
        
        if (request.tag == 20) {
            
            DLog(@"获取闹钟数据成功...");
            if(jsonDic[@"time"] && ![jsonDic[@"time"] isKindOfClass:[NSNull class]]){
                 NSString *clockTime = jsonDic[@"time"];
                _selDev.clockTime = clockTime;
                clockTimeLabel.text = clockTime;
                deleteBtn.hidden = NO;
                deleteTitleLabel.hidden = NO;
            }else{
            
                deleteBtn.hidden = YES;
                deleteTitleLabel.hidden = YES;
            }
            
            
            if (jsonDic[@"repeatdate"]&&![jsonDic[@"repeatdate"]isKindOfClass:[NSNull class]]) {
                NSArray *arr = [jsonDic[@"repeatdate"] componentsSeparatedByString:@","];
                _selDev.repeatDate = [NSMutableArray arrayWithArray:arr];
                DLog(@"_selDev is %@",_selDev.repeatDate);
                [self refreshRepeatDateLabel];// 刷新重复周期Label
            }
//            if (jsonDic[@"t"]) {
//                NSString *syntimeStr = jsonDic[@"t"];
//                NSDate *syntime = [NSDate dateWithTimeIntervalSince1970:[syntimeStr integerValue]];
//            }
           
        }else{
        
            NSLog(@"jsonDic=%@",jsonDic);
            NSLog(@"删除闹钟成功");
            
            deleteBtn.hidden = YES;
            deleteTitleLabel.hidden = YES;
            
            [ErrorAlerView showWithMessage:NSLocalizedString(@"删除成功", nil) sucOrFail:YES];
            repeatDateLabel.text = @"";
            clockTimeLabel.text = @"";
            countDownLabel.hidden = NO;
            countDownLabel.text = [NSString stringWithFormat:NSLocalizedString(@"设备没有设定闹钟", nil)];
            NSLog(@"self.selDev.repeatDate = %@",self.selDev.repeatDate);
            
            
            if (self.selDev.repeatDate != nil||self.selDev.repeatDate.count > 0||![self.selDev.repeatDate isEqual:@""]||![self.selDev.repeatDate isKindOfClass:[NSNull class]]) {
                 [self.selDev.repeatDate removeAllObjects];
            }
           
            self.selDev.clockTime = @"";
            [distanceTimer invalidate];
            distanceTimer = nil;
            [[UserData Instance]saveCustomObject:[UserData Instance]];
        }
        
        
    })
}

- (void)refreshRepeatDateLabel{

    if (_selDev.repeatDate.count >0) {
        
        NSString *repeatStr = @"";
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
        repeatDateLabel.text = repeatStr;
    
    }
}



@end
