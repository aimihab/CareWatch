//
//  CustomPickerView.h
//  Q2
//
//  Created by hebing on 14-9-18.
//  Copyright (c) 2014年 hebing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBPickerScrollView : UITableView

@property NSInteger tagLastSelected;

- (void)dehighlightLastCell;
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow;

@end


@interface CustomPickerView : UIView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong, readonly) NSString *value;
@property (nonatomic, copy) NSString *value;
@property (nonatomic,assign)BOOL harlfView;

- (id)initWithFrame:(CGRect)frame andDataArr:(NSArray *)dateArr;
- (void)addDataArr:(NSArray *)dateArr;
- (id)initWithFrame:(CGRect)frame;
@end
