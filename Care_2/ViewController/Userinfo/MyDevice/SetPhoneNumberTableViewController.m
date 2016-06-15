//
//  SetPhoneNumberTableViewController.m
//  Care_2
//
//  Created by xiaobing on 15/5/22.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "SetPhoneNumberTableViewController.h"
#import "FaimlyPhoneCell.h"
#import "MD5.h"
#import "ErrorAlerView.h"
#import "CellTextField.h"
#import "UserData.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "CustomAlertView.h"
@interface SetPhoneNumberTableViewController ()<UITextFieldDelegate>
{
    NSMutableArray *phoneArray;//亲情号码集合
    NSMutableArray *trustedArray;//可信号码集合
    NSMutableArray *nextIconArray;//手表下键集合
    NSDictionary *nexIconDic; //下键选中的字典
    __weak IBOutlet UIButton *careNumBtn;
    __weak IBOutlet UIButton *whiteNumBtn;
    
    
    /// 弹出视图
    IBOutlet UIView *inPutBackView;
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *numberField;
    __weak IBOutlet UIButton *sureBtn;
    __weak IBOutlet UILabel *limitLable;
   
    __weak IBOutlet UILabel *watchUpKeyLabel;//手表上键
    
    
    __weak IBOutlet UILabel *watchDownLabel;//手表下键
    
    __weak IBOutlet UILabel *sosCallLabel;//sos呼叫
    
    UIButton *sectionBtn;//段尾的加号按钮
    
    
    ASIHTTPRequest *getNumberReq;
    ASIHTTPRequest *req;
    NSMutableArray *namesArr; // 名字数组
    

    IBOutlet UIView *callView; // 号码功能展示视图
    IBOutlet UIView *selectView; // 亲情号和白名单切换视图
    
    
    NSString *_callType;// 拨打类型
    
    UIView *tableFooatV;

}
- (IBAction)sureBtnClick:(id)sender;
@end

@implementation SetPhoneNumberTableViewController

-(void)dealloc {
    [req clearDelegatesAndCancel];
    [getNumberReq clearDelegatesAndCancel];
}

- (void)viewWillAppear:(BOOL)animated{
    
 //    [self getFamilyPhoneData];//获取亲情号码
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    [self setSubmitButton];
    [self localizedText];
    careNumBtn.selected = YES;
    
    inPutBackView.hidden = YES;
    
    phoneArray = [NSMutableArray array];
    trustedArray = [NSMutableArray array];
    nextIconArray = [NSMutableArray array];
   [self getFamilyPhoneData];//请求获取亲情号码
    
   // [self getData];//得到数据源
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tap];
    //设置表尾
    
    tableFooatV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 215)];
    [self setCallViewContent];
    self.tableView.tableFooterView = tableFooatV;
    
    if (!self.dev.isAdmin) {
        
        callView.userInteractionEnabled = NO;
        
    }
    
    
    
}

- (void)localizedText
{
    self.title = NSLocalizedString(@"设置号码", nil);
    limitLable.text = NSLocalizedString(@"最多可以输入5个亲情号码", nil);
    nameField.placeholder = NSLocalizedString(@"输入称呼", nil);
    numberField.placeholder = NSLocalizedString(@"输入号码", nil);
    [careNumBtn setTitle:NSLocalizedString(@"亲情号", nil) forState:UIControlStateSelected];
    [careNumBtn setTitle:NSLocalizedString(@"亲情号", nil) forState:UIControlStateNormal];
    
    [whiteNumBtn setTitle:NSLocalizedString(@"白名单", nil) forState:UIControlStateSelected];
    [whiteNumBtn setTitle:NSLocalizedString(@"白名单", nil) forState:UIControlStateNormal];
    
    watchUpKeyLabel.text = NSLocalizedString(@"手表上键呼叫", nil);
    watchDownLabel.text = NSLocalizedString(@"手表下键呼叫", nil);
    sosCallLabel.text = NSLocalizedString(@"SOS呼叫", nil);
    
}

_Method_SetBackButton(nil, NO)
_Method_SetSubmitButton(NSLocalizedString(@"保存", nil), (@selector(rightBtnClickAt)), _StringWidth(NSLocalizedString(@"保存", nil)))

