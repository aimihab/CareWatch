//
//  MNStepsCircleView.m
//  Movnow
//
//  Created by LiuX on 15/4/17.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#define LabelSpace 35

#import "MNCustomCircleView.h"
#import "UIColor+Util.h"
#import <zlib.h>

@interface MNCustomCircleView ()
{
    UIImage *sThumb;
    MNCustomPercentLayer *sPercentLayer;
    CALayer *sThumbLayer;
    NSTimer *sTimer;
    CGFloat sCount;
}
@end

@implementation MNCustomCircleView

- (id)init
{
	if (self = [super init]) {
		[self setUp];
    }
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {
		[self setUp];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self setUp];
	}
	return self;
}

- (UILabel *)msgLabel
{
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelSpace, LabelSpace, WIDTH(self) - LabelSpace, 20)];
        [_msgLabel setFont:TITLE_FONT];
        _msgLabel.textColor = [UIColor colorWithHexString:@"#6a8093"];
        
        [self addSubview:_msgLabel];
    }
    return _msgLabel;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 180, 180)];
        [_textLabel setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:30]];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.minimumScaleFactor = 0.8;
        
        
        _textLabel.textColor = [UIColor colorWithHexString:@"#f6812a"];
        
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UILabel *)percentLabel
{
    if (_percentLabel == nil) {
        _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT(self) - LabelSpace - 20, WIDTH(self) - LabelSpace, 20)];
        [_percentLabel setFont:[UIFont fontWithName:@"Noteworthy" size:18]];
        _percentLabel.textAlignment = NSTextAlignmentRight;
        _percentLabel.textColor = [UIColor colorWithHexString:@"#f59f63"];
        [self addSubview:_percentLabel];
    }
    return _percentLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int percent = sPercentLayer.percent*100;
    //[self.percentLabel setText:[NSString stringWithFormat:@"%i%%",100 - percent]];
    
   // [self.msgLabel setText:[NSString stringWithFormat:@"%i%",100 - percent]];
    if (self.isStep == NO){
        [self.textLabel setText:[NSString stringWithFormat:@"%i%",100 - percent]];

    }
    
    
}

-(void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;

    sThumbLayer = [CALayer layer];
    sThumbLayer.contentsScale = [UIScreen mainScreen].scale;
    sThumbLayer.contents = (id) sThumb.CGImage;
    sThumbLayer.frame = CGRectMake(self.frame.size.width / 2 - sThumb.size.width/2, 0, sThumb.size.width, sThumb.size.height);
    sThumbLayer.hidden = YES;
    
    sPercentLayer = [MNCustomPercentLayer layer];
    sPercentLayer.contentsScale = [UIScreen mainScreen].scale;
    sPercentLayer.percent = 0;
    sPercentLayer.frame = self.bounds;
    sPercentLayer.masksToBounds = NO;
    [sPercentLayer setNeedsDisplay];
    
    [self.layer addSublayer:sThumbLayer];
    [self.layer addSublayer:sPercentLayer];
}

#pragma mark - Touch Events
- (void)moveThumbToPosition:(CGFloat)angle
{
    CGRect rect = sThumbLayer.frame;
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    angle -= (M_PI/2);
    rect.origin.x = center.x + 75 * cosf(angle) - (rect.size.width/2);
    rect.origin.y = center.y + 75 * sinf(angle) - (rect.size.height/2);
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    sThumbLayer.frame = rect;
    [CATransaction commit];
}

#pragma mark - Custom Getters/Setters
- (void)setPercent:(CGFloat)percent animated:(BOOL)animated {

    if (percent == 0){
        [self.percentLabel setText:@"0%"];
        [self setPercent:0.0];
        return;
    }
    if (animated){
        if (sTimer == nil){
            sTimer = [NSTimer scheduledTimerWithTimeInterval:0.25/(percent) target:self selector:@selector(timerRunning:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(percent), @"percent", nil] repeats:YES];
        }
    }else{
        [self setPercent:percent];
    }
}

-(void)timerRunning:(NSTimer *)t
{
    sCount += 0.5;
    if (sCount > ((NSNumber *)[t userInfo][@"percent"]).intValue) {
        [sTimer invalidate];
        sTimer = nil;
        sCount = 0;
        return;
    }
    [self setPercent:sCount];
}

- (void)setPercent:(CGFloat)percent
{
    CGFloat floatPercent = (100 - percent) / 100.0;
    
    sPercentLayer.percent = floatPercent;
    [self setNeedsLayout];
    [sPercentLayer setNeedsDisplay];
    
    [self moveThumbToPosition:floatPercent * (2 * M_PI) - (M_PI/2)];
    
}

@end
