//
//  GYSMSTableViewCell.m
//  HSConsumer
//
//  Created by 00 on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYSMSTableViewCell.h"

@implementation GYSMSTableViewCell
{
    NSMutableDictionary *dic;

}

//选择按钮点击事件
- (IBAction)btnTickClick:(UIButton *)sender {
    
    NSLog(@"%ld",(long)self.tag);
    //[self.delegate tickCell:self];
    NSNumber *isTick = [NSNumber numberWithBool:YES];
    isTick = [dic valueForKey:[NSString stringWithFormat:@"%ld",(long)self.tag]];
    NSLog(@"改变前%@",isTick);
    bool ooo = [isTick boolValue];
    NSLog(@"ooooo=%d",ooo);
    ooo = !ooo;
    isTick = [NSNumber numberWithBool:ooo];
    [dic setValue:[NSString stringWithFormat:@"%d",ooo] forKey:[NSString stringWithFormat:@"%ld",(long)self.tag]];
    NSLog(@"改变后%@",isTick);
    if ([isTick boolValue]) {
        [_btnSMSCell setImage:[UIImage imageNamed:@"cell_btn_tick_green_yes.png"] forState:UIControlStateNormal];
    }else{
        [_btnSMSCell setImage:[UIImage imageNamed:@"cell_btn_tick_green_no.png"] forState:UIControlStateNormal];
    }
}


- (void)awakeFromNib
{
    //字典需要修改为网络请求回来的状态数据
    dic = [[NSMutableDictionary alloc] init];
    [dic setValuesForKeysWithDictionary:@{@"100000": @NO,@"100001": @NO,@"100002": @NO,@"100003": @NO,@"100004": @NO,@"100005": @NO,}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
