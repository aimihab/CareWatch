//
//  DeviceSetting_TableViewController.m
//  Q2_local
//
//  Created by JIA on 14-7-9.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "DeviceSetting_TableViewController.h"
#import "MusicList_TableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NetManger.h"
#import "AppDelegate.h"
#import "SetPhoneNumberTableViewController.h"
#import "SetSituationalModelViewController.h"
#import "SetPrecisionModelViewController.h"
#import "ErrorAlerView.h"

@interface DeviceSetting_TableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    IBOutlet UIView *avatarView;
    UIImageView *avatarImageView;
    
    UITableView *_tableView;
    NSArray *itemTitleArray;
    
    ASIHTTPRequest *req;
    ASIHTTPRequest *req1;
    ASIHTTPRequest *req2;
}
- (IBAction)onSelectAvatarButtonPressed:(UIButton *)sender;
- (IBAction)onTakeAPictureButtonPressed:(UIButton *)sender;
- (IBAction)onSelectTheLocalPictureButtonPressed:(UIButton *)sender;
- (IBAction)onCancelButtonPressed:(UIButton *)bt;
@end

@implementation DeviceSetting_TableViewController

- (void)dealloc
{
    [req clearDelegatesAndCancel];
    [req1 clearDelegatesAndCancel];
    [req2 clearDelegatesAndCancel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设备定义", nil);
    [self setBackButton];
    
    _tableView = (UITableView *)self.view;
    _tableView.bounces = NO;
    _tableView.backgroundColor = _Color_background;
    
    if (self.navigationController.viewControllers.count < 4 || self.isAdd == YES) {  //添加设备
        NSLog(@"--------%@", self.tempEqphone);
        self.devObj = [[DeviceModel alloc] initWithName:@"" phone:@"" imei:@"" bleMac:@""withUrl:@""];
        [self setSubmitButton];
    } else {                                                    //设备定义
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(15, 10, 290, 40);
        bt.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [bt setTitle:NSLocalizedString(@"删除设备", nil) forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageNamed:@"03_set_btn_long"] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageNamed:@"03_set_btn_long_selected"] forState:UIControlStateHighlighted];
        [bt addTarget:self action:@selector(removeDevice) forControlEvents:UIControlEventTouchUpInside];
        [tableFooterView addSubview:bt];
        _tableView.tableFooterView = tableFooterView;
    }
    
    itemTitleArray = @[NSLocalizedString(@"设备ID号", nil),
                       NSLocalizedString(@"设备IMEI号", nil),
                       NSLocalizedString(@"头像", nil),
                       NSLocalizedString(@"预警声音", nil),
                       NSLocalizedString(@"设备详细信息", nil),
                       NSLocalizedString(@"设置亲情号码", nil),
                       NSLocalizedString(@"设备关机", nil),
                       NSLocalizedString(@"情景模式", nil),
                       NSLocalizedString(@"定位模式", nil),
                       NSLocalizedString(@"低电量提醒", nil)];
    
    [avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBackgroundHideSheet:)]];
    avatarView.alpha = 0;
    avatarView.hidden = YES;
    [self.navigationController.view addSubview:avatarView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [_tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{

    self.isAdd = NO;
}
_Method_SetBackButton({
    
    if(!self.isAdd)
    {
        [self requestDeviceBind];
    
    }
    if(self.navigationController.viewControllers.count < 4) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [[UserData Instance] saveCustomObject:[UserData Instance]];
}, YES)

-(void)removeDevice {
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleThreeWithTitle:NSLocalizedString(@"提醒", nil) message:NSLocalizedString(@"删除当前设备，走吧平台将不能提供服务", nil) cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitle:NSLocalizedString(@"确定", nil)];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        if (buttonIndex == 1) {
            //设备解除绑定
            NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
            [signInfo setValue:_Interface_tracker_unbind forKey:@"method"];
            [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
            [signInfo setValue:self.devObj.bindIMEI forKey:@"eqId"];
            
//            [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//            NSString *sign = [MD5 createSignWithDictionary:signInfo];
//            NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
            
            NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];

            req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
            req.delegate = self;
            req.tag = 30;
            [req startAsynchronous];
            _Code_ShowLoading
        }
    }];
    [alertView show];
}

