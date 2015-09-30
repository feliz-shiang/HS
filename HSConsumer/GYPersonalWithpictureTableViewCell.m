//
//  GYPersonalWithpictureTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYPersonalWithpictureTableViewCell.h"

@implementation GYPersonalWithpictureTableViewCell

- (void)awakeFromNib
{
    // Initialization code
   // self.contentView.backgroundColor=[UIColor yellowColor];
    self.imgAvater.layer.masksToBounds=YES;
    self.imgAvater.layer.cornerRadius=self.imgAvater.frame.size.height*0.5;
    
    
    
    
}



@end
