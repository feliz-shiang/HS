//
//  CellTypeImagelabel.h
//  company
//
//  Created by apple on 14-11-12.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kCellTypeImagelabelIdentifier @"CellTypeImagelabelIdentifier"

#import <UIKit/UIKit.h>

@interface CellTypeImagelabel : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ivCellImage;    //cell的图标
@property (strong, nonatomic) IBOutlet UIImageView *ivCellRightArrow;//cell右箭头

@property (strong, nonatomic) IBOutlet UILabel *lbCellLabel;        //cell label

@end
