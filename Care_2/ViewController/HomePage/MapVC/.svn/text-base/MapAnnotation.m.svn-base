//
//  MapAnnotation.m
//  Q2_local
//
//  Created by HelloWorld on 14-7-16.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "MapAnnotation.h"
#import "MD5.h"

@implementation MapAnnotation

- (instancetype)initWithTitle:(NSString *)title Coordinate2D:(CLLocationCoordinate2D)tempCoordinate2D {
    self = [super init];
    if (self) {
        _title = title;
        _coordinate2D = tempCoordinate2D;
    }
    
    return self;
}
- (CLLocationCoordinate2D)coordinate {
    return _coordinate2D;
}

@end




@implementation MKAnnotationView (Bubble)

-(void)setNeedsDisplay {
    [super setNeedsDisplay];
    
    self.clipsToBounds = NO;
    
    //头像
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 32, 32)];
    imgView.layer.cornerRadius = 10;
    imgView.layer.masksToBounds = YES;
    imgView.tag = 110;
    [self addSubview:imgView];
    
    //气泡
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_around_map_bubbleBox"]];
        if (![MD5 isChina]) {
             imgView.frame = CGRectMake(44, 4, 200, 75);
        }else{
        
           imgView.frame = CGRectMake(44, 4, 180, 55);

        }

        imgView.tag = 100;
        [self addSubview:imgView];
        
        UILabel *lb = [[UILabel alloc]init];

        if (![MD5 isChina]) {
            lb.frame = CGRectMake(10, 2, 190, 65);
        }else{
            lb.frame = CGRectMake(10, 2, 170, 50);
        }
        lb.font = [UIFont systemFontOfSize:10];
        lb.textColor = [UIColor whiteColor];
        lb.numberOfLines = 0;
        lb.tag = 200;
        lb.text = NSLocalizedString(@"加载中...", nil);
        [imgView addSubview:lb];
        imgView.hidden = YES;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    //点击显示隐藏气泡
    UIView *v = [self viewWithTag:100];
    v.hidden = !v.hidden;
}

-(void)setAvatar:(UIImage *)avatar {
    UIImageView *imgView = (UIImageView *)[self viewWithTag:110];
    imgView.image = avatar;
}
-(void)setContent:(NSString *)content {
    UILabel *lb = (UILabel *)[[self viewWithTag:100] viewWithTag:200];
    lb.text = content;
}
-(void)setContentHide:(BOOL)hide {
    [self viewWithTag:100].hidden = hide;
}

@end

