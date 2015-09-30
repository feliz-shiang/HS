//
//  CellForOrderDetailCell.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kCellForOrderDetailCellIdentifier @"CellForOrderDetailCellIdentifier"

#import <UIKit/UIKit.h>
@class CellForOrderDetailCell;
// add by songjk
@protocol CellForOrderDetailCellDelegate <NSObject>
@optional
-(void)CellForOrderDetailCellDidCliciPictureWithCell:(CellForOrderDetailCell*)cell;

@end


@interface CellForOrderDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ivGoodsPicture;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsCnt;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsProperty;
@property (strong, nonatomic) IBOutlet UIView *vLine;
@property (assign, nonatomic) NSInteger index;// add by sngjk tableview的row
@property (weak,nonatomic) id<CellForOrderDetailCellDelegate> delegate;
@end
