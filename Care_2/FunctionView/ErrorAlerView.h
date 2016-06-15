//
//  ErrorAlerView.h
//  NOMU
//
//  Created by 何兵 on 15/1/30.
//  Copyright (c) 2015年 movnow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorAlerView : UIView

+(void)showWithMessage:(NSString *)message sucOrFail:(BOOL)abool;

@end
