//
//  SetSituationalModelViewController.m
//  Care_2
//
//  Created by L-Q on 15/7/2.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "SetSituationalModelViewController.h"

@interface SetSituationalModelViewController (){

    __weak IBOutlet UILabel *defaultModeLabel;
    __weak IBOutlet UILabel *infoLabel1;


    __weak IBOutlet UILabel *quiteModeLabel;
    __weak IBOutlet UILabel *infoLabel2;

    __weak IBOutlet UIButton *defaultBtn;
    __weak IBOutlet UIButton *quiteBtn;
    
    __weak IBOutlet UIImageView *selectImg1;
    __weak IBOutlet UIImageView *selectImg2;

    
    
}

@end

@implementation SetSituationalModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"情景模式", nil);
    [self setBackButton];
    [self refreshUI];
    
    
    if (_devObj.modeType == 0) {
        selectImg1.hidden = NO;
        selectImg2.hidden = YES;
    }else if (_devObj.modeType == 1){

        selectImg2.hidden = NO;
        selectImg1.hidden = YES;
    }
    
    
    
}
_Method_SetBackButton(nil, NO)


#pragma mark - 本地化UI
- (void)refreshUI{

    defaultModeLabel.text = NSLocalizedString(@"标准模式", nil);
    infoLabel1.text = NSLocalizedString(@"设备在开机之后来电、闹钟、提醒时候有铃声", nil);
    
    quiteModeLabel.text = NSLocalizedString(@"静音模式", nil);
    infoLabel2.text = NSLocalizedString(@"设备在开机之后来电、闹钟、提醒时候没有铃声", nil);
    
    
}


- (IBAction)defaultBtnClick:(UIButton *)sender {
    
    if (selectImg1.hidden == YES ) {
        
        selectImg1.hidden = NO;
        selectImg2.hidden = YES;
        _devObj.modeType = 0;
        
    }
    
}


- (IBAction)quiteBtnClick:(UIButton *)sender {
    
    if (selectImg2.hidden == YES){
        
        selectImg2.hidden = NO;
        selectImg1.hidden = YES;
        _devObj.modeType = 1;
        
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
