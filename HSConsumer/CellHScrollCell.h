//
//  CellHScrollCell.h
//  company
//
//  Created by apple on 14-11-13.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kCellHScrollCellIdentifier @"CellHScrollCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellHScrollCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIViewController *vcPrarentVC;

- (void)setTitlesAndImages:(NSArray *)arr;
@end
