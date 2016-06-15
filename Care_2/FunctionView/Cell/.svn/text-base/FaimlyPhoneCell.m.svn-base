//
//  FaimlyPhoneCell.m
//  Care_2
//
//  Created by xiaobing on 15/5/22.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "FaimlyPhoneCell.h"

@implementation FaimlyPhoneCell
{

    __weak IBOutlet UILabel *nameLabel;

   
    PhoneCellClick _block;
   
}
- (IBAction)detagateNumber:(id)sender {
    
    _block(self);
    
}

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellContent:(NSDictionary *)dic
{
    nameLabel.text = dic[@"name"];
    
    NSMutableString *string = [NSMutableString stringWithString:dic[@"number"]];
    if (string != nil || (![string isEqualToString:@""]&&string.length > 10)){
        [string insertString:@" " atIndex:3];
        [string insertString:@" " atIndex:8];
    }
    
   _phoneNumberText.text = string;
    
}
-(void)setCellBtnClickBlock:(PhoneCellClick)block{
    
    _block = [block copy];
}
@end