- (void)getData
{
    [phoneArray removeAllObjects];
   
    //添加数据源
    DLog(@"self.dev.setPhoneNumberArr = %@",self.dev.setPhoneNumberArr);
    
    [phoneArray addObjectsFromArray:self.dev.setPhoneNumberArr];
    [self setCallViewContent];
    
    
}

#pragma - mark 保存按钮
-(void)rightBtnClickAt
{
    
    if (inPutBackView.hidden == NO) {
        return;
    }
    
    [self.view endEditing:YES];
    
    DLog(@"phoneArray = %@",phoneArray);
    
    //判断下是否设置手表上下键
    NSMutableArray *call_typeArray = [NSMutableArray array];
    for (NSDictionary *deviceDic in phoneArray) {
        
        if (![deviceDic[@"key_down"]isEqualToNumber:@(0)]||![deviceDic[@"key_up"]isEqualToNumber:@(0)]) {
            [call_typeArray addObject:deviceDic];
        }
    }
    if (phoneArray.count!=0 && call_typeArray.count == 0) {
        [ErrorAlerView showWithMessage:NSLocalizedString(@"请设置手表上下键", nil) sucOrFail:NO];
        return;
    }
    
    //发送网络请求修改亲情号码
    [self sendRequestSetPhoneData];
}


#pragma -mark 点击屏幕取消键盘
- (void)tapView{
    inPutBackView.hidden = YES;
    sectionBtn.hidden = NO;
    
    [self.view endEditing:YES];
    
}


#pragma mark - 获取所有号码
- (void)getFamilyPhoneData
{
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_getUser_phonenumber forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:self.dev.bindIMEI forKey:@"eqId"];
    [signInfo setValue:_System_Language forKey:@"locale"];
    
//    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//    NSString *sign = [MD5 createSignWithDictionary:signInfo];
//    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    
    getNumberReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [getNumberReq addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    getNumberReq.delegate = self;
    getNumberReq.tag = 500;
   
    [getNumberReq startAsynchronous];
    _Code_ShowLoading
}

-(void)sendRequestSetPhoneData{
    
//    DeviceModel *dev = [UserData Instance].deviceDic[[UserData Instance].likeDevIMEI];
    //把数组转换成字符串
    NSMutableArray *upDataArray = [NSMutableArray array];
    [upDataArray addObjectsFromArray:phoneArray];
    [upDataArray addObjectsFromArray:trustedArray];
    NSString *phoneString = [upDataArray JSONRepresentation];
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_user_phonenumber forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:_System_Language forKey:@"locale"];
    [signInfo setValue: self.dev.bindIMEI forKey:@"eqId"];
    [signInfo setValue:phoneString forKey:@"numbers"];
    
    
