//
//  DLChartUtility.m
//  ChartViewDemo
//
//  Created by vera on 15-3-29.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "DLChartUtility.h"

@implementation DLChartUtility

+ (CGFloat)getDataFromObject:(id)object
{
    if ([object isKindOfClass:[NSString class]])
    {
        return [object floatValue];
    }
    else if ([object isKindOfClass:[NSNumber class]])
    {
        return [object floatValue];
    }
    
    return 0.0;
}

+ (CGFloat)getMaxValueFromDatas:(NSArray *)datas
{
    __block NSInteger maxValue = 0;
    
    [datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         CGFloat number = [[self class] getDataFromObject:obj];
         
         if (number > maxValue)
         {
             maxValue = number;
         }
     }];
    
    return maxValue;
}

@end
