//
//  ErrorAlerView.m
//  NOMU
//
//  Created by 何兵 on 15/1/30.
//  Copyright (c) 2015年 movnow. All rights reserved.
//

#import "ErrorAlerView.h"

@interface ErrorAlerView ()
{
    BOOL _lock;
}

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIImageView *imgv;

@end

@implementation ErrorAlerView

+(void)showWithMessage:(NSString *)message sucOrFail:(BOOL)abool
{
    ErrorAlerView *alert = [ErrorAlerView sharedInstance];
    alert.label.text = message;
    if (abool) {
        alert.imgv.image = [UIImage imageNamed:@"CW_success_tips.png"];
    } else {
        alert.imgv.image = [UIImage imageNamed:@"CW_failure_tips.png"];
    }
    [alert show];
}


+(ErrorAlerView *)sharedInstance
{
    static ErrorAlerView *simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simple=[[ErrorAlerView alloc] init];
    });
    return simple;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width
                                 -200)/2, 180, 200, 140);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 190, 90)];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.numberOfLines = 0;
        
        self.imgv = [[UIImageView alloc] initWithFrame:CGRectMake(80, 15, 40, 40)];
        [self addSubview:self.label];
        [self addSubview:self.imgv];
        
        self.alpha = 0;
        
    }
    return self;
}

-(void)show
{
    if (!_lock) {
        _lock = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(hidd) withObject:nil afterDelay:1];
        }];
    }
}

-(void)hidd
{
   
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _lock = NO;
    }];
}

@end
