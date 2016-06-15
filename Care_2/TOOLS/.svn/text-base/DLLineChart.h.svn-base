//
//  DLLineChart.h
//  ChartViewDemo
//
//  Created by vera on 15-3-29.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLLineChart : UIView

@property (nonatomic,assign)BOOL isStep ;
/**
 *
 * 圆点的半径
 *
 */
@property (nonatomic, assign) CGFloat circleRadius;

/**
 *
 * 圆点的颜色
 *
 */
@property (nonatomic, assign) CGFloat circleColor;

/**
 *
 * 线宽
 *
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *
 * Y轴文字
 *
 */
@property (nonatomic, strong) NSArray *yCoordinateLabelValues;

/**
 *
 * X轴文字
 *
 */
@property (nonatomic, strong) NSArray *xCoordinateLabelValues;

/**
 *
 * 数据总和
 *
 */
@property (nonatomic, assign) CGFloat tatalValues;

/**
 *
 * 画折线
 *
 */
- (void)addLDLineChartWithDatas:(NSArray *)datas strokeColor:(UIColor *)strokeColor;

@end
