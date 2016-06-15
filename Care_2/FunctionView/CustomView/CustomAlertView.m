//
//  CustomAlertView.m
//  NOMU
//
//  Created by 何兵 on 15/1/29.
//  Copyright (c) 2015年 movnow. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView
{
    BOOL isCloseBySelf;
    
    CAKeyframeAnimation *_popAnimation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.alpha = 0;
        _content = [[UIView alloc] initWithFrame:CGRectZero];
        _content.backgroundColor = [UIColor clearColor];
        _content.clipsToBounds = YES;
        [self addSubview:_content];
    }
    
    return self;
}

- (void)showAndCloseBySelf:(BOOL)aBool
{
    
    isCloseBySelf = aBool;
    
    if (!_popAnimation) {
        _popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        _popAnimation.duration = 0.4;
        _popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        _popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
        _popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    
    [_content.layer addAnimation:_popAnimation forKey:@"pop"];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (!CGRectContainsPoint(_content.frame, touchPoint) && isCloseBySelf) {
        [self removeFromSuperview];
    }
    
}

@end
