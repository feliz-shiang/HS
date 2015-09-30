//
//  GYStarTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYStarTableViewCell.h"
#import "UIView+CustomBorder.h"

@implementation GYStarTableViewCell
{
    __weak IBOutlet UIImageView *imgvArrow;//箭头imgv
}

- (void)awakeFromNib
{
    // Initialization code
    [self setButtonBackgroundImage:_btnStar1 WithTag:101];
    [self setButtonBackgroundImage:_btnStar2 WithTag:102];
    [self setButtonBackgroundImage:_btnStar3 WithTag:103];
    [self setButtonBackgroundImage:_btnStar4 WithTag:104];
    [self setButtonBackgroundImage:_btnStar5 WithTag:105];
  
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
 
    _lbPoint.textColor=[UIColor orangeColor];
    _lbEvaluatePerson.textColor=kCellItemTitleColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setButtonBackgroundImage:(UIButton *)button WithTag: (int)tag
{
    [button setBackgroundImage:[UIImage imageNamed:@"ep_appraise_star_gray.png"] forState:UIControlStateNormal];
    button.tag=tag;
    [button setBackgroundImage:[UIImage imageNamed:@"ep_appraise_star_yellow.png"] forState:UIControlStateSelected];

}

-(void )refreshUIWithModel :(ShopModel *) model
{

    


}
@end
