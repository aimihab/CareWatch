//
//  ModifyUserName_ViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-8.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "SetDeviceDetail_ViewController.h"
#import "MD5.h"
#import "AppDelegate.h"
#import "CustomPickerView.h"
@interface SetDeviceDetail_ViewController () {
    
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UILabel *msgLabel;
    
 
    __weak IBOutlet UITextField *heightTextField;
    __weak IBOutlet UITextField *weightTextField;
    
    __weak IBOutlet UITextField *SIMIDTextField;
  
    NSMutableDictionary *deviceDic;
}

/**
 *  性别标签
 */
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

//性别选择按钮
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegmentedBtn;


/**
 *  体重选择视图
 */
@property (nonatomic,strong) CustomPickerView *UWeightPickView;
/**
 *  身高选择视图
 */
@property (nonatomic,strong) CustomPickerView *UHeightPickView;

/**
 *  身高确定按钮
 */
@property (strong, nonatomic) IBOutlet UIToolbar *heightDone;

/**
 *
 *
 *  体重确定按钮
 **/
@property (strong, nonatomic) IBOutlet UIToolbar *weightDone;


@end

@implementation SetDeviceDetail_ViewController

#pragma - mark 体重pickView
- (CustomPickerView *)UWeightPickView
{
    if (_UWeightPickView == nil) {
        NSMutableArray *defaultWeightArr = [NSMutableArray array];
        NSString *defaultWeight = nil;
        
        
       
            for (NSInteger i = 10; i <= 99; i ++) {
                [defaultWeightArr addObject:[NSString stringWithFormat:@"%d kg",i]];
            }
            defaultWeight = @"20";
        
        _UWeightPickView = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 50, WIDTH(self.view), 200) andDataArr:defaultWeightArr];
        _UWeightPickView.value = defaultWeight;
    }
    return _UWeightPickView;
}

#pragma -mark 身高pickView
- (CustomPickerView *)UHeightPickView
{
    if (_UHeightPickView == nil) {
        NSMutableArray *defaultHeightArr = [NSMutableArray array];
        NSString *defaultHeight = nil;
        
        //判断当前是否是英制
       
            for (NSInteger i = 50; i <= 200; i ++) {
                [defaultHeightArr addObject:[NSString stringWithFormat:@"%d cm",i]];
            }
            defaultHeight = @"70";
        _UHeightPickView = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 50,WIDTH(self.view), 200) andDataArr:defaultHeightArr];
        _UHeightPickView.value = defaultHeight;
       
    }
    return _UHeightPickView;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"详细信息设置", nil);
    [self setBackButton];
    [self setSubmitButton];
    [self setInputView];
    
  //  self.navigationController.navigationBar.translucent = NO;
   // userNameTextField.text = [self.obj valueForKey:@"nickName"];
  //  SIMIDTextField.text = [self.obj valueForKey:@"phoneNumber"];
    
    NSLog(@"self.dev.devHeiht = %@",self.dev.devHeight);
    NSLog(@"self.dev.devWeight = %@",self.dev.devWeight);

    userNameTextField.text = self.dev.nickName;
    heightTextField.text = self.dev.devHeight;
    weightTextField.text = self.dev.devWeight;
    SIMIDTextField.text = self.dev.phoneNumber;
    _sexSegmentedBtn.selectedSegmentIndex =  self.dev.devSex;
  
    
    msgLabel.text = NSLocalizedString(@"只能是1-8个汉字、字母、数字、或随意组合", nil);
    NSLog(@"self.view.frame = %@",NSStringFromCGRect(self.view.frame));
    
    deviceDic  = [NSMutableDictionary dictionary];
    [self localizedText];//本地化文字
}


- (void)localizedText
{
    userNameTextField.placeholder = NSLocalizedString(@"请输入宝贝的名称", nil);
    heightTextField.placeholder = NSLocalizedString(@"请输入宝贝的身高", nil);
    weightTextField.placeholder = NSLocalizedString(@"请输入宝贝的体重", nil);
    SIMIDTextField.placeholder = NSLocalizedString(@"请输入设备的SIM卡号", nil);
    self.sexLabel.text = NSLocalizedString(@"性别:", nil);
    
    [self.sexSegmentedBtn setTitle:NSLocalizedString(@"男", nil) forSegmentAtIndex:0];
    [self.sexSegmentedBtn setTitle:NSLocalizedString(@"女", nil) forSegmentAtIndex:1];
}

