//
//  LookAtTheMap_ViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-27.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "LookAtTheMap_ViewController.h"
#import "MD5.h"
#import "ASIHTTPRequest.h"
#import "ErrorAlerView.h"
#import "OperationQueue.h"

#define _Get_LocInfo_Count 15
typedef void (^GetPhoneL)(void);

@interface LookAtTheMap_ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate,ASIHTTPRequestDelegate> {
    NSString *rightBtTitle;
    __weak IBOutlet MKMapView *_mapView;
    __weak IBOutlet UIButton *aimBtn;
    __weak IBOutlet UILabel *msgLabel;
    __weak IBOutlet UIButton *gpsBtn;
    
    CLLocationManager * _manager;
    CLPlacemark *devMark;
    
    MKAnnotationView *lastAnnotationView;
    CLLocationCoordinate2D _devCoord; // 定位设备位置的经纬度
    int count;
    BOOL isRegion;
    
    GetPhoneL getPhoneLBlock_;
    
    
    
    ASIHTTPRequest *req;
    
    
    
}

- (IBAction)onAimButtonPressed:(UIButton *)sender;

@end

@implementation LookAtTheMap_ViewController

-(void)viewWillAppear:(BOOL)animated {
    if (self.type) {
        msgLabel.hidden = YES;
    } else {
        msgLabel.text = [NSString stringWithFormat:NSLocalizedString(@"     预警距离%d米", nil), self.dev.careDist];
    }
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sing_ind"object:nil];
}

- (void)setGpsBtn{
    
    gpsBtn.hidden = NO;
    gpsBtn.layer.cornerRadius = 10.f;
    [gpsBtn setTitle:NSLocalizedString(@"GPS:关", nil) forState: UIControlStateNormal];
    [gpsBtn setTitle:NSLocalizedString(@"GPS:开", nil) forState: UIControlStateSelected];
    if (self.dev.isGpsOn) {
        gpsBtn.selected = YES;
        [gpsBtn setBackgroundColor:[UIColor orangeColor]];
    }else{
        
        gpsBtn.selected = NO;
        [gpsBtn setBackgroundColor:[UIColor grayColor]];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setBackButton];
    isRegion = NO;
    
    // 注册收到单点位置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentDevL) name:@"sing_ind" object:nil];
    
    
    switch (self.type) {
        case 0:{
            rightBtTitle = NSLocalizedString(@"编辑", nil);
            
        }   break;
        case 1:{
            
            self.title = NSLocalizedString(@"地图", nil);
            [self setGpsBtn];
            rightBtTitle = NSLocalizedString(@"记录位置", nil);
            [self setSubmitButton];
            if (!self.devL && self.devL == nil) {
                //添加设备大头针
                self.devL = [[CLLocation alloc] initWithLatitude:self.dev.la longitude:self.dev.lo];
                CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake(self.devL.coordinate.latitude,self.devL.coordinate.longitude);
                
                if (!self.dev.positioningType) {
                    
                    coord = [MD5 locationTransFromWGSToGCJ:coord];
                }
                
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 3000, 3000);
                [_mapView setRegion:region animated:YES];
                MapAnnotation *annotation =[[MapAnnotation alloc] initWithTitle:nil Coordinate2D:coord];
                [_mapView addAnnotation:annotation];
            }
        }   break;
        case 2:{
            // 添加用户大头针
            // MapAnnotation *pA =[[MapAnnotation alloc] initWithTitle:nil Coordinate2D:self.phoneL.coordinate];
            // pA.tag = 30;
            DLog(@"查看历史记录的位置信息...");
            self.title = NSLocalizedString(@"历史位置", nil);
            if (self.devL) {
                
                CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake(self.devL.coordinate.latitude,self.devL.coordinate.longitude);
                coord = [MD5 locationTransFromWGSToGCJ:coord];
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 3000, 3000);
                [_mapView setRegion:region animated:YES];
                MapAnnotation *dA =[[MapAnnotation alloc] initWithTitle:nil Coordinate2D:coord];
                
                [_mapView addAnnotation:dA];
                
            }
        }
            
            break;
    }
    
    DLog(@">>>>>>>%d",self.type);
    //    __block typeof(aimBtn) aimBtn_=aimBtn;
    //    [self startLocationManager];
    //    [self setGetPhoneL:^{
    //        aimBtn_.hidden=NO;
    //    }];
    
    //测试经纬度 “ la:22.55467253 lo:113.94541041 ”
    
    DLog(@"self.devL---%@", self.devL);
}

