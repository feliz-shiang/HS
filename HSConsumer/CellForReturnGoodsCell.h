//
//  CellForReturnGoodsCell.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kCellForReturnGoodsCellIdentifier @"CellForReturnGoodsCellIdentifier"

#import <UIKit/UIKit.h>
@protocol CellForReturnGoodsCellDelegate <NSObject>

@optional
- (void)selectChange:(id)sender;

@end

@interface CellForReturnGoodsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ivGoodsPicture;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
@property (nonatomic, weak) id<CellForReturnGoodsCellDelegate> delegate;

+ (CGFloat)getHeight;
- (BOOL)isSelected;

@end
