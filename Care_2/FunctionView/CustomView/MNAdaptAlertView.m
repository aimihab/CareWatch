//
//  MNAdaptAlertView.m
//  MNAdaptAlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import "MNAdaptAlertView.h"
#import <QuartzCore/QuartzCore.h>

const static CGFloat kCustomIOS7AlertViewCornerRadius              = 0;
const static CGFloat kCustomIOS7MotionEffectExtent                 = 10.0;
@interface MNAdaptAlertView ()
{
    onButtonTouchUpInside _block;
    BOOL isShare;
}

@end

@implementation MNAdaptAlertView

CGFloat buttonH = 0;
CGFloat buttonSpacerH = 0;

@synthesize parentView, containerView, dialogView, buttonView, textField;
@synthesize useMotionEffects;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        self.parentView = _parentView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

        useMotionEffects = false;
//        buttonTitles = @[@"Close"];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

// Create the dialog view, and animate opening the dialog
- (void)show
{
    dialogView = [self createContainerView];
  
    dialogView.layer.shouldRasterize = YES;
    dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
  
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

#if (defined(__IPHONE_7_0))
    if (useMotionEffects) {
        [self applyMotionEffects];
    }
#endif

    dialogView.layer.opacity = 0.5f;
    dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    [self addSubview:dialogView];

    // Can be attached to a view or to the top most window
    // Attached to a view:
    if (parentView != NULL) {
        [parentView addSubview:self];

    // Attached to the top most window (make sure we are using the right orientation):
    } else {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;

            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;

            default:
                break;
        }

        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }

    dialogView.alpha = 0;
    [UIView animateWithDuration:0.23 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
                         dialogView.alpha = 1;
                         dialogView.layer.opacity = 1.0f;
                         dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
					 }
					 completion:NULL
     ];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackground:)];
    [self addGestureRecognizer:tap];
}

-(void)clickBackground:(UITapGestureRecognizer *)tap {
    CGPoint p = [tap locationInView:dialogView];
    
    CGFloat x = dialogView.bounds.origin.x;
    CGFloat y = dialogView.bounds.origin.y;
    CGFloat w = dialogView.bounds.size.width;
    CGFloat h = dialogView.bounds.size.height;
    if (!(p.x>x && p.x<x+w && p.y>y && p.y<y+h) && isShare) {
        [self close];
    }
}


// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
    CATransform3D currentTransform = dialogView.layer.transform;

    CGFloat startRotation = [[dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);

    dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    dialogView.layer.opacity = 1.0f;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         dialogView.layer.opacity = 0.0f;
					 }
					 completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
					 }
	 ];
    
    for (UIGestureRecognizer *g in self.gestureRecognizers) {
        [self removeGestureRecognizer:g];
    }
}

- (void)setSubView: (UIView *)subView
{
    containerView = subView;
}

// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createContainerView
{
    if (containerView == NULL) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    }

    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];

    // For the black background
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];

    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];

    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       nil];

    CGFloat cornerRadius = kCustomIOS7AlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];

    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;

    // Add the custom container if there is any
    [dialogContainer addSubview:containerView];
    dialogContainer.layer.cornerRadius = 5;
    dialogContainer.layer.masksToBounds = YES;
    
    // Add the buttons too
    
    return dialogContainer;
}

// Helper function: count and return the dialog's size
- (CGSize)countDialogSize
{
    CGFloat dialogWidth = containerView.frame.size.width;
    CGFloat dialogHeight = containerView.frame.size.height-2;

    return CGSizeMake(dialogWidth, dialogHeight);
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = screenWidth;
        screenWidth = screenHeight;
        screenHeight = tmp;
    }

    return CGSizeMake(screenWidth, screenHeight);
}

#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }

    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);

    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);

    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];

    [dialogView addMotionEffect:motionEffectGroup];
}
#endif

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    // If dialog is attached to the parent view, it probably wants to handle the orientation change itself
    if (parentView != NULL) {
        return;
    }

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;

    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;

        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;

        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;

        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.transform = rotation;
					 }
					 completion:^(BOOL finished){
                         // fix errors caused by being rotated one too many times
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             UIInterfaceOrientation endInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                             if (interfaceOrientation != endInterfaceOrientation) {
                                 // TODO user moved phone again before than animation ended: rotation animation can introduce errors here
                             }
                         });
                     }
	 ];

}

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
    
}