- (void)getCurrentDevL
{
    
    DeviceModel *devf=[UserData Instance].deviceDic[self.dev.bindIMEI];
    
    
    
    self.dev.locateTime = devf.locateTime;
    self.dev.electricity = devf.electricity;
    DLog(@"定位时间%@,设备电量%d",devf.locateTime,devf.electricity);
    
    self.devL = [[CLLocation alloc] initWithLatitude:devf.la longitude:devf.lo]; //获取当前位置location
    [_mapView removeAnnotations:_mapView.annotations];
    
    CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake(devf.la,devf.lo);
    
    if(!devf.positioningType){
        
        coord = [MD5 locationTransFromWGSToGCJ:coord]; //偏移算法
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 3000, 3000);
    [_mapView setRegion:region animated:YES];
    MapAnnotation *currentDA =[[MapAnnotation alloc] initWithTitle:nil Coordinate2D:coord];
    
    [_mapView addAnnotation:currentDA];
    
}


_Method_SetBackButton(nil, NO)
_Method_SetSubmitButton(rightBtTitle, (@selector(onRightButtonPressed)), _StringWidth(rightBtTitle))

-(void)onRightButtonPressed {
    if (self.type) {
        if (!self.dev.online || !self.devL) {
            CustomIOS7AlertView *alertView;
            alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"未搜寻到设备所在位置", nil)];
            [alertView show];
            return;
        }
        
        //记录位置
        if ([devMark name]) {
            DLog(@"记录位置：%@", [devMark name]);
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSDate date], @"date",
                                 [devMark name], @"location",
                                 self.dev.locationType, @"locationType",
                                 self.devL, @"devL", nil];
            
            DLog(@"保存的信息dic = %@", dic);
            [self.dev.remoteCare addObject:dic];
            CustomIOS7AlertView *alerView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"记录成功", nil)];
            [alerView show];
        } else {
            CustomIOS7AlertView *alerView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"正在定位，请稍等", nil)];
            [alerView show];
        }
    } else {
        //编辑
        AddCare_ViewController *addCareVC = [[AddCare_ViewController alloc] initWithNibName:@"AddCare_ViewController" bundle:nil];
        addCareVC.dev = self.dev;
        [self.navigationController pushViewController:addCareVC animated:YES];
    }
}

- (void)setGetPhoneL:(GetPhoneL)phoneL
{
    getPhoneLBlock_ = [phoneL copy];
}

- (IBAction)onAimButtonPressed:(UIButton *)sender {
    
    __block typeof(_mapView) _mapView_=_mapView;
    __block typeof(self) self_=self;
    [self startLocationManager];
    [self setGetPhoneL:^{
        [_mapView_ setCenterCoordinate:[self_.phoneL coordinate] animated:YES];
    }];
    
    NSLog(@">>>>>>>111%@<<<<<<",self.phoneL);
}

