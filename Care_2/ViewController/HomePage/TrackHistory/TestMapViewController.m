//
//  TestMapViewController.m
//  Care_2
//
//  Created by lq on 15-3-19.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "TestMapViewController.h"
#import "DataBaseSimple.h"
#import "DeviceModel.h"
#import "ChildDev.h"
#import "AppDelegate.h"
#import "MapAnnotation.h"
#import "ErrorAlerView.h"
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "NSDate+Expend.h"
#import "MD5.h"
#define pi 3.14159265358979324

@interface TestMapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,ASIHTTPRequestDelegate>
{
    
    __weak IBOutlet MKMapView *_mapView;
    CLLocation *loction;
    CLLocationCoordinate2D devCoord;
    CLPlacemark *devMark;
    MKMapRect _routeRect;
    ASIHTTPRequest *req1;
    ASIHTTPRequest *req2;
    
    __weak IBOutlet UIButton *sureBtn;
    __weak IBOutlet UIButton *cancleBtn;
    
    
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UIButton *bottonBtn;
    
    
    __weak IBOutlet UIDatePicker *dataPicker;
    IBOutlet UIView *pickerView;
    
    
    IBOutlet UIView *selectDatetimeView; // 选择开始和结束时间的View
    
    __weak IBOutlet UIButton *startTimeBtn;
    __weak IBOutlet UIButton *endTimeBtn;
    __weak IBOutlet UIButton *sureTimeBtn;
    
    __weak IBOutlet UILabel *startTimeLabel;
    __weak IBOutlet UILabel *endTimeLabel;
    
    NSString *startTime;// 开始时间
    NSString *stopTime; // 结束时间
    
    CLLocationCoordinate2D startCoord;
    CLLocationCoordinate2D endCoord;
    
    
    NSMutableArray *_childLocationArr;
//    NSDate *startDate;
//    NSDate *endDate;
    
    UIButton *submitButton;
    
}


/**
 *  PickerView选择按钮事件
 */

- (IBAction)sureBtnClick:(id)sender; // 确定
- (IBAction)cancleBtnClick:(id)sender;// 取消

- (IBAction)bottomBtnClick:(id)sender;//时间选择




@end

@implementation TestMapViewController

- (void)viewWillAppear:(BOOL)animated{
    
    _childLocationArr = [NSMutableArray array];
    [[[UIApplication sharedApplication] keyWindow] addSubview:bottomView];
    bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.origin.y+64, 320, 40);
    bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_bg.png"]];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [bottomView removeFromSuperview];
}


- (void)refreshUIlanguage{

    startTimeLabel.text = NSLocalizedString(@"开始时间", nil);
    endTimeLabel.text = NSLocalizedString(@"结束时间", nil);
    
    [bottonBtn setTitle:NSLocalizedString(@"时间段选择", nil) forState:UIControlStateNormal];
    
    [sureTimeBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [cancleBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    
}

- (void)setDefaultTime{

    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    stopTime = [dateformat stringFromDate:now];
    [endTimeBtn setTitle:stopTime forState:UIControlStateNormal];
    
    
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [dateformat stringFromDate:now];
    startTime =[NSString stringWithFormat:@"%@ 00:00:00",str];
    [startTimeBtn setTitle:startTime forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"轨迹查看", nil);
    [self setBackButton];
    [self setSubmitButton];
    
     [self requestChildDevData];//请求默认轨迹
    [self setDefaultTime];// 初始化默认的时间段
    [self refreshUIlanguage];// 本地化UI
    
 //   [self getLocationDataArr];//绘制轨迹
//    [_mapView addOverlay:_routeLine];
    
    
    pickerView.frame = CGRectMake(10,HEIGHT(self.view)-240-64, WIDTH(self.view)-20, 200);
    pickerView.hidden = YES;
    pickerView.alpha = 0;
    [self.view addSubview:pickerView];
 //   dataPicker.date = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:[NSDate date]];// 设置默认的时间为昨天
    sureBtn.layer.cornerRadius = 5.0;
    sureBtn.clipsToBounds = YES;
    cancleBtn.layer.cornerRadius = 5.0;
    cancleBtn.clipsToBounds = YES;
    
    
    selectDatetimeView.frame = CGRectMake(0, Y(self.view)-64-145, WIDTH(self.view), 145);
    selectDatetimeView.hidden = YES;
    [self.view addSubview:selectDatetimeView];
    
    
#if 0
    // 在设备位置放置大头针
    MapAnnotation *annotation =[[MapAnnotation alloc] initWithTitle:nil Coordinate2D:devCoord];
    annotation.title = devMark.name;
    [_mapView addAnnotation:annotation];
    // 添加电子围栏圈
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:devCoord radius:1000];
    [_mapView addOverlay:circle];
#endif
    
    
}
_Method_SetBackButton(nil, NO)

-(void)setSubmitButton {
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 2, 44, 44);
    if (self.devObj.avatar) {
        [submitButton setImage:[UIImage imageWithData:self.devObj.avatar] forState:UIControlStateNormal];
    } else {
        [submitButton setImage:[UIImage imageNamed:@"icon_default_head_1"] forState:UIControlStateNormal];
    }
//    [submitButton addTarget:self action:@selector(onSubmitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    submitButton.imageEdgeInsets = (UIEdgeInsets){0,16,0,-16};
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
}