//    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
//    NSString *sign = [MD5 createSignWithDictionary:signInfo];
//    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo];
    
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.tag = 501;
    req.delegate = self;
    [req startAsynchronous];
    _Code_ShowLoading
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    
    _Code_HTTPResponseCheck(jsonDic, {
        
        if (request.tag == 500){
             DLog(@"----------%@",jsonDic[@"numbers"]);
            
//            DeviceModel *dev = [UserData Instance].deviceDic[jsonDic[@"eqId"]];
//            self.dev.isAdmin = [jsonDic[@"isAdmin"] intValue];
            
            [self.dev.setPhoneNumberArr removeAllObjects];
            [self.dev.trustPhoneNumberArr removeAllObjects];
              [trustedArray removeAllObjects];
            if (jsonDic[@"numbers"]){
            
                for (NSDictionary *dic in jsonDic[@"numbers"]) {
                    
                    if (dic[@"type"]!= nil) {
                        if ([dic[@"type"] isKindOfClass:[NSNumber class]]) {
                            if ([dic[@"type"] isEqualToNumber:@(0)]) {
                                
                                [self.dev.setPhoneNumberArr addObject:dic];
                                
                            }else
                            {
                                [trustedArray addObject:dic];
                                [self.dev.trustPhoneNumberArr addObject:dic];
                            }
                        }
//                        else if ([dic[@"type"] isKindOfClass:[NSString class]])
//                        {
//                            if ([dic[@"type"] isEqualToString:@"0"]) {
//                                
//                                [self.dev.setPhoneNumberArr addObject:dic];
//                            }else
//                            {
//                                [trustedArray addObject:dic];
//                                [self.dev.trustPhoneNumberArr addObject:dic];
//                                
//                            }
//                        }
                    }
                }
                

            }
            
            [self getData];
            [self.tableView reloadData];
            
        }else if(request.tag == 501){
        
            NSLog(@"设置成功");
            if([jsonDic[@"error"] isEqualToNumber:@0])
            {
                //这段以后应该放到请求成功的方法里面
                [_dev.setPhoneNumberArr removeAllObjects];
                [_dev.trustPhoneNumberArr removeAllObjects];
                [_dev.setPhoneNumberArr addObjectsFromArray:phoneArray];
                
                [_dev.trustPhoneNumberArr addObjectsFromArray:trustedArray];
                [[UserData Instance]saveCustomObject:[UserData Instance]];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        NSLog(@"jsonDic=%@",jsonDic);
        
    })
}
_Method_RequestFailed(
                      
     if(request.tag == 500)
  {
      [self getData];
      [trustedArray addObjectsFromArray:_dev.trustPhoneNumberArr];
      [self.tableView reloadData];
  }

);

#pragma mark - 切换亲情号和白名单
- (IBAction)changeNumType:(UIButton *)sender {
    

        
        if (sender.tag==10) {
            careNumBtn.selected = YES;
           
            whiteNumBtn.selected = NO;
         
            callView.hidden = NO;
            
        }else{
            whiteNumBtn.selected = YES;
           
            careNumBtn.selected = NO;
            
            callView.hidden = YES;

        }
        
    
    
    
    [self.tableView reloadData];

}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  //  return trustedArray.count > 0?2:1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (careNumBtn.selected){
        return phoneArray.count; // 亲情号码集合
    }else{
        return  trustedArray.count; // 白名单号码集合
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return NSLocalizedString(@"亲情号码", nil);
    }else{
        
        return NSLocalizedString( @"可信号码", nil);
    }

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    selectView.backgroundColor = [UIColor clearColor];
    return selectView;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
 
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0 , self.view.frame.size.width,300)];
    backView.backgroundColor = [UIColor clearColor];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake((self.view.frame.size.width/2)-38,0, 75, 75);
    [addBtn setImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"add_btn_pre"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = section +200;
    [backView addSubview:addBtn];
    
    return backView;
    
    if (!self.dev.isAdmin) {
        backView.userInteractionEnabled = NO;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic;
    if (careNumBtn.selected){
        
        dic = phoneArray[indexPath.row];
        
    }else
    {
        dic = trustedArray[indexPath.row];
    }
    
    FaimlyPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FaimlyPhoneCell"];
    if (cell == nil){
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"FaimlyPhoneCell" owner:self options:nil][0];
        
    }
    
    cell.phoneNumberText.delegate = self;
    cell.phoneNumberText.indexPath = indexPath;
    cell.phoneNumberText.tag = indexPath.row + indexPath.section +400;
    NSLog(@"cell.phoneNumberText.indexPath = %@", cell.phoneNumberText.indexPath);
    
    
    
    if (dic.count > 0)
    {
        [cell setCellContent:dic]; // 对应的cell内容格式布局
        
    }
    
    
    
    if (careNumBtn.selected){
        if (indexPath.row == phoneArray.count - 1){
            
            cell.lineImage.hidden = YES;
        }
    }else {
        
        if (indexPath.row == trustedArray.count - 1){
            
            cell.lineImage.hidden = YES;
        }
    }
    
    [ cell setCellBtnClickBlock:^(UITableViewCell *phoneCell) {//删除按钮被点击的回调
        
        if (inPutBackView.hidden == NO){
            return ;
            
        }
        NSIndexPath *phoneIndexPath = [tableView indexPathForCell:phoneCell];
        
        if (careNumBtn.selected){
            
            if (phoneArray.count >0){
                [phoneArray removeObjectAtIndex:phoneIndexPath.row];
            }
        }else{
            
            if (trustedArray.count > 0) {
                [trustedArray removeObjectAtIndex:phoneIndexPath.row];
            }
            
        }
        [self setCallViewContent];
        [tableView deleteRowsAtIndexPaths:@[phoneIndexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [tableView reloadData];
    }];

    if (!self.dev.isAdmin) {
        cell.userInteractionEnabled = NO;
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  80 ;
    
}

#pragma -mark 手表下键按钮点击事件
-(void)nextBtnClickPress:(UIButton *)nextBtn
{
   
    
    //把除了选中那个按钮以外的btn设置选中状态为no
    for (int i = 0;i < phoneArray.count ;i++ ) {
        
        UIButton *btn = (UIButton *)[callView viewWithTag:500+i];
        UIButton *imageV = (UIButton *)[callView viewWithTag:550+i];
        if (nextBtn.tag -500 != i) {
            
            btn.selected = NO;
            imageV.hidden = YES;
            NSMutableDictionary *dic = [phoneArray[i] mutableCopy];
            [dic setValue:@(0) forKey:@"key_down"];
            [phoneArray replaceObjectAtIndex:i withObject:dic];
        }
    }
    
    //控制btn的选中状态，来改变图标的显示隐藏
    UIButton *selecedBtn = (UIButton *)[callView viewWithTag:nextBtn.tag];
    
    UIButton *imageV = (UIButton *)[callView viewWithTag:nextBtn.tag+50];
    
    
    NSMutableDictionary *dic = [phoneArray[nextBtn.tag-500] mutableCopy];
    selecedBtn.selected = !selecedBtn.selected;
    
    
    if (selecedBtn.selected) {
        if ([dic[@"key_down"]isEqualToNumber:@(1)]) {
            imageV.hidden = YES;
            [dic setValue:@(0) forKey:@"key_down"];
        }else
        {
            imageV.hidden = NO;
            [dic setValue:@(1) forKey:@"key_down"];
        }
    }else
    {
        [dic setValue:@(0) forKey:@"key_down"];
        imageV.hidden = YES;
        
    }
    
    
    [phoneArray replaceObjectAtIndex:nextBtn.tag-500 withObject:dic];
    DLog(@"phoneArray = %@",phoneArray);
    
}


#pragma mark 手表上键按钮点击事件

- (void)CareclickPress:(UIButton *)careBtn

{
    //把除了选中那个按钮以外的btn设置选中状态为no
    for (int i = 0;i < phoneArray.count ;i++ ) {
        
        UIButton *btn = (UIButton *)[callView viewWithTag:300+i];
        UIButton *imageV = (UIButton *)[callView viewWithTag:350+i];
        if (careBtn.tag -300 != i) {
            
            btn.selected = NO;
            imageV.hidden = YES;
            NSMutableDictionary *dic = [phoneArray[i] mutableCopy];
            [dic setValue:@(0) forKey:@"key_up"];
            [phoneArray replaceObjectAtIndex:i withObject:dic];
        }
    }
    
    //控制btn的选中状态，来改变图标的显示隐藏
    UIButton *selecedBtn = (UIButton *)[callView viewWithTag:careBtn.tag];
    
    UIButton *imageV = (UIButton *)[callView viewWithTag:careBtn.tag+50];
    
    NSMutableDictionary *dic;
    if (phoneArray.count > 0) {
       dic = [phoneArray[careBtn.tag-300] mutableCopy];
    }
    
    selecedBtn.selected = !selecedBtn.selected;
    
    
    if (selecedBtn.selected) {
        if ([dic[@"key_up"]isEqualToNumber:@(1)]) {
            imageV.hidden = YES;
            [dic setValue:@(0) forKey:@"key_up"];
        }else
        {
         imageV.hidden = NO;
         [dic setValue:@(1) forKey:@"key_up"];
        }
    }else
    {
        [dic setValue:@(0) forKey:@"key_up"];
        imageV.hidden = YES;
       
    }
    
    
    [phoneArray replaceObjectAtIndex:careBtn.tag-300 withObject:dic];
    DLog(@"phoneArray = %@",phoneArray);
  
   
}

#pragma - mark 得到文字高度
- (CGFloat )getTextWeight:(NSDictionary *)dic
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
   CGSize size = [dic[@"name"] boundingRectWithSize:CGSizeMake(280, 30) options:NSStringDrawingUsesLineFragmentOrigin  attributes:dict context:nil].size;


    return size.width;
}



#pragma - mark 设置段尾的视图
- (void)setCallViewContent
{
    callView.frame = CGRectMake(10, 9, 300, 236);
    callView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"callbg"]];
    
    for (UIView *view in callView.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
            
        }
    }
    
    
    CGFloat leftSpace = 3.0;
    CGFloat space = 13;
    
    //手表上键的控制参数
    CGFloat btnOrginX = 0.0;
    CGFloat buttonOrginY = 0;
    NSInteger column = 0;// 控制列
   

    //手表下键的控制参数
    CGFloat nextButtonOrginY = 0;
    CGFloat nextBtnOrginX = 0.0;
    NSInteger nextcolumn = 0;
    
    
    //手表下键的控制参数
    CGFloat lastButtonOrginY = 0;
    CGFloat lastBtnOrginX = 0.0;
    NSInteger lastColumn = 0;
    
     CGFloat sumWidth = 0.0;
        for (NSDictionary *dic in phoneArray) {
        //得到所有s文字的宽度
        sumWidth += [self getTextWeight:dic];
    }

    DLog(@"sumWidth = %f",sumWidth);
    
        if (sumWidth+100 > 300) {
            buttonOrginY = 28;
            nextButtonOrginY = 108;
            lastButtonOrginY = 185;
            
        }else
        {
            buttonOrginY = 38;
            nextButtonOrginY = 118;
            lastButtonOrginY = 197;
        }
   
   
   
    for (int i = 0; i < phoneArray.count;i ++) {
        
        NSDictionary *dic = phoneArray[i];
        
     //   NSDictionary *nextDic = nextIconArray[i];
        
        //手表上键呼叫按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
         [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
         [btn sizeToFit];//btn自适应宽度
          btn.tag = 300 + i;
         [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(CareclickPress:) forControlEvents:UIControlEventTouchUpInside];
        [callView addSubview:btn];
        if (btnOrginX +btn.frame.size.width + 10 > 260.0) {//超出屏幕范围换行
            btnOrginX = 0;
            buttonOrginY += 23;
            column = 0;
        }
        btn.frame = CGRectMake(leftSpace + btnOrginX + space *column, buttonOrginY, btn.frame.size.width, 30);
        btnOrginX += btn.frame.size.width ;
        column ++;

        
        UIButton *imageVBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageVBtn.frame = CGRectMake(btn.frame.size.width,8, 15, 15);
        [imageVBtn setBackgroundImage:[UIImage imageNamed:@"sle"]  forState:UIControlStateNormal];
        imageVBtn.hidden = YES;
        imageVBtn.tag = btn.tag + 50;
        [btn addSubview: imageVBtn];

        //读取本地状态
        if ([dic[@"key_up"] isEqualToNumber:@(1)]) {
            imageVBtn.hidden = NO;
        }
        
        
        
        //手表下键呼叫按钮
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitle:dic[@"name"] forState:UIControlStateNormal];
        [btn2 sizeToFit];//btn自适应宽度
         btn2.tag = 500 + i;
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn2 addTarget:self action:@selector(nextBtnClickPress:) forControlEvents:UIControlEventTouchUpInside];
        [callView addSubview:btn2];
        if (nextBtnOrginX +btn2.frame.size.width + 10 > 260.0) {//超出屏幕范围换行
            nextBtnOrginX = 0;
            nextButtonOrginY += 23;
            nextcolumn = 0;
        }
        btn2.frame = CGRectMake(leftSpace + nextBtnOrginX + space *nextcolumn, nextButtonOrginY, btn2.frame.size.width, 30);
        nextBtnOrginX += btn2.frame.size.width ;
        nextcolumn ++;
        
    
        UIButton *imageVB = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageVB setBackgroundImage:[UIImage imageNamed:@"sle"]  forState:UIControlStateNormal];
        imageVB.frame = CGRectMake(btn2.frame.size.width, 8,15, 15);
        imageVB.hidden = YES;
        imageVB.tag = btn2.tag + 50;
        [btn2 addSubview: imageVB];
        
        
        //读取本地状态
        if ([dic[@"key_down"] isEqualToNumber:@(1)]) {
            imageVB.hidden = NO;
        }

        
        //sos呼叫的控制参数
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setTitle:dic[@"name"] forState:UIControlStateNormal];
        [btn3 sizeToFit];//btn自适应宽度
        btn3.tag = 500 + i;
        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn3.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn3 addTarget:self action:@selector(nextBtnClickPress:) forControlEvents:UIControlEventTouchUpInside];
        [callView addSubview:btn3];
        if (lastBtnOrginX +btn3.frame.size.width + 10 > 260.0) {//超出屏幕范围换行
            lastBtnOrginX = 0;
            lastButtonOrginY += 23;
            lastColumn = 0;
        }
        btn3.frame = CGRectMake(leftSpace + lastBtnOrginX + space *lastColumn, lastButtonOrginY, btn3.frame.size.width, 30);
        lastBtnOrginX += btn3.frame.size.width ;
        lastColumn ++;
    }
    
    [tableFooatV addSubview:callView];
    
}