- (void)startLocationManager {
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"手机定位");
        
        if (!_manager) {
            _manager = [[CLLocationManager alloc]init];
            
            if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) && [_manager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [_manager requestWhenInUseAuthorization];
                
            }
            _manager.delegate = self;
            [_manager setDistanceFilter:kCLLocationAccuracyNearestTenMeters];
            [_manager setDesiredAccuracy:kCLLocationAccuracyBest];
        }
        
        _mapView.showsUserLocation = YES;
        [_manager startUpdatingLocation];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Nil message:NSLocalizedString(@"亲，您还没将定位功能打开哟，赶紧打开吧！", nil)
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.phoneL = [locations lastObject];
    DLog(@"  %@---%d", self.phoneL, count);
    
    if ([self.phoneL.timestamp timeIntervalSinceNow] < -5.0) {
        
        return;
    }
    
    if (self.phoneL.horizontalAccuracy < 0) {
        return;
    }
    
    //    if (self.dev.online && self.devL) {
    //        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.phoneL.coordinate, 3000, 3000);
    //        [_mapView setRegion:region animated:YES];
    //    } else {
    //        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.devL.coordinate, 3000, 3000);
    //        [_mapView setRegion:region animated:YES];
    //    }
    //
    getPhoneLBlock_();
    [_manager stopUpdatingLocation];
    _manager.delegate = Nil;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"error is %@",error);
    if (error.code == kCLErrorLocationUnknown) {
        return;
    }
    [_manager stopUpdatingLocation];
    _manager.delegate = Nil;
}

//根据经纬度解析成位置
-(void)getlocationInfoWith:(CLGeocoder *)g isPhone:(BOOL)isPhone view:(MKAnnotationView *)annotationView prefix:(NSString *)prefix {
    [g reverseGeocodeLocation:(isPhone ? self.phoneL:self.devL) completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mark = [placemarks lastObject];
        if ([mark name]) {
            
            NSString *devPower = [NSString stringWithFormat:@"%@%d％",NSLocalizedString(@"设备电量:", nil),self.dev.electricity];
            
            
            if(_dev.locateTime == nil || _dev.locateTime == NULL){
                
                [annotationView setContent:[NSString stringWithFormat:@"%@%@\n%@",prefix,[mark name],devPower]];
            }else{
                
                [annotationView setContent:[NSString stringWithFormat:@"%@%@\n%@\n%@", prefix, [mark name],self.dev.locateTime,devPower]];
            }
            
            if (!isPhone) {
                devMark = mark;
            }
            count = 0;
        } else {
            [NSThread sleepForTimeInterval:0.2];
            count++;
            if (count < _Get_LocInfo_Count) {
                [self getlocationInfoWith:g isPhone:isPhone view:annotationView prefix:prefix];
            }
        }
    }];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    if (self.type && !isRegion) {
        isRegion = YES;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.devL.coordinate, 3000, 3000);
        [_mapView setRegion:region animated:YES];
        
        //        [_mapView removeOverlays:_mapView.overlays];
        //        MKCircle *circle = [MKCircle circleWithCenterCoordinate:[self.phoneL coordinate] radius:self.dev.careDist];
        //        [_mapView addOverlay:circle];
    }
}

