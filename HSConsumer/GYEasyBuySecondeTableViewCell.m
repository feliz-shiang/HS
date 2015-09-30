//
//  GYEasyBuySecondeTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import "GYEasyBuySecondeTableViewCell.h"

@implementation GYEasyBuySecondeTableViewCell


- (void)awakeFromNib
{
    // Initialization code
    [self.btnSelected setBackgroundImage:[UIImage imageNamed:@"ep_check_mark0.png"] forState:UIControlStateNormal];
    self.btnSelected.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)refreshUIWith :(NSString *) title
{
    self.lbTitle.text=title;
    
}

-(void)selectOneRow
{
    self.lbTitle.textColor=kNavigationBarColor;
    self.btnSelected.hidden=NO;
    //代理给tableview，实现单选 第二个SECTION中 .
    if (_delegate && [_delegate respondsToSelector:@selector(sendDataWithTitle:WithSelectedBtn:)]) {
        [_delegate sendDataWithTitle:self.lbTitle WithSelectedBtn:self.btnSelected];
    }
    
}


//还原cell的默认状态。
-(void)nonSelectOneRow
{
    self.lbTitle.textColor=kCellItemTitleColor;
    self.btnSelected.hidden=YES;

}


@end