#pragma -mark 段头按钮事件
- (void)addBtnClick:(UIButton *)Btn
{
    
    if (careNumBtn.selected) {
        
        if (phoneArray.count == 5)
        {
            [ErrorAlerView showWithMessage:NSLocalizedString(@"设置亲情号码不能超过5个", nil) sucOrFail:NO];
            [inPutBackView removeFromSuperview];
            nameField.text = @"";
            numberField.text = @"";
            return;
        }

    }else
    {
        if (trustedArray.count == 10) {
            
            [ErrorAlerView showWithMessage:NSLocalizedString(@"设置白名单号码不能超过10个", nil) sucOrFail:NO];
            [inPutBackView removeFromSuperview];
            nameField.text = @"";
            numberField.text = @"";
            return;

            
        }
    
    }

    
    
    inPutBackView.hidden = NO;
    sectionBtn = (UIButton *)[self.tableView viewWithTag:Btn.tag];
    if (phoneArray.count == 0 ||trustedArray.count == 0){
        
        inPutBackView.frame = CGRectMake(0, -20, 320, 100);
        
    }else
    {
        inPutBackView.frame = CGRectMake(0, -25, 320, 100);
    }
    
    if (sectionBtn.tag == 200){
        
        [sectionBtn.superview addSubview:inPutBackView];
        UIButton *sectionBtn1 = (UIButton *)[self.tableView viewWithTag:201];
        sectionBtn1.selected = NO;
        
        sectionBtn1.hidden = NO;
        sectionBtn.hidden = YES;
        
    }else
    {
        [sectionBtn.superview addSubview:inPutBackView];
        UIButton *sectionBtn2 = (UIButton *)[self.tableView viewWithTag:200];
        sectionBtn2.selected = NO;
        sectionBtn2.hidden = NO;
        sectionBtn.hidden = YES;
    }
    
    [nameField becomeFirstResponder];
}