#pragma mark - 绑定新设备保存设备基本信息操作
_Method_SetSubmitButton(NSLocalizedString(@"保存", nil), (@selector(onSubmitButtonPressed)), _StringWidth(NSLocalizedString(@"保存", nil)))

-(BOOL) onSubmitButtonPressed {
    NSString *msg;
    if ([self.devObj.nickName isEqualToString:@""]) {
        msg = NSLocalizedString(@"请填写设备名", nil);
    } else if ([self.devObj.bindIMEI isEqualToString:@""]) {
        msg = NSLocalizedString(@"请填写设备IMEI号", nil);
    }else if([self.devObj.phoneNumber isEqualToString:@""]){
    
        msg = NSLocalizedString(@"请完善设备详细信息", nil);
    }
    if (msg) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:msg];
        [alertView show];
        return NO;
    }
    
    [self requestDeviceBind];
    return YES;
}


#pragma mark - 绑定新设备,修改设备信息请求
- (void)requestDeviceBind{

    //绑定设备
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_bind forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
//    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    
    [signInfo setValue:self.tempEqphone forKey:@"uphone"];
    [signInfo setValue:self.devObj.phoneNumber forKey:@"eqphone"];
    [signInfo setValue:self.devObj.bindIMEI forKey:@"eqId"];
    [signInfo setValue:self.devObj.nickName forKey:@"title"];
    [signInfo setValue:self.devObj.avatarUrl forKey:@"pic"];
    [signInfo setValue:[NSNumber numberWithInt:self.devObj.modeType] forKey:@"eqscenemode"];
    [signInfo setValue:[NSNumber numberWithInt:self.devObj.locationType] forKey:@"gpsmode"];
    [signInfo setValue:@"" forKey:@"height"];
    [signInfo setValue:@"" forKey:@"weight"];
    [signInfo setValue:@"" forKey:@"sex"];
    
    NSLog(@"signInfo=%@",signInfo);
    
    
//    NSString *sign = [MD5 createSignWithDictionary:signInfo];
//    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    
    req1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req1 addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req1.tag = 31;
    req1.delegate = self;
    [req1 startAsynchronous];
    _Code_ShowLoading

}


#pragma mark - 手势点击背景隐藏自定义的avatarSheetView
-(void)touchBackgroundHideSheet:(UITapGestureRecognizer *)tap {
    UIView *avatarSheetView = [avatarView viewWithTag:100];
    if ([tap locationInView:tap.view].y > avatarSheetView.frame.origin.y) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        avatarSheetView.center = CGPointMake(160, 568+avatarSheetView.bounds.size.height);
        avatarSheetView.superview.alpha = 0;
    } completion:^(BOOL finished) {
        avatarSheetView.superview.hidden = YES;
    }];
}

