//
//  CellHSMsgCell.h
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#define kCellHSMsgCellIdentifier @"CellHSMsgCellIdentifier"

#import <UIKit/UIKit.h>
#import "ViewHSMsgContentBkg.h"
#import "GYChatItem.h"

@interface CellHSMsgCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbDatetime;
@property (nonatomic,strong) GYChatItem * chatItem;//消息体
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbContent;
@property (strong, nonatomic) IBOutlet ViewHSMsgContentBkg *viewContentBkg;
@property (strong, nonatomic) UINavigationController *nav;

+ (CGFloat)getHeightIsShowDatetime:(BOOL)show;

@end
