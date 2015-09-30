//
//  GYFriendManageTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-31.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYFriendManageTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation GYFriendManageTableViewCell
{

    __weak IBOutlet UILabel *lbFriendName;

    __weak IBOutlet UIImageView *imgvFriendIcon;

}

- (void)awakeFromNib
{
    // Initialization code
    
    lbFriendName.textColor=kCellItemTitleColor;
    self.imgvRedPoint.hidden=YES;
    self.imgvShield.hidden=YES;
    self.contentView.backgroundColor=[UIColor whiteColor];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUIWithModel :(GYNewFiendModel *)mod index:(NSInteger)index withShowRedPoint:(BOOL)show
{
    // modify by songjk
//    if (![mod.strFriendIconURL hasPrefix:@"http:"]) {
//        mod.strFriendIconURL=@"image_default_newfriend.png";
//        imgvFriendIcon.image=[UIImage imageNamed:mod.strFriendIconURL];
//    }else{
//        // modify by songjk
////        [imgvFriendIcon  sd_setImageWithURL:[NSURL URLWithString:mod.strFriendIconURL] placeholderImage:[UIImage imageNamed:@"image_default_newfriend.png"]];
//        [imgvFriendIcon  sd_setImageWithURL:[NSURL URLWithString:mod.strFriendIconURL] placeholderImage:[UIImage imageNamed:@"im_img_man.png"]];
//
//    }
      self.imgvRedPoint.hidden=YES;
    if (index == 0)
    {
        mod.strFriendIconURL = @"icon_im_new_friend.png";
        imgvFriendIcon.image=[UIImage imageNamed:mod.strFriendIconURL];
        if (show) {
            self.imgvRedPoint.hidden=NO;
        }else
        {
            self.imgvRedPoint.hidden=YES;
//            [self.imgvRedPoint removeFromSuperview];
        }
    }
    else if ([mod.strFriendIconURL hasPrefix:@"http:"])
    {
        [imgvFriendIcon  sd_setImageWithURL:[NSURL URLWithString:mod.strFriendIconURL] placeholderImage:[UIImage imageNamed:@"im_img_man.png"]];
    }
    else
    {
        mod.strFriendIconURL = @"im_img_man.png";
    
        imgvFriendIcon.image=[UIImage imageNamed:mod.strFriendIconURL];
    }
    if ([mod.isShield  boolValue]) {
        self.imgvShield.hidden=NO;
    }else
    {
    
        self.imgvShield.hidden=YES;
    }
    lbFriendName.text=mod.strFriendName;
  

}

@end