//*******************
-(id)initStyleZeroWithMessage:(NSString *)message andBlock:(onButtonTouchUpInside)block
{
    self = [self init];
    if (self) {
        _block = [block copy];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 180)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
        [imageView setImage:[UIImage imageNamed:IMAGE_NAME(@"pop_background")]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 8, containerView.bounds.size.width-30, 20)];
        titleLabel.textColor = NAV_TEXT_COLOR;
        titleLabel.font = TITLE_FONT;
        titleLabel.text = NSLocalizedString(@"提醒", nil);
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width-30, 55)];
        messageLabel.center = CGPointMake(containerView.bounds.size.width/2 + 8, 75);
        messageLabel.textColor = NAV_TEXT_COLOR;
        messageLabel.font = TITLE_FONT;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.text = message;
        
        UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        contentBtn.frame = CGRectMake(0, 0, 170, 35);
        contentBtn.center = CGPointMake(containerView.bounds.size.width/2, 135);
        contentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [contentBtn setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
        [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_long")] forState:UIControlStateNormal];
        [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_long_press")] forState:UIControlStateHighlighted];
        contentBtn.tag = 0;
        [contentBtn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [containerView addSubview:imageView];
        [containerView addSubview:titleLabel];
        [containerView addSubview:messageLabel];
        [containerView addSubview:contentBtn];
        
        isShare = NO;
    }
    return self;
}

-(id)initStyleShareMicroBlogAndWeiChatWithBlock:(onButtonTouchUpInside)block
{
    self = [self init];
    if (self) {
        _block = [block copy];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 180)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
        [imageView setImage:[UIImage imageNamed:IMAGE_NAME(@"pop_background")]];
        [containerView addSubview:imageView];
       
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, containerView.bounds.size.width-30, 20)];
        titleLabel.textColor = NAV_TEXT_COLOR;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = NSLocalizedString(@"分享到",nil);
        [containerView addSubview:titleLabel];
        
        for (int i=0; i<2; i++) {
            UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            contentBtn.frame = CGRectMake(0, 0, 60, 60);
            contentBtn.center = CGPointMake(containerView.bounds.size.width/2+(i ? 45:-45), 90);
            contentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [contentBtn setTitleColor:[UIColor colorWithHexString:@"#2f5774"] forState:UIControlStateNormal];
            [contentBtn setTitleColor:[UIColor colorWithHexString:@"#f68127"] forState:UIControlStateHighlighted];
            contentBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
            [contentBtn setTitleEdgeInsets:(UIEdgeInsets){100,0,0,0}];
            contentBtn.tag = i;
            
            if (i) {
                [contentBtn setTitle:NSLocalizedString(@"微信",nil) forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_weixin_btn")] forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_weixin_btn_press")] forState:UIControlStateHighlighted];
            } else {
                [contentBtn setTitle:NSLocalizedString(@"微博",nil) forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_weibo_btn")] forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_weibo_btn_press")] forState:UIControlStateHighlighted];
            }
            
            [contentBtn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:contentBtn];
        }
        
        isShare = YES;
    }
    return self;
}

