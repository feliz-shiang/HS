//
//  GYStoreTableViewCell.m
//  HSConsumer
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYStoreTableViewCell.h"
#import "GYShopGoodListModel.h"
#import "UIImageView+WebCache.h"

#define kborder 5
#define kDetailFont [UIFont systemFontOfSize:12]
#define kTitleFont [UIFont systemFontOfSize:13]
@implementation GYStoreTableViewCell
{
    __weak IBOutlet UIImageView *mvrightPv;
    __weak IBOutlet UIImageView *mvrightCoin;
    __weak IBOutlet UIView *vbackGroundRight;//右边背景

    __weak IBOutlet UILabel *lbRightGoodsName;//右边商品名称
    
    __weak IBOutlet UILabel *lbRightGoodsPrice;//右边商品价格

    __weak IBOutlet UILabel *lbRightScores;//右边商品评分
    
    __weak IBOutlet UILabel *lbRightGoodsPv;//右边商品积分

    __weak IBOutlet UILabel *lbRightTotalSalesCount;//右边总销量

    __weak IBOutlet UIImageView *imgvLeftGoodsPic;//左边商品图片

    __weak IBOutlet UIImageView *mvLeftPv;
    __weak IBOutlet UIImageView *mvLeftCoin;
    __weak IBOutlet UILabel *lbLeftGoodsName;//左边商品名称
    
    __weak IBOutlet UILabel *lbLeftGoodsPrice;//左边商品价格
    
    __weak IBOutlet UILabel *lbLeftGoodsPv;//左边商品积分
    
    __weak IBOutlet UILabel *lbLeftScore;//左边商品评分
    
    __weak IBOutlet UILabel *lbLeftTotalCount;//左边商品总销量
    
    __weak IBOutlet UIView *vLeftBackground;//左边背景
    
    __weak IBOutlet UIImageView *imgvRightGoodsPic;//右边商品图片
}

