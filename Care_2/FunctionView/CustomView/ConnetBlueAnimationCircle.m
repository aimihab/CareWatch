//
//  ConnetBlueAnimationCircle.m
//  Care_2
//
//  Created by xiaobing on 15/5/28.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "ConnetBlueAnimationCircle.h"

@implementation ConnetBlueAnimationCircle


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        circleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"连接硬件_圈-动态光晕-底"]];
        circleImgView.frame = CGRectMake(0, 0, 180, 180);
        [circleImgView setCenter:self.center];
        [self addSubview:circleImgView];
        [circleImgView release];
        
    }


    return self;

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        circleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"连接硬件_圈-动态光晕-底"]];
        [circleImgView setFrame:CGRectMake(0, 0, 130, 130)];
        [circleImgView setCenter:self.center];
        [self addSubview:circleImgView];
        [circleImgView release];
        [circleImgView setAlpha:0.3f];

    
    
    }


    return self;

}

- (void)stratAnimation
{
    int temp = 10;
    [UIView beginAnimations:@"ani1" context:Nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(aniSecond)];
    [UIView setAnimationDuration:0.5];
    CGRect rect = CGRectMake(circleImgView.frame.origin.x - temp, circleImgView.frame.origin.y-temp, circleImgView.frame.size.width + 2*temp, circleImgView.frame.size.height+temp*2);
    [circleImgView setFrame:rect];
    [circleImgView setAlpha:1.0f];
    
   // transForView.transform = CGAffineTransformMakeRotation(90*(M_PI/180.0f));

    [UIView commitAnimations];
}
- (void)aniSecond
{
    [UIView beginAnimations:@"ani2" context:Nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(aniThree)];
    [UIView setAnimationDuration:0.5f];
    CGRect rect = self.bounds;
    //transForView.transform = CGAffineTransformMakeRotation(180*(M_PI/180.0f));
    [circleImgView setFrame:rect];
    [circleImgView setAlpha:0.5f];
    [UIView commitAnimations];
}

- (void)aniThree
{
    [UIView beginAnimations:@"ani3" context:Nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(aniStop)];
    [UIView setAnimationDuration:0.8f];
    CGRect rect = self.bounds;
    [circleImgView setFrame:rect];
    [circleImgView setAlpha:0.1f];
    //transForView.transform = CGAffineTransformMakeRotation(360*(M_PI/180.0f));
    [UIView commitAnimations];
    
}

- (void)aniStop
{
    
    [self removeFromSuperview];

}

- (void)dealloc
{

    [super dealloc];
}
@end
