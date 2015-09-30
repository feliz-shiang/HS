//
//  GYParameterCell.m
//  HSConsumer
//
//  Created by 00 on 15-2-5.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYParameterCell.h"
#import "UIView+CustomBorder.h"
@implementation GYParameterCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ////先算出右边label的高度
        self.lbTitle.frame=CGRectMake(15, 11,95, 21);
        
        [self.contentView addSubview:self.lbTitle];
        
        CGSize siz=[self labelHeght:self.model.value];
        self.lbContent.frame=CGRectMake(15, 11, siz.width ,siz.height);
        self.lbContent.numberOfLines=0;
        [self.contentView addSubview:self.lbContent];
        
    }
    
    return self;
}
////label  的高度计算
-(CGSize)labelHeght:(NSString *)string{
    CGSize size=[string sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(self.bounds.size.width-15-self.lbTitle.bounds.size.width-2, 10000.f) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}


- (void)awakeFromNib {
    ////先算出右边label的高度
    self.lbTitle.frame=CGRectMake(15, 11,95, 21);
    
    [self.contentView addSubview:self.lbTitle];
    
    CGSize siz=[self labelHeght:self.model.value];
    self.lbContent.frame=CGRectMake(15, 11, siz.width ,siz.height);
    self.lbContent.numberOfLines=0;
    [self.contentView addSubview:self.lbContent];

}

-(void)layoutSubviews{
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
