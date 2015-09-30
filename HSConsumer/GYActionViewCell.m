//
//  GYActionViewCell.m
//  SelfActionSheetTest
//
//  Created by Apple03 on 15/8/4.
//  Copyright (c) 2015年 Apple03. All rights reserved.
//

#import "GYActionViewCell.h"
#import "GYBottomActionView.h"
#import "UIImageView+WebCache.h"

@interface GYActionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *imgvHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSelected;
@property (weak, nonatomic) IBOutlet UILabel *lbTitleOne;

@end
@implementation GYActionViewCell

- (void)awakeFromNib {
    // Initialization code很久很久
}
+(instancetype)cellWithTableView:(UITableView * )tableView
{
    GYActionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GYActionViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
-(void)setModel:(GYBottomActionViewItemModel *)model
{
    _model = model;
    self.imgvSelected.hidden = YES;
    self.lbName.text = model.strTitle;
    if (model.type == 1)
    {
        self.imgvHead.hidden = YES;
        self.lbName.hidden = YES;
        self.lbTitleOne.hidden = NO;
        self.lbTitleOne.text = model.strTitle;
    }
    else if (model.type == 2)
    {
        self.imgvHead.hidden = NO;
        self.lbName.hidden = NO;
        self.lbTitleOne.hidden = YES;
        if (model.isAdd)
        {
            [self.imgvHead setImage:[UIImage imageNamed:@"add.png"]];
            self.lbName.textColor = [UIColor redColor];
        }
        else
        {
            [self.imgvHead sd_setImageWithURL:[NSURL URLWithString: model.strImgName] placeholderImage:[UIImage imageNamed:@"defaultheadimg.png"]];
            if (model.isSelect)
            {
                self.imgvSelected.hidden = NO;
            }
        }
    }
    
}
@end
