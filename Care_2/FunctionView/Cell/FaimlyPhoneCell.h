//
//  FaimlyPhoneCell.h
//  Care_2
//
//  Created by xiaobing on 15/5/22.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellTextField.h"
typedef void(^PhoneCellClick) (UITableViewCell *);
@interface FaimlyPhoneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;
@property (weak, nonatomic) IBOutlet CellTextField *phoneNumberText;

@property (weak, nonatomic) IBOutlet UIButton *delegateNumberBtn;




- (void)setCellContent:(NSDictionary *)dic;

- (void)setCellBtnClickBlock:(PhoneCellClick)block;
@end
