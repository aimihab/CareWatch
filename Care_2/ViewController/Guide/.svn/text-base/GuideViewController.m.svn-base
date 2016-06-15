//
//  GuideViewController.m
//  iWalk
//
//  Created by Jason on 14-2-24.
//  Copyright (c) 2014年 Jason. All rights reserved.
//

#import "GuideViewController.h"
#import "MD5.h"

@interface GuideViewController ()
{

    __weak IBOutlet UIButton *_startBtn;
    int currentPage;
}

@end

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //currentPage = 0;
    int pageCount = 3;
    guideScrollView.pagingEnabled = YES;
    
    guideScrollView.contentSize = CGSizeMake(320 * pageCount, SCREEN_HEIGHT);
    guideScrollView.scrollsToTop = NO;
    guideScrollView.delegate = self;

    for (int i = 0;i<pageCount;i++) {
        //       NSString *nameStr   = [dic objectForKey:@"nameKey"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*guideScrollView.frame.size.width, 0, guideScrollView.frame.size.width, guideScrollView.frame.size.height)];
        
        if ([MD5 isChina]) {
             NSString *imageStr  = [NSString stringWithFormat:@"guide%d.jpg",i+1];
             imgView.image = [UIImage imageNamed:imageStr];
        }else{
            NSString *imageStr  = [NSString stringWithFormat:@"En_guide%d.jpg",i+1];
            imgView.image = [UIImage imageNamed:imageStr];

        }
        
        [guideScrollView addSubview:imgView];
        
        if (i == pageCount-1) {
            imgView.userInteractionEnabled = YES;
            
            
            //进入应用
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(80, 265,200,100);
           // button.backgroundColor = [UIColor lightGrayColor];
            [button addTarget:self action:@selector(enterApp) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:button];

        }
        
    }
}


//- (IBAction)Start:(UIButton *)sender {
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}

- (void)enterApp
{
       [self dismissViewControllerAnimated:YES completion:nil];
}


//- (void)scrollViewDidScroll:(UIScrollView *)sender
//{
//    CGFloat pageWidth = guideScrollView.frame.size.width;
//    int page = floor((guideScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//     currentPage = page;
//    NSString *imageStr  = [NSString stringWithFormat:@"guide%d.jpg",currentPage+1];
//    _imgView.image = [UIImage imageNamed:imageStr];
//    
//}
//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
