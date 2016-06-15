//
//  FirstBindViewCtrl.m
//  Care_2
//
//  Created by L-Q on 15/5/30.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "FirstBindViewCtrl.h"

@interface FirstBindViewCtrl (){


    __weak IBOutlet UITextField *simIDField;

    __weak IBOutlet UITextField *nameField;

    __weak IBOutlet UITextField *heightField;

    __weak IBOutlet UITextField *weightField;
    
    
    __weak IBOutlet UIButton *saveBtn;
    
    
    __weak IBOutlet UISegmentedControl *genderControl;
    

}

@end

@implementation FirstBindViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)genderChange:(id)sender {
}




- (IBAction)saveBtnClick:(UIButton *)sender {
    
    
    
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
