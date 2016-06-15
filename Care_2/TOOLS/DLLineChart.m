//
//  DLLineChart.m
//  ChartViewDemo
//
//  Created by vera on 15-3-29.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "DLLineChart.h"
#import "DLChartUtility.h"

@interface DLLineChart ()
{
    CAShapeLayer *lineLayer;
    CAShapeLayer *circleLayer;
    
    CGFloat xOffset;
    
    //数据
    NSArray *chartDatas;
    
    //x轴
    UILabel *xCoordinateLabel;
    //y轴
    UILabel *yCoordinateLabel;
    
    //x轴间距
    CGFloat numberOfSectionWidthForX;
    //y轴间距
    CGFloat numberOfSectionWidthForY;
    
    NSArray *_xCoordinateLabelValues;
    NSArray *_yCoordinateLabelValues;
}

@end

@implementation DLLineChart


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _circleRadius = 6;
        _circleColor = 0.5;
        //        _xDivisionWidth = 50;
        //        _yDivisionWidth = 50;
        _lineWidth = 2.5;
        
        xOffset = 0.0;
        
        self.backgroundColor = [UIColor clearColor];
        
        
        [self drawCoordinateAxis];
        
    }
    
    return self;
}

#pragma -mark 绘制x和y坐标轴
- (void)drawCoordinateAxis
{
    yCoordinateLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 30, 1, CGRectGetHeight(self.frame) - 80)];
    
    yCoordinateLabel.backgroundColor = [UIColor lightGrayColor];
    // [self addSubview:yCoordinateLabel];//y坐标轴
    
    
    xCoordinateLabel = [[UILabel alloc] initWithFrame:CGRectMake(yCoordinateLabel.frame.origin.x, CGRectGetMaxY(yCoordinateLabel.frame), self.frame.size.width - xOffset , 1)];
    xCoordinateLabel.backgroundColor = [UIColor lightGrayColor];
    //  [self addSubview:xCoordinateLabel];//x坐标轴
    
}

- (void)setYCoordinateLabelValues:(NSArray *)yCoordinateLabelValues
{
    _yCoordinateLabelValues = yCoordinateLabelValues;
    
    if (_yCoordinateLabelValues.count > 0)
    {
        //y轴间距
        numberOfSectionWidthForY = yCoordinateLabel.frame.size.height / _yCoordinateLabelValues.count;
    }
}

- (NSArray *)yCoordinateLabelValues//返回y值的数组
{
    return _yCoordinateLabelValues;
}


- (void)setXCoordinateLabelValues:(NSArray *)xCoordinateLabelValues//设置x轴间距宽度
{
    _xCoordinateLabelValues = xCoordinateLabelValues;
    
    if (_xCoordinateLabelValues.count > 0)
    {
        //x轴
        
        
        
        numberOfSectionWidthForX = xCoordinateLabel.frame.size.width / (_xCoordinateLabelValues.count-1)+0.15;
        
        
    }
}

- (NSArray *)xCoordinateLabelValues//返回x值的数组
{
    return _xCoordinateLabelValues;
}

