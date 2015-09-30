//
//  GYMsgCell.h
//  XFZHD
//
//  Created by 00 on 14-12-25.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYMsgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;//头像
@property (weak, nonatomic) IBOutlet UILabel *lbRedPoint;//小红圈
@property (weak, nonatomic) IBOutlet UIImageView *imgRedPointBg;//红圈背景

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;//昵称

@property (weak, nonatomic) IBOutlet UILabel *lbDate;//日期

@property (weak, nonatomic) IBOutlet UILabel *lbMsg;//消息


@end
