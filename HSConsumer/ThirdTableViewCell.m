//
//  ThirdTableViewCell.m
//  DropDownDemo
//
//  Created by apple on 14-11-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import "ThirdTableViewCell.h"

@implementation ThirdTableViewCell


- (void)awakeFromNib
{
    // Initialization code
    [self.btnSelected setBackgroundColor:[UIColor blueColor]];
    self.btnSelected.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)refreshUIWith :(NSString *) title
{
    NSLog(@"%@-------title",title);
    self.lbTitle.text=title;

}
-(void)selectOneRow
{
    self.lbTitle.textColor=[UIColor redColor];
    self.btnSelected.hidden=NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendDataWithTitle:WithSelectedBtn:)]) {
        [_delegate sendDataWithTitle:self.lbTitle WithSelectedBtn:self.btnSelected];
    }
    
}
@end