- (void)addLDLineChartWithDatas:(NSArray *)datas strokeColor:(UIColor *)strokeColor
{
    
    chartDatas = datas;
    
    //计算总数
    for (id number in chartDatas)
    {
        _tatalValues += [DLChartUtility getDataFromObject:number];
    }
    
    
    CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.frame = self.bounds;
    
    // backgroundLayer.fillColor = [strokeColor colorWithAlphaComponent:0.05].CGColor;//阴影部分的颜色
    if (self.isStep == YES)
    {
        backgroundLayer.strokeColor = [UIColor clearColor].CGColor;
        backgroundLayer.fillColor = [UIColor colorWithRed:112/255.0 green:156/255.0 blue:196
                                     /255.0 alpha:1.0].CGColor;
        
    }
    
    [self.layer addSublayer:backgroundLayer];
    
    lineLayer = [CAShapeLayer layer];
    lineLayer.frame = self.bounds;
    lineLayer.strokeColor = strokeColor.CGColor;
    lineLayer.lineWidth = _lineWidth;
    //    lineLayer.lineCap = kCALineCapRound;
    //    lineLayer.lineJoin = kCALineJoinBevel;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:lineLayer];
    
    circleLayer = [CAShapeLayer layer];
    circleLayer.frame = self.bounds;
    circleLayer.strokeColor = strokeColor.CGColor;
    circleLayer.lineWidth = _lineWidth;
    //    circleLayer.lineCap = kCALineCapRound;
    //    circleLayer.lineJoin = kCALineJoinBevel;
    // circleLayer.fillColor = strokeColor.CGColor;
    circleLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:circleLayer];
    
    
    //UIBezierPath *linePath = [UIBezierPath bezierPath];
    CGMutablePathRef backgroundPath = CGPathCreateMutable();
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    //CGFloat maxValue = [DLChartUtility getMaxValueFromDatas:datas];//得到数组里面的最大值并且转换成CGFloat
    CGFloat maxValue = 5000;
    CGPoint point;
    
    for (int i = 0; i < datas.count; i++)
    {
        
        //  NSLog(@"valut = %f,i = %d",[DLChartUtility getDataFromObject:datas[i]],i);
        
        
        
        point = CGPointMake(xOffset + numberOfSectionWidthForX*i, CGRectGetMinY(yCoordinateLabel.frame) + (5000 - [DLChartUtility getDataFromObject:datas[i]])/5000 * CGRectGetHeight(yCoordinateLabel.frame));
        
        if ([DLChartUtility getDataFromObject:datas[i]] != 0.0)
            //画圆
            //  CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(point.x - _circleRadius/2, point.y - _circleRadius/2, _circleRadius, _circleRadius));
            //  NSLog(@"point0 =%@", NSStringFromCGPoint(point));
            
            
            
            //画线
            if (i == 0)
            {
                
                CGPathMoveToPoint(linePath, NULL, point.x, point.y);
                CGPathMoveToPoint(backgroundPath, NULL, point.x, point.y);
                
            }
            else
            {
                CGPathAddLineToPoint(linePath, NULL, point.x, point.y);
                CGPathAddLineToPoint(backgroundPath, NULL, point.x, point.y);
                
            }
    }
    
    if (datas.count > 0 )
    {
        CGFloat yOffset = [DLChartUtility getDataFromObject:datas[datas.count - 1]]/5000
        * CGRectGetHeight(yCoordinateLabel.frame);
        
        
        CGPathAddLineToPoint(backgroundPath, NULL, point.x, point.y + yOffset);
        CGPathAddLineToPoint(backgroundPath, NULL, xOffset, point.y + yOffset);
        CGPathCloseSubpath(backgroundPath);
    }
    
    if(self.isStep)
    {
        backgroundLayer.path = backgroundPath;//背景颜色路径
        
    }
    lineLayer.path = linePath;//线的路径
    //circleLayer.path = circlePath;//圆点的路径
    
    
    CGPathRelease(backgroundPath);
    CGPathRelease(circlePath);
    CGPathRelease(linePath);
    
    
    
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:242.0/255/0 green:242.0/255/0 blue:242.0/255/0 alpha:0.1].CGColor);
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    //x轴 Lable显示
    if (_xCoordinateLabelValues.count > 0)
    {
        NSInteger labelHeight = 30;
        
        for (int i = 0; i < _xCoordinateLabelValues.count; i++)
        {
            CGRect rect = CGRectMake(xOffset + numberOfSectionWidthForX * i - numberOfSectionWidthForX/2, CGRectGetMaxY(xCoordinateLabel.frame) +5, numberOfSectionWidthForX, labelHeight);
            
            NSString *text = [NSString stringWithFormat:@"%@",_xCoordinateLabelValues[i]];
            
            // [text drawInRect:rect withAttributes:@{NSParagraphStyleAttributeName:style}];//改
            
            
        }
    }
    
    style.alignment = NSTextAlignmentRight;
    
    CGFloat labelHeight = 20;
    
    //y轴
    if (_yCoordinateLabelValues.count > 0)
    {
        for (int i = 1; i < _yCoordinateLabelValues.count + 1; i++)
        {
            CGRect rect = CGRectMake(0, CGRectGetMaxY(yCoordinateLabel.frame) - i*numberOfSectionWidthForY - labelHeight/2, xOffset - 5, labelHeight);
            
            NSString *text;
            
            text = [NSString stringWithFormat:@"%@",_yCoordinateLabelValues[i-1]];
            
            //  [text drawInRect:rect withAttributes:@{NSParagraphStyleAttributeName:style}];//改
            
            //最上面的不加线
            if (i < _yCoordinateLabelValues.count)
            {
                //添加横线
                //                CGContextMoveToPoint(context, xOffset, CGRectGetMidY(rect));
                //                CGContextAddLineToPoint(context, xOffset + CGRectGetWidth(xCoordinateLabel.frame), CGRectGetMidY(rect));
                //                CGContextStrokePath(context);//改
            }
        }
    }
}


@end
