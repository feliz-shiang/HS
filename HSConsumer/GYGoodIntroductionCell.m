//
//  GYGoodIntroductionCell.m
//  HSConsumer
//
//  Created by Apple03 on 15-5-18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYGoodIntroductionCell.h"
#import "GYGoodIntroductionModel.h"

@interface GYGoodIntroductionCell ()
@property (nonatomic,weak) UITextView * tvDetail;
@end

@implementation GYGoodIntroductionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    GYGoodIntroductionCell * cell = [tableView dequeueReusableCellWithIdentifier:strDetailIdent];
    if (cell == nil) {
        cell = [[GYGoodIntroductionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strDetailIdent];
    }
    return  cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UITextView * tvDetail =[[UITextView alloc] init];
        tvDetail.userInteractionEnabled = NO;

        tvDetail.backgroundColor = kDefaultVCBackgroundColor;
        tvDetail.font = kDetailFont;
        [self.contentView addSubview:tvDetail];
        self.tvDetail = tvDetail;
    }
    return self;
}
-(void)setModel:(GYGoodIntroductionModel *)model
{
    _model = model;
    
    self.tvDetail.text = [NSString stringWithFormat:@"  %@",self.model.strData];
}
-(void)layoutSubviews
{
    
    CGFloat height =30;
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        self.tvDetail.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.model.fHight>height?(self.model.fHight):(self.model.fHight+20));
         self.tvDetail.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.frame.size.height);
//        self.contentView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.model.fHight>height?(self.model.fHight+height+40):(self.model.fHight+20));
        
        CGRect cellRect = self.contentView.frame;
        cellRect.size.height= self.frame.size.height;
        self.contentView.frame=cellRect;
        NSLog(@"%@-----frme",NSStringFromCGRect(self.contentView.frame));
            NSLog(@"%@---cell--frme",NSStringFromCGRect(self.frame));
    }
    else
    {
        self.tvDetail.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.model.fHight+30);
        self.contentView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.model.fHight>height?(self.model.fHight+height):(self.model.fHight+20));
    }
}
@end