- (void)awakeFromNib {
    [self settup];
}
-(void)settup
{
    self.contentView.backgroundColor = kDefaultVCBackgroundColor ;
    
    lbLeftGoodsName.textColor = kCellItemTitleColor;
    lbLeftGoodsPrice.textColor = [UIColor redColor];
    lbLeftScore.textColor = kCellItemTextColor;
    lbLeftTotalCount.textColor = kCellItemTextColor;
    lbLeftGoodsPv.textColor = kCorlorFromRGBA(0, 143, 215, 1);
    lbLeftGoodsName.font = kTitleFont;
    lbLeftGoodsPrice.font = kDetailFont;
    lbLeftScore.font = kDetailFont;
    lbLeftTotalCount.font = kDetailFont;
    lbLeftGoodsPv.font = kDetailFont;
    
    
    lbRightGoodsName.textColor = kCellItemTitleColor;
    lbRightGoodsPrice.textColor = [UIColor redColor];
    lbRightGoodsPv.textColor = kCorlorFromRGBA(0, 143, 215, 1);
    lbRightScores.textColor = kCellItemTextColor;
    lbRightTotalSalesCount.textColor = kCellItemTextColor;
    lbRightGoodsName.font = kTitleFont;
    lbRightGoodsPrice.font = kDetailFont;
    lbRightScores.font = kDetailFont;
    lbRightTotalSalesCount.font = kDetailFont;
    lbRightGoodsPv.font = kDetailFont;
    
    self.backgroundColor = kDefaultVCBackgroundColor;
    
}
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    GYStoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kStoreTableViewCell];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GYStoreTableViewCell" owner:nil options:nil] lastObject];
    }
    cell->vLeftBackground.hidden = YES;
    cell->vbackGroundRight.hidden = YES;
    return cell;
}
-(void)setLeftModel:(GYShopGoodListModel *)leftModel
{
    _leftModel = leftModel;
    vLeftBackground.hidden = NO;
    lbLeftGoodsName.text = leftModel.itemName;
    lbLeftGoodsPrice.text = [NSString stringWithFormat:@"%.02f",[leftModel.price doubleValue]] ;
    lbLeftGoodsPv.text = [NSString stringWithFormat:@"%.02f",[leftModel.pv doubleValue]];
    lbLeftScore.text = [NSString stringWithFormat:@"评分%@",[NSString stringWithFormat:@"%.01f",[leftModel.rate floatValue]]] ;
    lbLeftTotalCount.text = [NSString stringWithFormat:@"总销量%@",leftModel.salesCount] ;
    [imgvLeftGoodsPic sd_setImageWithURL:[NSURL URLWithString:leftModel.url]  placeholderImage:nil];
    
    lbLeftGoodsName.frame = CGRectMake(kborder*1, lbLeftGoodsName.frame.origin.y, vLeftBackground.frame.size.width - kborder, lbLeftGoodsName.frame.size.height);
    
    CGFloat maxW = vLeftBackground.frame.size.width;
    
    CGFloat priceX = CGRectGetMaxX(mvLeftCoin.frame);
    CGFloat priceY = lbLeftGoodsPrice.frame.origin.y;
    CGFloat prictH = lbLeftGoodsPrice.frame.size.height;
    CGSize priceSize = [Utils sizeForString:lbLeftGoodsPrice.text font:kDetailFont width:100];
    lbLeftGoodsPrice.frame = CGRectMake(priceX, priceY,priceSize.width ,prictH );
    
    CGFloat pvY = lbLeftGoodsPv.frame.origin.y;
    CGFloat pvH = lbLeftGoodsPv.frame.size.height;
    CGSize pvSize = [Utils sizeForString:lbLeftGoodsPv.text font:kDetailFont width:100];
    CGFloat pvX = maxW - pvSize.width-kborder*1;
    lbLeftGoodsPv.frame = CGRectMake(pvX, pvY, pvSize.width, pvH);
    
    mvLeftPv.frame = CGRectMake(pvX - mvLeftPv.frame.size.width, mvLeftPv.frame.origin.y, mvLeftPv.frame.size.width, mvLeftPv.frame.size.height);
    
    CGFloat TotalCountY = lbLeftTotalCount.frame.origin.y;
    CGFloat TotalCountH = lbLeftTotalCount.frame.size.height;
    CGSize TotalCountSize = [Utils sizeForString:lbLeftTotalCount.text font:kDetailFont width:150];
    CGFloat TotalCountX = maxW - TotalCountSize.width-kborder*1;
    lbLeftTotalCount.frame = CGRectMake(TotalCountX, TotalCountY,TotalCountSize.width ,TotalCountH );
    
}
-(void)setRightModel:(GYShopGoodListModel *)rightModel
{
    _rightModel = rightModel;
    vbackGroundRight.hidden = NO;
    lbRightGoodsName.text = rightModel.itemName;
    lbRightGoodsPrice.text = [NSString stringWithFormat:@"%.02f",[rightModel.price doubleValue]] ;;
    lbRightGoodsPv.text = [NSString stringWithFormat:@"%.02f",[rightModel.pv doubleValue]];;
    lbRightScores.text = [NSString stringWithFormat:@"评分%@",[NSString stringWithFormat:@"%.01f",[rightModel.rate floatValue]]] ;
    lbRightTotalSalesCount.text = [NSString stringWithFormat:@"总销量%@",rightModel.salesCount] ;
    [imgvRightGoodsPic sd_setImageWithURL:[NSURL URLWithString:rightModel.url]  placeholderImage:nil];
    
    CGFloat maxW = vbackGroundRight.frame.size.width;
    lbRightGoodsName.frame = CGRectMake(kborder*1, lbRightGoodsName.frame.origin.y, maxW - kborder, lbRightGoodsName.frame.size.height);
    
    
    CGFloat priceX = CGRectGetMaxX(mvrightCoin.frame);
    CGFloat priceY = lbRightGoodsPrice.frame.origin.y;
    CGFloat prictH = lbRightGoodsPrice.frame.size.height;
    CGSize priceSize = [Utils sizeForString:lbRightGoodsPrice.text font:kDetailFont width:100];
    lbRightGoodsPrice.frame = CGRectMake(priceX, priceY,priceSize.width ,prictH );
    
    CGFloat pvY = lbRightGoodsPv.frame.origin.y;
    CGFloat pvH = lbRightGoodsPv.frame.size.height;
    CGSize pvSize = [Utils sizeForString:lbRightGoodsPv.text font:kDetailFont width:100];
    CGFloat pvX = maxW - pvSize.width-kborder*1;
    lbRightGoodsPv.frame = CGRectMake(pvX, pvY, pvSize.width, pvH);
    
    mvrightPv.frame = CGRectMake(pvX - mvrightPv.frame.size.width, mvrightPv.frame.origin.y, mvrightPv.frame.size.width, mvrightPv.frame.size.height);
    
    CGFloat TotalCountY = lbRightTotalSalesCount.frame.origin.y;
    CGFloat TotalCountH = lbRightTotalSalesCount.frame.size.height;
    CGSize TotalCountSize = [Utils sizeForString:lbRightTotalSalesCount.text font:kDetailFont width:150];
    CGFloat TotalCountX = maxW - TotalCountSize.width-kborder*1;
    lbRightTotalSalesCount.frame = CGRectMake(TotalCountX, TotalCountY,TotalCountSize.width ,TotalCountH );
}
- (IBAction)chooseRight:(id)sender {
    if ([self.delegate respondsToSelector:@selector(StoreTableView:chooseOne:model:)]) {
        [self.delegate StoreTableView:self chooseOne:1 model:self.rightModel];
    }
}
- (IBAction)chooseLeft:(id)sender {
    if ([self.delegate respondsToSelector:@selector(StoreTableView:chooseOne:model:)]) {
        [self.delegate StoreTableView:self chooseOne:0 model:self.leftModel];
    }
}
@end
