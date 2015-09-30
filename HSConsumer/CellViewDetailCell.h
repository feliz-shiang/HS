//
//  CellViewDetailCell.h
//  HSConsumer
//
//  Created by apple on 14-11-19.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//明细查询

#define kCellViewDetailCellIdentifier @"CellViewDetailCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellViewDetailCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrDataSource;
//@property (strong, nonatomic) NSMutableArray *arrDetailDataSource;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *labelShowDetails;
//@property (strong, nonatomic) UIButton *btnButton;
@property (assign, nonatomic) CGFloat cellSubCellRowHeight;
//@property (assign, nonatomic) NSInteger rowAmountIndex;
@property (strong, nonatomic) NSArray *rowValueHighlightedProperty;
@property (strong, nonatomic) NSArray *rowTitleHighlightedProperty;
//@property (strong, nonatomic) NSArray *rowHighlightedProperty;
@end
