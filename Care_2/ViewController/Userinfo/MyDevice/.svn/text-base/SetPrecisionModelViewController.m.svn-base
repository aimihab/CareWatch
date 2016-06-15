//
//  SetSituationalModelViewController.m
//  Care_2
//
//  Created by L-Q on 15/7/2.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "SetPrecisionModelViewController.h"

@interface SetPrecisionModelViewController (){

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

@implementation SetPrecisionModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"定位模式", nil);
    [self setBackButton];
    [self refreshUI];
    
    
    if (_devObj.locationType == 0) {
        selectImg1.hidden = NO;
        selectImg2.hidden = YES;
    }else if (_devObj.locationType == 1){

        selectImg2.hidden = NO;
        selectImg1.hidden = YES;
    }
    
    
    
}
_Method_SetBackButton(nil, NO)


#pragma mark - 本地化UI
- (void)refreshUI{

    defaultModeLabel.text = NSLocalizedString(@"普通模式", nil);
    infoLabel1.text = NSLocalizedString(@"默认模式,省电", nil);
    
    quiteModeLabel.text = NSLocalizedString(@"高精度模式", nil);
    infoLabel2.text = NSLocalizedString(@"高精准定位,耗电量大", nil);
    
    
}


- (IBAction)defaultBtnClick:(UIButton *)sender {
    
    if (selectImg1.hidden == YES ) {
        
        selectImg1.hidden = NO;
        selectImg2.hidden = YES;
        _devObj.locationType = 0;
        
    }
    
}


- (IBAction)quiteBtnClick:(UIButton *)sender {
    
    if (selectImg2.hidden == YES){
        
        selectImg2.hidden = NO;
        selectImg1.hidden = YES;
        _devObj.locationType = 1;
        
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