#pragma - mark 增加亲情号码确定按钮
- (IBAction)sureBtnClick:(id)sender {
    
   
    
  
    
    if ([nameField.text isEqualToString:@""]||[numberField.text isEqualToString:@""])
    {
        
        [ErrorAlerView showWithMessage:NSLocalizedString(@"姓名或者手机号为空", nil) sucOrFail:NO];
        return;
    }
    if (nameField.text.length > 4){
        
        [ErrorAlerView showWithMessage:NSLocalizedString(@"名字太长", nil) sucOrFail:NO];
        return;
    }
    
    
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    if (![predicate evaluateWithObject:numberField.text]) {
        [ErrorAlerView showWithMessage:NSLocalizedString(@"非法手机号", nil) sucOrFail:NO];
        return;
    }
/*********** 验证姓名或号码的重复问题 **********/
    NSMutableArray *tempArray = [@[]mutableCopy];
    
    for (NSDictionary *dic in careNumBtn.selected ? phoneArray:trustedArray) {
        
        
        if ([dic[@"number"]isEqualToString:numberField.text]) {
            [tempArray addObject:dic[@"number"]];
        }else if ([dic[@"name"]isEqualToString:nameField.text]){
        
            [tempArray addObject:dic[@"name"]];
        }
    }
    
    if (tempArray.count > 0) {
        if ([tempArray[0]isEqualToString:nameField.text]) {
            [ErrorAlerView showWithMessage:NSLocalizedString(@"姓名重复", nil) sucOrFail:NO];
            return;
        }else
        {
              [ErrorAlerView showWithMessage:NSLocalizedString(@"手机号码重复", nil) sucOrFail:NO];
            return;
        }
        
    }

    NSLog(@"phoneArray= %@",phoneArray);
    inPutBackView.hidden = YES;
    sectionBtn.hidden = NO;
    if (careNumBtn.selected)
    {
       [phoneArray addObject:@{@"name":nameField.text,@"number":numberField.text,@"type":@(0),@"key_up":@(0),@"key_down":@(0)}];
    
        [_dev.setPhoneNumberArr addObject:@{@"name":nameField.text,@"number":numberField.text,@"type":@(0),@"key_up":@(0),@"key_down":@(0)}];// 存到模型里
        [self setCallViewContent];
        
    }else{
        
        [trustedArray addObject:@{@"name":nameField.text,@"number":numberField.text,@"type":@(1),@"key_up":@(0),@"key_down":@(0)}];
        [_dev.trustPhoneNumberArr addObject:@{@"name":nameField.text,@"number":numberField.text,@"type":@(1),@"key_up":@(0),@"key_down":@(0)}];// 存到模型里
        
    }
    
    NSLog(@"phoneArray= %@",phoneArray);
    nameField.text = @"";
    numberField.text = @"";
 
    
    [self.tableView reloadData];
}