// 定制大头针样式
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        annotationView.image = [UIImage imageNamed:@"03_map_end"];
        annotationView.bounds = CGRectMake(0, 0, 45, 54);
        [annotationView setAvatar:[UIImage imageWithData:[UserData Instance].avatarData]];
        [annotationView setContentHide:NO];
        [annotationView setContent:[NSString stringWithFormat:@"ME:%@", NSLocalizedString(@"加载中...", nil)]];
        
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        [self getlocationInfoWith:geocoder isPhone:YES view:annotationView prefix:@"ME:"];
        return annotationView;
        
    }
    
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        static  NSString * annotationIdentifier = @"annotation identifier";
        MKAnnotationView * pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pinView) {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            
            //            if (((MapAnnotation *)annotation).tag) {
            //                annotationView.image = [UIImage imageNamed:@"03_map_end"];
            //                annotationView.bounds = CGRectMake(0, 0, 45, 54);
            //                [annotationView setAvatar:[UIImage imageWithData:[UserData Instance].avatarData]];
            //                [annotationView setContentHide:NO];
            //
            //                NSString *prefix = @"ME:";
            //                [annotationView setContent:[NSString stringWithFormat:@"ME:%@", prefix, NSLocalizedString(@"加载中...", nil)]];
            //
            //                [self getlocationInfoWith:geocoder isPhone:YES view:annotationView prefix:prefix];
            //
            //            } else {
            annotationView.image = [UIImage imageNamed:@"03_map_start"];
            annotationView.bounds = CGRectMake(0, 0, 45, 54);
            [annotationView setAvatar:[UIImage imageWithData:self.dev.avatar]];
            
            NSString *prefix;
            switch (self.dev.positioningType) {
                case 0:
                {
                    prefix = @"GPS:";
                }
                    break;
                case 1:
                {
                    prefix = @"LBS:";
                }
                    break;
                case 2:
                {
                    prefix = @"WIFI:";
                }
                default:
                    break;
            }
            
            //                NSString *prefix = self.dev.positioningType ? @"LBS:":@"GPS:";
            
            [annotationView setContent:[NSString stringWithFormat:@"%@%@", prefix,NSLocalizedString(@"加载中...", nil)]];
            
            [self getlocationInfoWith:geocoder isPhone:NO view:annotationView prefix:prefix];
            //            }
            
            return annotationView;
        }else{
            pinView.annotation = annotation;
            return pinView;
        }
    }
    return nil;
}
// 选中气泡
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (lastAnnotationView) {
        [lastAnnotationView viewWithTag:100].hidden = YES;
    }
    lastAnnotationView = view;
}
//#pragma mark 取消选中时触发
//-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
//    [self removeCustomAnnotation];
//}
//#pragma mark 移除所用自定义大头针
//-(void)removeCustomAnnotation{
//    [_mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isKindOfClass:[MKUserLocation class]]) {
//            [_mapView removeAnnotation:obj];
//        }
//    }];
//}



// 更新位置
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    
    [_mapView removeOverlays:_mapView.overlays];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:loc radius:self.dev.careDist];
    [_mapView addOverlay:circle];
    
    [_manager stopUpdatingLocation];
}

#pragma clang diagnostic ignored "-Wdeprecated-declarations" // 画圈圈的代理方法
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *_circleView=[[MKCircleView alloc] initWithCircle:overlay];
        _circleView.fillColor =  [UIColor colorWithRed:137/255.0 green:170/255.0 blue:213/255.0 alpha:0.2];
        _circleView.strokeColor = [UIColor colorWithRed:117/255.0 green:161/255.0 blue:220/255.0 alpha:0.8];
        _circleView.lineWidth=2.0;
        return _circleView;
    }
    return nil;
}


- (void)requestGpsOn_OffWithGpsState: (NSString *)gpsState {
    
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_gps forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:self.dev.bindIMEI forKey:@"eqId"];
    [signInfo setValue:gpsState forKey:@"type"];
    
    
    
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    NSLog(@"urlStr is %@....",urlStr);
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    
    req.delegate = self;
    req.tag = 71;
    [req startAsynchronous];
    _Code_ShowLoading
    
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    _Code_HTTPResponseCheck(jsonDic, {
        if (request.tag == 71) {
            
            DLog(@"设备Gps切换状态成功..");
            
        }
        
    })
}
_Method_RequestFailed()


- (IBAction)turnDown_OffBtnClick:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    
    
    if (sender.selected) {
        
        
        DLog(@"gps开启..");
        
        [self requestGpsOn_OffWithGpsState:@"on"];
        [gpsBtn setBackgroundColor:[UIColor orangeColor]];
        
        [[OperationQueue Instance] setSingle:self.dev]; // 单点请求设备当前位置
        
    }else{
        
        DLog(@"gps关闭");
        [self requestGpsOn_OffWithGpsState:@"off"];
        
        [gpsBtn setBackgroundColor:[UIColor grayColor]];
    }
    
    
}


@end