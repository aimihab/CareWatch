//
//  TestMapViewController.h
//  Care_2
//
//  Created by lq on 15-3-19.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestMapViewController : UIViewController


@property (nonatomic, strong) DeviceModel *devObj; 
//@property (nonatomic, weak)  ChildDev *dev;
//@property(nonatomic,strong)NSMutableArray *childLocationArr;

@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;


@end