- (void)setInputView
{
    UIBarButtonItem *Done1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClick:)];
    Done1.tag = 12;
    self.heightDone.items = [NSArray arrayWithObject:Done1];
    
    UIBarButtonItem *Done2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClick:)];
    Done2.tag = 13;
    self.weightDone.items = [NSArray arrayWithObject:Done2];

    heightTextField.inputView = self.UHeightPickView;
    heightTextField.inputAccessoryView = self.heightDone;
    weightTextField.inputView = self.UWeightPickView;
    weightTextField.inputAccessoryView = self.weightDone;
}

- (void)doneClick: (UIBarButtonItem *)sender
{
    switch (sender.tag) {
        case 12:
        {
            heightTextField.text = self.UHeightPickView.value;
            
        }
            break;
        case 13:
        {
            weightTextField.text = self.UWeightPickView.value;
           
        }
            break;
        default:
            break;
    }
    [self touchesBegan:nil withEvent:nil];

}


-(void)viewDidAppear:(BOOL)animated {
   [userNameTextField becomeFirstResponder];
//    [heightTextField becomeFirstResponder];
//    [weightTextField becomeFirstResponder];
   // [SIMIDTextField becomeFirstResponder];
}

//_Method_textFieldEvent(@[userNameTextField])
//_Method_textFieldEvent(@[heightTextField])
//_Method_textFieldEvent(@[weightTextField])
//_Method_textFieldEvent(@[userNameTextField])
_Method_SetBackButton(nil, NO)
_Method_SetSubmitButton(NSLocalizedString(@"保存", nil), (@selector(onSaveButtonPressed)), _StringWidth(NSLocalizedString(@"保存", nil)))

-(void)onSaveButtonPressed {
    [self touchesBegan:nil withEvent:nil];
    
    if ([userNameTextField.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"宝贝名称不能为空", nil)];
        [alertView show];
        return;
    }

    
//    if (![MD5 checkPhoneNumInput:SIMIDTextField.text])
//    {
//        CustomIOS7AlertView *aletView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"o0", nil)];
//        [aletView show];
//        return;
//    
//    }
    
    if(![MD5 isPureInt:SIMIDTextField.text]){
    
        CustomIOS7AlertView *alerView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入正确的详细信息", nil)];
        [alerView show];
        return;
    }
    
    
//    只能是1-8个汉字、字母、数字、或随意组合
    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        if (userNameTextField.text.length > 8) {
            CustomIOS7AlertView *alerView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message: NSLocalizedString(@"昵称不能超过8个字符，请重新输入", nil)];
            [alerView show];
            return;
        }
    }
    
    
 
    self.dev.phoneNumber = SIMIDTextField.text;
    self.dev.nickName = userNameTextField.text;
    self.dev.devHeight = heightTextField.text;
    self.dev.devWeight = weightTextField.text;
    
    NSLog(@"self.dev.devHeiht = %@", self.dev.devHeight);
    NSLog(@"self.dev.devWeight = %@", self.dev.devWeight);

  
    [[UserData Instance]saveCustomObject:[UserData Instance]];

    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"保存成功", nil)];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView show];
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
    [self.view endEditing:YES];
    }
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField setBackground:[UIImage imageNamed:@"02_textField_long_selected"]];
    
    if (textField == SIMIDTextField ||textField == weightTextField)
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.view.frame;
            rect.origin.y = 0;
            self.view.frame = rect;
        }];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField setBackground:[UIImage imageNamed:@"02_textField_long"]];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
   

    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = 64;
        
        self.view.frame = rect;
    }];
    
     [textField resignFirstResponder];
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length) {
        return YES;
    }
    
    char ch = [string characterAtIndex:0];
    if (3==strlen([string UTF8String])
        || ((ch > 47)&&(ch < 58))
        || ((ch > 64)&&(ch < 91))
        || ((ch > 96)&&(ch < 123))){
    } else {
        //特殊字符不给输入
        return NO;
    }
    
    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
//        if ([textField.text length]  >= 8) {
//            return NO;
//        }

    }else{
        if ([textField.text length]  >= 20) {
            return NO;
        }
    }
    
    return YES;
}

-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}

//选择性别
- (IBAction)genderSelect:(id)sender {
    
    self.dev.devSex = _sexSegmentedBtn.selectedSegmentIndex;
    
}




@end
