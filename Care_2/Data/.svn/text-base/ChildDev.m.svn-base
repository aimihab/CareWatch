//
//  ChildDev.m
//  Care_2
//
//  Created by lq on 15-3-19.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ChildDev.h"

@implementation ChildDev


+(ChildDev *)sharedInstance
{
    static ChildDev *simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simple=[[ChildDev alloc] init];
    });
    
    return simple;

}





@end