#pragma - mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (careNumBtn.selected) {
        whiteNumBtn.enabled = NO;
    }else if (whiteNumBtn.selected){
        careNumBtn.enabled = NO;
    }
    if ([textField isKindOfClass:[CellTextField class]]){
        
        CellTextField *textF = (CellTextField *)textField;
        FaimlyPhoneCell *cell = (FaimlyPhoneCell *)[self.tableView cellForRowAtIndexPath:textF.indexPath];
        cell.delegateNumberBtn.enabled = NO;
    }
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
       return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"textField-class = %@",[textField class]);
    if ([textField isKindOfClass:[CellTextField class]]){
        
        CellTextField *textF = (CellTextField *)textField;
        FaimlyPhoneCell *cell = (FaimlyPhoneCell *)[self.tableView cellForRowAtIndexPath:textF.indexPath];
        cell.delegateNumberBtn.enabled = YES;
        NSLog(@"textF.text= %@",cell.phoneNumberText.text);
        //如果修改后是手机号码，就刷新然后保存
        if (![MD5 checkPhoneNumInput:cell.phoneNumberText.text]){
            
            [ErrorAlerView showWithMessage:NSLocalizedString(@"非法手机号", nil) sucOrFail:NO];
            cell.delegateNumberBtn.enabled = NO;
            return NO;
        }else
        {
            cell.delegateNumberBtn.enabled = YES;
        }
            
            NSString *phone = [cell.phoneNumberText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSDictionary* dic;
        if (careNumBtn.selected) {
            dic  = phoneArray[textF.indexPath.row];
        }else
        {
            dic = trustedArray[textF.indexPath.row];
        }
        
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
            [dic1 setValue:phone forKey:@"number"];
            
            NSLog(@"phoneArray = %@",phoneArray);

            if (careNumBtn.selected) {
                [phoneArray replaceObjectAtIndex:textF.indexPath.row withObject:dic1];
                [_dev.setPhoneNumberArr removeAllObjects];
                [_dev.setPhoneNumberArr addObjectsFromArray:phoneArray];
                
            }else
            {
                [trustedArray replaceObjectAtIndex:textF.indexPath.row withObject:dic1];
                [_dev.trustPhoneNumberArr removeAllObjects];
                [_dev.trustPhoneNumberArr addObjectsFromArray:trustedArray];
            }
        }
        
 
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    return YES;
}


#pragma  mark - 结束号码编辑修改后刷新界面
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isKindOfClass:[CellTextField class]]){
        
        [self.tableView reloadData];
    }
    
    careNumBtn.enabled = YES;
    whiteNumBtn.enabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.tableView endEditing:YES];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
