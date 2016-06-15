//
//  ConnetBlueAnimationCircle.h
//  Care_2
//
//  Created by xiaobing on 15/5/28.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnetBlueAnimationCircle : UIView
{

    UIImageView *circleImgView;
    
    UIImageView *transForView;
    
    CGFloat ange;
    
}

- (void)stratAnimation;

- (void)aniStop;
@end
