//
//  CallPhoneViewController.m
//  Care_2
//
//  Created by xiaobing on 15/5/12.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "CallPhoneViewController.h"
#import "UserData.h"
@interface CallPhoneViewController ()
{

    __weak IBOutlet UIImageView *headImage;


    __weak IBOutlet UIButton *phoneBtn;
    
    __weak IBOutlet UILabel *hangUpLabel;
}
@end

@implementation CallPhoneViewController


- (IBAction)hangUpBtnClick:(id)sender {
    NSLog(@"挂断");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"通话", nil);
    [self setBackButton];
  
    [self setRightButton];
}

-(void)setRightButton {
    
    
    NSString *stringWidth = [UserData Instance].nickName;
   // CGFloat strW = _StringWidth(stringWidth);
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 2, 44, 44);
    [submitButton setImage:[UIImage imageNamed:@"nav_btn_drop-down"] forState:UIControlStateNormal];
    [submitButton setImage:[UIImage imageNamed:@"nav_btn_drop-down-_pre"] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    submitButton.imageEdgeInsets = (UIEdgeInsets){0,16,0,-16};
   
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(18, -10, 40, 45)];
    lb.text = stringWidth;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont boldSystemFontOfSize:14];
    lb.textColor = _Color_font1;
    [submitButton addSubview:lb];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];           
}
- (void)rightBtnClick
{

    NSLog(@"右按钮点击");

}




_Method_SetBackButton(nil, NO)
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