#pragma mark -选择时间视图
- (IBAction)start_endTimeBtnClick:(UIButton *)sender {
    sender.tag = 100;
    
    
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


- (IBAction)sureTimeBtnClick:(UIButton *)sender {
    


    if ([self compareDate:startTime withDate:stopTime] == -1) {
        [ErrorAlerView showWithMessage:NSLocalizedString(@"结束时间不能小于开始时间", nil) sucOrFail:YES];
        return;

    }
    
    
    [UIView animateWithDuration:0.5f animations:^{
        selectDatetimeView.frame = CGRectMake(0, Y(self.view)-64-145, WIDTH(self.view), 145);
          selectDatetimeView.hidden = YES;
    }];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@-%@",startTime,stopTime];
    [bottonBtn setTitle:timeStr forState:UIControlStateNormal];
    
    [self requestTrackData];// 请求轨迹
    
    
}


-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}


#pragma mark - 选择时间日期查看轨迹
- (IBAction)sureBtnClick:(id)sender {
    
    [self hiddePickView];
    // 选中日期和时间后拼接成指定的格式
    NSString *String = [NSDate getStringWithFormat:@"yyyy-MM-dd HH:mm:ss" andDate:dataPicker.date];
    
    DLog(@"********%@",String);
   
    if(startTimeBtn.tag == 100){
        
        [startTimeBtn setTitle:String forState:UIControlStateNormal];
        startTime = String;
       
        startTimeBtn.tag = 0;
    }else if(endTimeBtn.tag == 100){
    
        [endTimeBtn setTitle:String forState:UIControlStateNormal];
        
        stopTime = String;
        endTimeBtn.tag = 0;
    }
    
    
    
//    UIButton *tapBtn1 = (UIButton *)[bottomScrView viewWithTag:[addbtnTimeArray[0] intValue]];
//    UIButton *tapBtn2 = (UIButton *)[bottomScrView viewWithTag:[addbtnTimeArray[1] intValue]];
//    if (addbtnTimeArray[0] < addbtnTimeArray[1]) {
//        startTime = [NSString stringWithFormat:@"%@ %@:00",String,tapBtn1.titleLabel.text];
//        stopTime = [NSString stringWithFormat:@"%@ %@:00",String,tapBtn2.titleLabel.text];
//    }else{
//        startTime = [NSString stringWithFormat:@"%@ %@:00",String,tapBtn2.titleLabel.text];
//        stopTime = [NSString stringWithFormat:@"%@ %@:00",String,tapBtn1.titleLabel.text];
//    }
    
    

}

- (IBAction)cancleBtnClick:(id)sender {
    
    [self hiddePickView];
}

- (IBAction)bottomBtnClick:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [UIView animateWithDuration:0.5f animations:^{
            selectDatetimeView.hidden = NO;
            selectDatetimeView.frame = CGRectMake(X(self.view), Y(self.view)-24, WIDTH(self.view), 145);
        }];
        
    }else{
    
        [UIView animateWithDuration:0.5f animations:^{
            selectDatetimeView.frame = CGRectMake(0, Y(self.view)-64-145, WIDTH(self.view), 145);
           // selectDatetimeView.hidden = YES;
        }];
    
    
    }
    
}

