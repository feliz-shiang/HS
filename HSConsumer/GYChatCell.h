//
//  ChatCell.h
//  Chat
//
//  Created by 00 on 15-1-9.
//  Copyright (c) 2015年 00. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYChatItem.h"
#import "GYChatTap.h"


#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 162
@class GYChatCell;
@protocol GYChatCellDelegate <NSObject>

@optional
- (void)deleteMessage:(id)sender;
- (void)saveImageToPhotos:(id)sender;
- (void)ChatCellShowFriendInfo:(GYChatCell *)ChatCell;
@end

@interface GYChatCell : UITableViewCell
{

    CGRect screen;
}
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (strong , nonatomic) NSIndexPath *indexPath;
@property (strong , nonatomic) GYChatItem *chatItem;
@property (strong , nonatomic) NSMutableArray *arrData;
@property (strong , nonatomic) GYChatTap *tap;


@property (weak, nonatomic) IBOutlet UIImageView *imgFL;//左头像
@property (weak, nonatomic) IBOutlet UIImageView *imgLeft;//左文字气泡
@property (weak, nonatomic) IBOutlet UIImageView *imgPicL;//左图片
@property (weak, nonatomic) IBOutlet UIImageView *imgPicBubbleL;//左图片气泡
@property (weak, nonatomic) UIView *vLeft;

@property (weak, nonatomic) IBOutlet UIImageView *imgFR;//右头像
@property (weak, nonatomic) IBOutlet UIImageView *imgRight;//右文气泡
@property (weak, nonatomic) IBOutlet UIButton *btnR;//右按钮
@property (weak, nonatomic) IBOutlet UIImageView *imgPicR;//右图片
@property (weak, nonatomic) IBOutlet UIImageView *imgPicBubbleR;//右图片气泡
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiv;//活动指示器
@property (weak, nonatomic) UIView *vRight;
@property (assign, nonatomic) id<GYChatCellDelegate> chatDelegate;//右图片气泡

@property (assign, nonatomic) BOOL isSelf;
@property (assign, nonatomic) BOOL isPic;

-(void)setHiddenCell;

@end
