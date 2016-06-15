//
//  CustomPickerView.m
//  Q2
//
//  Created by hebing on 14-9-18.
//  Copyright (c) 2014年 hebing. All rights reserved.
//

#import "CustomPickerView.h"

@interface HBPickerScrollView ()

@property (nonatomic, strong) NSArray *arrValues;

@end


@implementation HBPickerScrollView

- (id)initWithFrame:(CGRect)frame andValues:(NSArray *)arrayValues {
    
    if(self = [super initWithFrame:frame]) {
        [self setScrollEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        
        if(arrayValues)
            _arrValues = [arrayValues copy];
    }
    return self;
}

//取消高亮
- (void)dehighlightLastCell {
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self setTagLastSelected:-1];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

//设置高亮
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow {
    [self setTagLastSelected:indexPathRow];
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

@end

@interface CustomPickerView ()
{
    CGFloat _rowHight;
}

@property (nonatomic, strong) NSArray *timerArr;
@property (nonatomic, strong) HBPickerScrollView *svView;


@end

@implementation CustomPickerView

- (id)initWithFrame:(CGRect)frame andDataArr:(NSArray *)dateArr
{
    self = [super initWithFrame:frame];
    if (self) {
        if (dateArr) {
            
            if (_harlfView)
            {
                _rowHight = 50;
            }
          _rowHight = 37.0;
            
          int count = frame.size.height/_rowHight/2;
            
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < count; i++) {
                 [arr addObject:dateArr[dateArr.count-1-i]];
            }
           
            [arr addObjectsFromArray:dateArr];
            
            for (int i = 0; i <= count; i++) {
                [arr addObject:dateArr[i]];

            }
            
            _timerArr = arr;
            
        }
        [self creatUI];
    }
    return self;
}

- (id )initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _harlfView = YES;
    }
    return self;

}
- (void)addDataArr:(NSArray *)dateArr
{
    _rowHight = 37;
    
    int count = self.frame.size.height/_rowHight/2;
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++) {
        [arr addObject:dateArr[dateArr.count-1-i]];
    }
    
    [arr addObjectsFromArray:dateArr];
    
    for (int i = 0; i <= count; i++) {
        [arr addObject:dateArr[i]];
        
    }
    
    _timerArr = arr;
    

  [self creatUI];


}



- (void)creatUI{
    //创建选中高亮边框
//    UIImageView *barSel2 = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-110)/2.0, (self.frame.size.height-_rowHight)/2.0, 100, _rowHight)];
//    UIImage *image = [UIImage imageNamed:@"提醒_文字底-.png"];
//    image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//    barSel2.image = image;    

    //创建选择器的数据表
    _svView = [[HBPickerScrollView alloc] initWithFrame:self.bounds andValues:_timerArr];
    _svView.dataSource = self;
    _svView.delegate = self;
    [self addSubview:_svView];
    
    //创建渐变效果层
    CAGradientLayer *gradientLayerTop = [CAGradientLayer layer];
    gradientLayerTop.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height/2.0);
    gradientLayerTop.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)[UIColor whiteColor].CGColor, nil];//colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0
    gradientLayerTop.startPoint = CGPointMake(0.0f, 0.7f);
    gradientLayerTop.endPoint = CGPointMake(0.0f, 0.0f);
    
    CAGradientLayer *gradientLayerBottom = [CAGradientLayer layer];
    gradientLayerBottom.frame = CGRectMake(0.0, self.frame.size.height/2.0, self.frame.size.width, self.frame.size.height/2.0);
    gradientLayerBottom.colors = gradientLayerTop.colors;
    gradientLayerBottom.startPoint = CGPointMake(0.0f, 0.3f);
    gradientLayerBottom.endPoint = CGPointMake(0.0f, 1.0f);
    
    [self.layer addSublayer:gradientLayerTop];
    [self.layer addSublayer:gradientLayerBottom];
    
//    [self addSubview:barSel2];
    [self setTime:@"1"];
}

- (void)setTime:(NSString *)time {
    NSInteger index = [time integerValue];
    [_svView dehighlightLastCell];
    [self centerCellWithIndexPathRow:index forScrollView:_svView];
}


- (void)setValue:(NSString *)value{
    _value = value;
    [self setTime:value];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isDragging]) {
        [self centerValueForScrollView:(HBPickerScrollView *)scrollView];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"pickerEndScroll" object:nil];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerValueForScrollView:(HBPickerScrollView *)scrollView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pickerEndScroll" object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pickerBeginScroll" object:nil];
    HBPickerScrollView *sv = (HBPickerScrollView *)scrollView;
    [sv dehighlightLastCell];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int count = round(scrollView.frame.size.height/_rowHight);
    if (_svView.contentOffset.y > (_timerArr.count-count)*_rowHight){
        _svView.contentOffset = CGPointMake(0, 0);
    } else if (_svView.contentOffset.y < 0){
        _svView.contentOffset = CGPointMake(0, (_timerArr.count-count)*_rowHight);
    }
}

- (void)centerValueForScrollView:(HBPickerScrollView *)scrollView {
    
    float offset = scrollView.contentOffset.y;
    
    int mod = (int)offset%(int)_rowHight;
    
    float newValue = (mod >= 20.0) ? offset+(_rowHight-mod) : offset-mod;
    NSInteger indexPathRow = (int)(newValue/_rowHight);
    
    [self centerCellWithIndexPathRow:indexPathRow forScrollView:scrollView];
}

- (void)centerCellWithIndexPathRow:(NSUInteger)indexPathRow forScrollView:(HBPickerScrollView *)scrollView {
    
    if(indexPathRow >= [scrollView.arrValues count]) {
        indexPathRow = [scrollView.arrValues count]-3;
    }
    float newOffset = indexPathRow*_rowHight;
    newOffset = newOffset;
    
//    [CATransaction begin];
    
//    [CATransaction setCompletionBlock:^{
    
    NSUInteger index = indexPathRow+(scrollView.frame.size.height/80);
    
        [scrollView highlightCellWithIndexPathRow:index];
        _value = _timerArr[index];
        
//        [scrollView setUserInteractionEnabled:YES];
//        [scrollView setAlpha:1.0];
//    }];
    
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
//    [CATransaction commit];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HBPickerScrollView *sv = (HBPickerScrollView *)tableView;
    return [sv.arrValues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"reusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    HBPickerScrollView *sv = (HBPickerScrollView *)tableView;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSInteger i = fabs(indexPath.row - sv.tagLastSelected);
    if (i == 0){
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
        cell.textLabel.textColor = [UIColor colorWithRed:248/255.0 green:142/255.0 blue:59/255.0 alpha:1.0];
    }else {
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    [cell.textLabel setText:sv.arrValues[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHight;
}


@end