- (void)hiddePickView{
    
    [UIView animateWithDuration:0.6 animations:^{
        pickerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        pickerView.hidden = YES;
    }];
    
    
}


- (void)addStart_EndAnnotation{

    // 在设备最终位置放置大头针
    MapAnnotation *annotation2 =[[MapAnnotation alloc] initWithTitle:nil Coordinate2D:endCoord];
    [_mapView addAnnotation:annotation2];
   
}

#pragma mark -获取设备位置信息组并绘制轨迹
- (void)getLocationDataArr
{
    [_mapView removeAnnotations:_mapView.annotations];
    //   - (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
    if (_childLocationArr&&_childLocationArr.count!= 0) {
        MKMapPoint northEastPoint;
        MKMapPoint southWestPoint;
        
        MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * _childLocationArr.count);
        DLog("------------_childLocationArr is %@",_childLocationArr);
        
        for(int idx = 0; idx < _childLocationArr.count; idx++)
        {
            
            ChildDev *model = _childLocationArr[idx];
            NSString *la = model.latitude;
            NSString *lo = model.longitude;
        
            double lat = [la doubleValue];
            double lon = [lo doubleValue];
            
            if (lat > 100000) {
                lat = lat/1000000;
            }
            if (lon > 100000) {
                lon = lon/1000000;
            }
            CLLocationCoordinate2D commonPolylineCoords;
            commonPolylineCoords.latitude = lat;
            commonPolylineCoords.longitude = lon;
            
            if([model.locationType isEqualToString:@"G"]){
                
                commonPolylineCoords = [MD5 locationTransFromWGSToGCJ:commonPolylineCoords];// 获取坐标偏移算法
            }
            
            
            MKMapPoint point = MKMapPointForCoordinate(commonPolylineCoords);
            
            if (idx == 0) {
                northEastPoint = point;
                southWestPoint = point;
                
                startCoord = commonPolylineCoords;
                
                MKCoordinateSpan span = {0.001,0.001};
                MKCoordinateRegion region = MKCoordinateRegionMake(commonPolylineCoords,span);
                [_mapView setRegion:region animated:YES];
                
                // 在设备初始位置放置大头针
                MapAnnotation *annotation =[[MapAnnotation alloc] initWithTitle:nil Coordinate2D:startCoord];
                [_mapView addAnnotation:annotation];
                
                
            }else if (idx == _childLocationArr.count-1){
                
                northEastPoint = point;
                southWestPoint = point;
                endCoord = commonPolylineCoords;
                
                
            }
            else
            {
                if (point.x > northEastPoint.x)
                    northEastPoint.x = point.x;
                if(point.y > northEastPoint.y)
                    northEastPoint.y = point.y;
                if (point.x < southWestPoint.x)
                    southWestPoint.x = point.x;
                if (point.y < southWestPoint.y)
                    southWestPoint.y = point.y;
            }
            
            pointArr[idx] = point;
            
        }
        
        
        self.routeLine = [MKPolyline polylineWithPoints:pointArr count:_childLocationArr.count];
        
        _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x -southWestPoint.x, northEastPoint.y - southWestPoint.y);
        
        free(pointArr);
        
        [_mapView addOverlay:_routeLine];
        [self addStart_EndAnnotation];

    }else{

        [ErrorAlerView showWithMessage:NSLocalizedString(@"无轨迹数据!", nil) sucOrFail:YES];
        return;

    }
    
    
    
    
    
    //    [_childLocationArr enumerateObjectsUsingBlock:^(ChildDev *model,NSUInteger idx,BOOL *stop){
    //
    //        NSString *la = model.latitude;
    //        NSString *lo = model.longitude;
    //        NSString *date = model.date;
    //        double lat = [la doubleValue]/1000000;
    //        double lon = [lo doubleValue]/1000000;
    //
    //        CLLocationCoordinate2D commonPolylineCoords;
    //        commonPolylineCoords.latitude = lat;
    //        commonPolylineCoords.longitude = lon;
    //
    //
    //        CLLocationCoordinate2D coordinate2D = {lat,lon};
    //        MKCoordinateSpan span = {0.05,0.05};
    //        //将经纬度和精度设置到地图上
    //        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate2D, span);
    //        [_mapView setRegion:region animated:YES];
    //    }];
    
    
    //    MKPolyline *Polyline = [MKPolyline polylineWithCoordinates:&coordinate2D count:idx];
    //
    //    [_mapView addOverlay:Polyline];
    //
    
    
}



