//
//  MNAdaptAlertView.h
//  MNAdaptAlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@interface MNAdaptAlertView : UIView

typedef void (^onButtonTouchUpInside)(MNAdaptAlertView *alertView, int buttonIndex);

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property (nonatomic, retain) UIView *buttonView;    // Buttons on the bottom of the dialog
@property (nonatomic,retain) UITextField *textField;

@property (nonatomic, assign) BOOL useMotionEffects;

- (void)show;

-(id)initStyleZeroWithMessage:(NSString *)message andBlock:(onButtonTouchUpInside)block;
-(id)initStyleTextFieldWithBlock:(onButtonTouchUpInside)block;
-(id)initStyleWithMessage:(NSString *)message andBlock:(onButtonTouchUpInside)block;
-(id)initStyleShareMicroBlogAndWeiChatWithBlock:(onButtonTouchUpInside)block;
-(id)initStyleShareFacebookAndTwitterWithBlock:(onButtonTouchUpInside)block;
//*************

@end
