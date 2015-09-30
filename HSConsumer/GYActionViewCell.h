//
//  GYActionViewCell.h
//  SelfActionSheetTest
//
//  Created by Apple03 on 15/8/4.
//  Copyright (c) 2015年 Apple03. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * strIdentifier = @"actionViewCell";
@class GYBottomActionViewItemModel;

@interface GYActionViewCell : UITableViewCell
@property (nonatomic,strong)GYBottomActionViewItemModel* model;
+(instancetype)cellWithTableView:(UITableView * )tableView;
@end