#pragma mark - MKMapViewDelegate地图代理
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        NSLog(@"这是用户当前的位置,不需要定制..");
        return nil;
    }
    
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        static  NSString * annotationIdentifier = @"annotation identifier";
        MKPinAnnotationView * view = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            
            if (annotation == [_mapView.annotations objectAtIndex:0]) {
                view.pinColor = MKPinAnnotationColorRed;
                view.animatesDrop = YES;
                CLGeocoder * geocoder = [[CLGeocoder alloc] init];
                CLLocation * startlocation = [[CLLocation alloc] initWithLatitude:startCoord.latitude longitude:startCoord.longitude];
                [geocoder reverseGeocodeLocation:startlocation completionHandler:^(NSArray *placemarks, NSError *error){
                    // 详细位置信息类（国家 省 市 自治区 街道 邮政编码...）
                    CLPlacemark * placeMark = placemarks[0];
                    NSLog(@">>>%@ %@ %@ %@ %@ %@",placeMark.name,placeMark.locality,placeMark.country,placeMark.thoroughfare,placeMark.ISOcountryCode,placeMark.ocean);
                    
                    NSString *startStr = [NSString stringWithFormat:@"%@%@" ,NSLocalizedString(@"起点:", nil),placeMark.name];
                    [view setContent:startStr];
                }];
                
            }else {
                view.pinColor = MKPinAnnotationColorGreen;
                view.animatesDrop = YES;
                CLGeocoder * geocoder = [[CLGeocoder alloc] init];
                CLLocation * endlocation = [[CLLocation alloc] initWithLatitude:endCoord.latitude longitude:endCoord.longitude];
                [geocoder reverseGeocodeLocation:endlocation completionHandler:^(NSArray *placemarks, NSError *error){
                    // 详细位置信息类（国家 省 市 自治区 街道 邮政编码...）
                    CLPlacemark * placeMark = placemarks[0];
                    NSLog(@">>>%@ %@ %@ %@ %@ %@",placeMark.name,placeMark.locality,placeMark.country,placeMark.thoroughfare,placeMark.ISOcountryCode,placeMark.ocean);
                    
                    NSString *endStr = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"终点:", nil),placeMark.name];
                    [view setContent:endStr];
                }];
        
            }
            return view;
        }
    }
    return nil;
    
}




//#pragma mark 根据坐标取得地名
//-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
//    //反地理编码
//
//    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
//    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *placemark =[placemarks firstObject];
//
//        devMark = placemark;
//        NSLog(@"详细信息:%@",placemark.addressDictionary);
//
//    }];
//}


#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *_circleView=[[MKCircleView alloc] initWithCircle:overlay];
        _circleView.fillColor =  [UIColor colorWithRed:137/255.0 green:170/255.0 blue:213/255.0 alpha:0.2];
        _circleView.strokeColor = [UIColor colorWithRed:117/255.0 green:161/255.0 blue:220/255.0 alpha:0.8];
        _circleView.lineWidth=2.0;
        return _circleView;
    }
    
    else if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 10.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
//        polylineView.fillColor =  [UIColor colorWithRed:255/255.0 green:108/255.0 blue:9/255.0 alpha:0.5];
        polylineView.lineJoin = kCGLineCapRound;//连接类型
        polylineView.lineCap =  kCGLineCapRound;//端点类型
        
        return polylineView;
    }
    
    return nil;
}