//选择头像
- (IBAction)onSelectAvatarButtonPressed:(UIButton *)bt {
    avatarImageView.image = bt.imageView.image;
    self.devObj.avatar = UIImagePNGRepresentation(bt.imageView.image);
    [self touchBackgroundHideSheet:nil];
}
//avatarSheetView
//拍照
- (IBAction)onTakeAPictureButtonPressed:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
    [self touchBackgroundHideSheet:nil];
}
//选择本地图片
- (IBAction)onSelectTheLocalPictureButtonPressed:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
    [self touchBackgroundHideSheet:nil];
}
//取消
- (IBAction)onCancelButtonPressed:(UIButton *)bt {
    [self touchBackgroundHideSheet:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 1;
    } else if (section==1){
        return 7;
    } else {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1 && !indexPath.row) {
        return 72;
    } else if (indexPath.section == 3){
        return 60;
    } else {
        return 52;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 7)];
    v.backgroundColor = _Color_background;
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(19, 14, 150, 21)];
        lb.font = [UIFont boldSystemFontOfSize:14];
        lb.textColor = [UIColor whiteColor];
        [cell addSubview:lb];
        
        if (!indexPath.section) {                   //第一section
            lb.text = itemTitleArray[indexPath.row];
            
            UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(127, 14, 156, 21)];
            lb2.font = [UIFont boldSystemFontOfSize:14];
            lb2.textColor = [UIColor whiteColor];
            lb2.textAlignment = NSTextAlignmentRight;
            [cell addSubview:lb2];
            
            
            if (!indexPath.row) {
                [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_second_background"]]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (self.IMEIID)
                {
                    lb2.text =  self.IMEIID;
                    self.devObj.bindIMEI = self.IMEIID;
                    
                }else{
                
                     lb2.text = self.devObj.bindIMEI;
                }
               
                NSLog(@">>>>>>>>>>>>>>self.devObj.bindIMEI = %@,",self.devObj.bindIMEI);
                [_tableView reloadData];
            } else {
                if(self.navigationController.viewControllers.count<4) {
                    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_background"]]];
                    [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_background_selected"]]];
                } else {
                    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_second_background"]]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                lb2.tag = 101;
            }
        } else if (indexPath.section == 1) {    //第二section
            lb.text = itemTitleArray[indexPath.row+2];
            
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_background"]]];
            [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_background_selected"]]];
            
            if (!indexPath.row) {
                //头像
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(217, 5, 60, 60)];
                imgView.layer.borderColor = [UIColor whiteColor].CGColor;
                imgView.layer.borderWidth = _Avatar_width;
                imgView.layer.cornerRadius = 30;
                imgView.layer.masksToBounds = YES;
                imgView.image = [UIImage imageNamed:@"icon_default_head_2"];
                
                self.devObj.avatarUrl = @"icon_default_head_2";
                
                avatarImageView = imgView;
                [cell addSubview:imgView];
                lb.center = CGPointMake(lb.center.x, 25+lb.bounds.size.height/2);
            } else {
                //2,3,4,5,6,7行
                //预警声音,设备名称,设置亲情号码，设备关机,情景模式,定位模式
                UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(147, 14, 135, 21)];
                lb2.font = [UIFont boldSystemFontOfSize:14];
                lb2.textColor = [UIColor whiteColor];
                lb2.textAlignment = NSTextAlignmentRight;
                [cell addSubview:lb2];
                
                if (indexPath.row == 1) {
                    lb2.tag = 102;
                } else if(indexPath.row == 2){
                    lb2.tag = 103;
                }else if(indexPath.row == 3){
                    lb2.tag = 104;
                    if (!self.devObj.online) {
                        
                        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_background"]]];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.userInteractionEnabled = NO;
                    }

                }else if (indexPath.row == 4){
                    
                    lb2.tag = 105;
                    if (!self.devObj.online) {
                        
                        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_background"]]];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.userInteractionEnabled = NO;
                    }
                }else if (indexPath.row == 5){
                    
                    lb2.tag = 106;
                    if (!self.devObj.online) {
                        
                        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_background"]]];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.userInteractionEnabled = NO;
                    }
                    
                }else if (indexPath.row == 6){
                
                    lb2.tag = 107;
                    if (!self.devObj.online) {
                        
                        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_background"]]];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.userInteractionEnabled = NO;
                    }

                
                }
                
            }
        } else {                                //最后一section
            //低电量提醒
            lb.center = CGPointMake(lb.center.x, 18);
            lb.font = [UIFont systemFontOfSize:15];
            lb.text = itemTitleArray[indexPath.row+9];
            
            UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(19, 27, 300, 21)];
            lb2.font = [UIFont boldSystemFontOfSize:14];
            lb2.textColor = [UIColor redColor];
            lb2.text = NSLocalizedString(@"电量低于30%%以下提醒充电", nil);
            [cell addSubview:lb2];
            
            
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_second_background"]]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    UIImage *img = [UIImage imageWithData:self.devObj.avatar];
    if (img) {
        avatarImageView.image = img;
    }
    ((UILabel *)[cell viewWithTag:100]).text = self.devObj.phoneNumber;
    ((UILabel *)[cell viewWithTag:101]).text = (self.devObj.bindIMEI ? self.devObj.bindIMEI:NSLocalizedString(@"未填写", nil));
    if (self.devObj.musicItem) {
        if ([self.devObj.musicItem isKindOfClass:[MPMediaItem class]]) {
            ((UILabel *)[cell viewWithTag:102]).text = [(MPMediaItem *)self.devObj.musicItem valueForProperty:MPMediaItemPropertyTitle];
        } else if ([self.devObj.musicItem isKindOfClass:[NSDictionary class]]) {
            ((UILabel *)[cell viewWithTag:102]).text = ((NSDictionary *)self.devObj.musicItem)[@"title"];
        }
    } else {
        ((UILabel *)[cell viewWithTag:102]).text = NSLocalizedString(@"无", nil);
    }
    if (![self.devObj.nickName isEqualToString:@""]) {
        ((UILabel *)[cell viewWithTag:103]).text = self.devObj.nickName;
    }
    if (self.devObj.modeType == 0) {
        ((UILabel *)[cell viewWithTag:106]).text = NSLocalizedString(@"标准模式", nil);
    }else{
    
        ((UILabel *)[cell viewWithTag:106]).text = NSLocalizedString(@"静音模式", nil);
    }
    if (self.devObj.locationType == 0) {
        ((UILabel *)[cell viewWithTag:107]).text = NSLocalizedString(@"普通模式", nil);
    }else{
        
        ((UILabel *)[cell viewWithTag:107]).text = NSLocalizedString(@"高精度模式", nil);
    }


    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
//    if (!indexPath.section) {
//        switch (indexPath.row) {
//            case 1: {       //设备IMEI号
//                if (!_tempUphone || !_tempEqphone) {
//                    break;
//                }
//                
//                CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleTextFieldWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入设备IMEI号：", nil) text:self.devObj.bindIMEI cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitle:NSLocalizedString(@"确定", nil)];
//                [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
//                    if (buttonIndex) {
//                        UITextField *tf = (UITextField *)[alertView.containerView viewWithTag:100];
//                        if (tf.text.length == 15) {
//                            self.devObj.bindIMEI = tf.text;
//                            [_tableView reloadData];
//                        } else {
//                            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入15位的IMEI号", nil)];
//                            [alertView show];
//                        }
//                    }
//                }];
//                [alertView show];
//            }   break;
//        }
//    } else
    if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0: {       //头像
                avatarView.hidden = NO;
                [UIView animateWithDuration:0.25 animations:^{
                    avatarView.alpha = 1;
                    [avatarView viewWithTag:100].center = CGPointMake(160, [UIScreen mainScreen].bounds.size.height-[avatarView viewWithTag:100].bounds.size.height/2);
                }];
            }   break;
            case 1: {       //预警声音
                MusicList_TableViewController *musicListTVC = [[MusicList_TableViewController alloc] initWithNibName:@"MusicList_TableViewController" bundle:nil];
                musicListTVC.dev = self.devObj;
                [self.navigationController pushViewController:musicListTVC animated:YES];
            }   break;
            case 2: {       //设备详情
                SetDeviceDetail_ViewController *setDevDetailVC = [[SetDeviceDetail_ViewController alloc] initWithNibName:@"SetDeviceDetail_ViewController" bundle:nil];
                setDevDetailVC.dev = self.devObj;
                DLog(@"********nickName = %@",self.devObj.nickName);
                
                [self.navigationController pushViewController:setDevDetailVC animated:YES];
            }   break;
                
            case 3:{
                            //设置亲情号
                SetPhoneNumberTableViewController *phone = [[SetPhoneNumberTableViewController alloc] initWithNibName:@"SetPhoneNumberTableViewController" bundle:nil];
                phone.dev = self.devObj;
                [self.navigationController pushViewController:phone animated:YES];

            }
                break;
            case 4:{
            
                if (self.devObj.online && self.devObj.isAdmin == 1) {
                    
                    DLog(@"设备关机....");
                   CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleThreeWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否确定要让设备关机?", nil) cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitle:NSLocalizedString(@"确定", nil)];
                    
                    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView,int buttonIndex){
                        if (buttonIndex == 1) {
                             [self sendShutdownData]; //设备关机
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                    [alertView show];

                }else if(self.devObj.online==YES && self.devObj.isAdmin == 0){
                   
                    [ErrorAlerView showWithMessage:NSLocalizedString(@"你没有设备关机的操作权限", nil) sucOrFail:NO];
                    return;
                }else if(!self.devObj.online){
                
                    [ErrorAlerView showWithMessage:NSLocalizedString(@"对不起,设备关机不在线", nil) sucOrFail:NO];
                    return;

                }
                
                
            }
                break;
                
         case 5:{
                        //情景模式
                
                DLog(@"情景模式...");
             
             if (self.devObj.online && self.devObj.isAdmin == 0) {
                 [ErrorAlerView showWithMessage:NSLocalizedString(@"你没有情景模式的操作权限", nil) sucOrFail:NO];
                 return;
             }
             
                SetSituationalModelViewController *ModeVC = [[SetSituationalModelViewController alloc] init];
                ModeVC.devObj = self.devObj;
                [self.navigationController pushViewController:ModeVC animated:YES];
                
            }
                break;
         case 6:{
             
             
             if (self.devObj.online && self.devObj.isAdmin == 0) {
                 [ErrorAlerView showWithMessage:NSLocalizedString(@"你没有定位模式的操作权限", nil) sucOrFail:NO];
                 return;
             }
            
                        // 定位模式
             SetPrecisionModelViewController *modeVC = [[SetPrecisionModelViewController alloc] init];
             modeVC.devObj = self.devObj;
             [self.navigationController pushViewController:modeVC animated:YES];
            
            
            }
                break;
            
        }
    }
}

