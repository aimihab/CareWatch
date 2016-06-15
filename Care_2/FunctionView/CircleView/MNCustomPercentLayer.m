

#import "MNCustomPercentLayer.h"

#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)
#define innerRadius    81
#define outerRadius    86

@implementation MNCustomPercentLayer

@synthesize percent;

-(void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    [self DrawRight:ctx];
    [self DrawLeft:ctx];
}

-(void)DrawRight:(CGContextRef)ctx
{
    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));
    CGFloat delta = -toRadians(360 * percent);
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:125/255.0 green:146/255.0 blue:164/255.0 alpha:1].CGColor);
   
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRelativeArc(path, NULL, center.x+5, center.y, innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x+5, center.y, outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x+5, center.y-innerRadius);
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CFRelease(path);
}

-(void)DrawLeft:(CGContextRef)ctx
{
    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));
    CGFloat delta = toRadians(360 * (1-percent));
    NSLog(@"percent = %f",percent);

    if (percent>(100-52)/100.0&&percent<(100-42)/100.0 ){
        
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    }else if (percent >(100-75)/100.0&&percent<(100-65)/100.0){
    
        
        CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);

    }else if (percent >(100-64)/100.0&&percent<(100-53)/100.0){
        
        
        CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
        
    }else if (percent<(100-76)/100.0){
        
        
        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        
    }
    else
    {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:246/255.0 green:108/255.0 blue:0/255.0 alpha:1].CGColor);
    }
       CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRelativeArc(path, NULL, center.x+5, center.y, innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x+5, center.y, outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x+5, center.y-innerRadius);
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CFRelease(path);
}

@end
