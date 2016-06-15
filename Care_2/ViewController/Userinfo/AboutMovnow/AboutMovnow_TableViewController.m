//
//  AboutMovnow_TableViewController.m
//  Care
//
//  Created by Vecklink on 14-6-20.
//
//

#import "AboutMovnow_TableViewController.h"

@interface AboutMovnow_TableViewController () {
    __weak IBOutlet UILabel *versionLabel;
    NSArray *itemTitleArray;
    NSString *version;
    
    IBOutlet UIView *copyrightView;
    
    __weak IBOutlet UILabel *copyrightLabel;
    
}

@end

@implementation AboutMovnow_TableViewController


- (void)viewWillAppear:(BOOL)animated{
    

    [[[UIApplication sharedApplication] keyWindow] addSubview:copyrightView];
    copyrightView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, 320, 40);
 //   copyrightView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"01_nav_background_90"]];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [copyrightView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"关于走吧", nil);
    copyrightLabel.text = NSLocalizedString(@"版权所有 ©2015 MOVNOW", nil);
    [self setBackButton];
    
    version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    versionLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"走吧关爱", nil), version];
    
//    itemTitleArray = @[NSLocalizedString(@"欢迎页", nil),
//                       NSLocalizedString(@"意见反馈", nil),
//                       [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"版本更新", nil), version]];
    
    itemTitleArray = @[NSLocalizedString(@"欢迎页", nil),
                       NSLocalizedString(@"意见反馈", nil)];
    
}

//导航栏返回按钮（宏）
_Method_SetBackButton(nil, NO)

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemTitleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = tableView.backgroundColor;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
        imgView.image = [UIImage imageNamed:@"03_set_cell_second_background"];
        [cell addSubview:imgView];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(17, 15, 150, 20)];
        lb.textColor = [UIColor whiteColor];
        lb.font = [UIFont boldSystemFontOfSize:14];
        lb.tag = 100;
        [cell addSubview:lb];
    }
    UILabel *lb = (UILabel *)[cell viewWithTag:100];
    lb.text = [NSString stringWithFormat:@"  %@", itemTitleArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            SetWelcomePage_ViewController *setWelcomePageVC = [[SetWelcomePage_ViewController alloc] initWithNibName:@"SetWelcomePage_ViewController" bundle:nil];
            [self.navigationController pushViewController:setWelcomePageVC animated:YES];
        }
            break;
        case 1: {
            GiveFeedback_ViewController *giveFeedbackVC = [[GiveFeedback_ViewController alloc] initWithNibName:@"GiveFeedback_ViewController" bundle:nil];
            [self.navigationController pushViewController:giveFeedbackVC animated:YES];
        }
            break;
        case 2: {
            VersionUpdate_ViewController *versionUpdate = [[VersionUpdate_ViewController alloc] initWithNibName:@"VersionUpdate_ViewController" bundle:nil];
            [self.navigationController pushViewController:versionUpdate animated:YES];
        }
            break;
    }
}

@end