//#pragma mark - 坐标偏移算法
//- (CLLocationCoordinate2D)locationTransFromWGSToGCJ:(CLLocationCoordinate2D)wgLoc
//{
//    
//    const double a = 6378245.0;
//    const double ee = 0.00669342162296594323;
//    
//    CLLocationCoordinate2D mgLoc;
//    //    if (outOfChina(wgLoc.lat, wgLoc.lng))
//    //    {
//    //        mgLoc = wgLoc;
//    //        return mgLoc;
//    //    }
//    
//    if (![MD5 isChina]) {
//        mgLoc = wgLoc;
//        return mgLoc;
//    }
//    double dLat = transformLat(wgLoc.longitude - 105.0, wgLoc.latitude - 35.0);
//    double dLon = transformLon(wgLoc.longitude - 105.0, wgLoc.latitude - 35.0);
//    double radLat = wgLoc.latitude / 180.0 * pi;
//    double magic = sin(radLat);
//    magic = 1 - ee * magic * magic;
//    double sqrtMagic = sqrt(magic);
//    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
//    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
//    double lat = wgLoc.latitude + dLat;
//    double lon = wgLoc.longitude + dLon;
//    mgLoc.latitude = lat;
//    mgLoc.longitude = lon;
//    
//    return mgLoc;
//    
//}
//
//double transformLat(double x, double y)
//{
//    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
//    ret += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
//    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
//    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
//    return ret;
//}
//
//double transformLon(double x, double y)
//{
//    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
//    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
//    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
//    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
//    return ret;
//}


#pragma mark - 请求默认轨迹
-(void)requestChildDevData{
    
    //    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-7200];
    //    NSString *startTime = [dateformat stringFromDate:startDate];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    stopTime = [dateformat stringFromDate:now];
    
    
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [dateformat stringFromDate:now];
    startTime =[NSString stringWithFormat:@"%@ 00:00:00",str];
    
//     DeviceModel *dev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
   
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_user_gettrackdata forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    [signInfo setValue:_devObj.bindIMEI forKey:@"eqId"];
    [signInfo setValue:startTime forKey:@"start"];
    [signInfo setValue:stopTime forKey:@"stop"];
    
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createTrackUrlWithDictionary:signInfo Sign:sign];
    NSLog(@"urlStr is %@....",urlStr);
    req1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req1 addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    
    req1.delegate = self;
    req1.tag = 50;
    [req1 startAsynchronous];
    _Code_ShowLoading
    
}



#pragma mark - 请求轨迹
- (void)requestTrackData{

    
    DeviceModel *dev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_user_gettrackdata forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    [signInfo setValue:dev.bindIMEI forKey:@"eqId"];
    [signInfo setValue:startTime forKey:@"start"];
    [signInfo setValue:stopTime forKey:@"stop"];
    
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createTrackUrlWithDictionary:signInfo Sign:sign];
    NSLog(@"urlStr is %@....",urlStr);
    req2 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req2 addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    
    req2.delegate = self;
    req2.tag = 51;
    [req2 startAsynchronous];
    _Code_ShowLoading

}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    _Code_HTTPResponseCheck(jsonDic, {
        
        if (request.tag == 50) {
            
           // DataBaseSimple *simple = [DataBaseSimple shareInstance];
            [_childLocationArr removeAllObjects];
            for (NSDictionary *devDic in jsonDic[@"track"]) {
                
                NSLog(@"获取设备轨迹成功！");
                ChildDev *model = [[ChildDev alloc] init];
                model.latitude=devDic[@"la"];
                model.longitude=devDic[@"lo"];
                model.date = devDic[@"time"];
                model.locationType = devDic[@"g"];
                
          //      [simple insertIntoDB:model];// 插入数据库
                [_childLocationArr addObject:model];
            }
            
        }else{
        
        
            [_childLocationArr removeAllObjects];
            for (NSDictionary *devDic in jsonDic[@"track"]) {
                
                NSLog(@"获取设备轨迹成功！");
                ChildDev *model = [[ChildDev alloc] init];
                model.latitude=devDic[@"la"];
                model.longitude=devDic[@"lo"];
                model.date = devDic[@"time"];
                model.locationType = devDic[@"g"];
               
                [_childLocationArr addObject:model];
            }

            
        }
        [_mapView removeAnnotations:_mapView.annotations];
        [_mapView removeOverlay:_routeLine];
        [self getLocationDataArr];// 绘制轨迹

        
    })
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
