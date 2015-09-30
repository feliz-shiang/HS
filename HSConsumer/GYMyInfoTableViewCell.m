//
//  GYMyInfoTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYMyInfoTableViewCell.h"

@implementation GYMyInfoTableViewCell
{
        //图片
    __weak IBOutlet UIImageView *CellImg;
        //文字
    __weak IBOutlet UILabel *CellString;

}
- (void)awakeFromNib
{
    // Initialization code
    CellString.textColor= kCellItemTitleColor;
    self.vAccessoryView.textColor=kCellItemTextColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshWithImg :(NSString *) imgName WithTitle :(NSString *)title
{
    
    CellImg.image=[UIImage imageNamed:imgName];
    CellString.text=title;
   

}
@end