-(id)initStyleWithMessage:(NSString *)message andBlock:(onButtonTouchUpInside)block
{
    self = [self init];
    if (self) {
        _block = [block copy];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 180)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
        [imageView setImage:[UIImage imageNamed:IMAGE_NAME(@"pop_background")]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, containerView.bounds.size.width, 20)];
        titleLabel.textColor = NAV_TEXT_COLOR;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = NSLocalizedString(@"提醒", nil);
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width, 70)];
        messageLabel.center = containerView.center;
        messageLabel.textColor = NAV_TEXT_COLOR;
        messageLabel.font = TITLE_FONT;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.text = message;
        
        [containerView addSubview:imageView];
        [containerView addSubview:titleLabel];
        [containerView addSubview:messageLabel];
        
        for (int i=0; i<2; i++) {
            UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            contentBtn.frame = CGRectMake(24+130*i, 130, 78, 30);
            contentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            contentBtn.tag = i;
            [contentBtn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            
            if (!i) {
                [contentBtn setTitleColor:NAV_TEXT_COLOR forState:UIControlStateNormal];
                [contentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [contentBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_cancel")] forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_cancel&confirm_press")] forState:UIControlStateHighlighted];
            } else {
                [contentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [contentBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_confirm")] forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_cancel&confirm_press")] forState:UIControlStateHighlighted];
            }
            
            [containerView addSubview:contentBtn];
        }
        isShare = NO;
    }
    return self;
}

-(id)initStyleTextFieldWithBlock:(onButtonTouchUpInside )block
{
    self = [self init];
    if (self) {
        _block = [block copy];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 180)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
        [imageView setImage:[UIImage imageNamed:IMAGE_NAME(@"pop_background")]];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 58, containerView.bounds.size.width-32, 40)];
        imageview.image = [UIImage imageNamed:IMAGE_NAME(@"pop_textfield_background")];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 58, containerView.bounds.size.width-40, 40)];
        
        [containerView addSubview:imageView];
        [containerView addSubview:imageview];
        [containerView addSubview:textField];
        
        for (int i=0; i<2; i++) {
            UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            contentBtn.frame = CGRectMake(72+88*i, 130, 78, 30);
            contentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            contentBtn.tag = i;
            [contentBtn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            
            if (!i) {
                [contentBtn setTitleColor:NAV_TEXT_COLOR forState:UIControlStateNormal];
                [contentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [contentBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_cancel")] forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_cancel&confirm_press")] forState:UIControlStateHighlighted];
            } else {
                [contentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [contentBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_confirm")] forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_btn_cancel&confirm_press")] forState:UIControlStateHighlighted];
            }
            
            [containerView addSubview:contentBtn];
        }
        
        isShare = YES;
    }
    return self;

}

-(id)initStyleShareFacebookAndTwitterWithBlock:(onButtonTouchUpInside)block
{
    self = [self init];
    if (self) {
        _block = [block copy];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 180)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
        [imageView setImage:[UIImage imageNamed:IMAGE_NAME(@"pop_background")]];
        [containerView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, containerView.bounds.size.width-30, 20)];
        titleLabel.textColor = NAV_TEXT_COLOR;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = NSLocalizedString(@"分享到",nil);
        [containerView addSubview:titleLabel];
        
        for (int i=0; i<2; i++) {
            UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            contentBtn.frame = CGRectMake(0, 0, 70, 70);
            contentBtn.center = CGPointMake(containerView.bounds.size.width/2+(i ? 50:-50), 90);
            contentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [contentBtn setTitleColor:[UIColor colorWithHexString:@"#2f5774"] forState:UIControlStateNormal];
            [contentBtn setTitleColor:[UIColor colorWithHexString:@"#f68127"] forState:UIControlStateHighlighted];
            contentBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
            [contentBtn setTitleEdgeInsets:(UIEdgeInsets){100,0,0,0}];
            contentBtn.tag = i;
            
            if (i) {
                [contentBtn setTitle:NSLocalizedString(@"Twitter",nil) forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_twitter_btn")] forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_twitter_btn_press")] forState:UIControlStateHighlighted];
            } else {
                [contentBtn setTitle:NSLocalizedString(@"Facebook",nil) forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_facebook_btn")] forState:UIControlStateNormal];
                [contentBtn setBackgroundImage:[UIImage imageNamed:IMAGE_NAME(@"pop_facebook_btn_press")] forState:UIControlStateHighlighted];
            }
            
            [contentBtn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:contentBtn];
        }
        isShare = YES;
    }
    return self;
}


- (void)customIOS7dialogButtonTouchUpInside:(UIButton *)sender
{
    if (_block) {
        _block(self,(int)sender.tag);
    }
    [self close];
}

@end