#pragma mark - 发送设备关机请求
- (void)sendShutdownData{

    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_shutdown forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:self.devObj.bindIMEI forKey:@"eqId"];
    [signInfo setValue:_System_Language forKey:@"locale"];
    [signInfo setValue:@"1" forKey:@"controlType"];
    
    
//    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//    NSString *sign = [MD5 createSignWithDictionary:signInfo];
//    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    
    req2 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req2 addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req2.delegate = self;
    req2.tag = 32;
    [req2 startAsynchronous];
    _Code_ShowLoading
}


#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage  *img = [info objectForKey:UIImagePickerControllerEditedImage];
        self.devObj.avatar = UIImageJPEGRepresentation(img, 0.5);
    } else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        NSString *imagePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.devObj.avatar = [NSData dataWithContentsOfFile:imagePath];
    }
    
    NetManger *net=[[NetManger alloc] init];
    [net uploadFile:self.devObj.avatar withType:self.devObj.bindIMEI];
    [net setUploadFileSuc:^(NSString *url) {
        self.devObj.avatarUrl=url;
    }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        avatarImageView.image = [UIImage imageWithData:self.devObj.avatar];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    _Code_HTTPResponseCheck(jsonDic, {
        if (request.tag == 30) {
            
            NSLog(@"删除设备成功！");
            [[UserData Instance].deviceDic setValue:nil forKey:self.devObj.bindIMEI];
            [self.navigationController popViewControllerAnimated:YES];

        } else if(request.tag == 31) {
            
            NSLog(@"绑定设备成功！");
            
            self.devObj.isAdmin = [jsonDic[@"eqAdmin"] intValue];
            self.devObj.bleMac = jsonDic[@"eqBluetoothMAC"];
           
            [[UserData Instance].deviceDic setValue:self.devObj forKey:self.devObj.bindIMEI]; // 根据设备ID保存新绑定的设备
            
            DeviceSetting_TableViewController *deviceSettingTVC = [[DeviceSetting_TableViewController alloc] initWithNibName:@"DeviceSetting_TableViewController" bundle:nil];
            deviceSettingTVC.tempUphone = [request userInfo][@"uphone"];
            
            deviceSettingTVC.devObj = self.devObj;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else if(request.tag == 32){
        
            DLog(@"设备关机成功！");
            self.devObj.online = NO;
            [_tableView reloadData];
//            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"设备关机成功", nil)];
//            [alertView show];
            
        }
    })
}
_Method_RequestFailed()

@end
