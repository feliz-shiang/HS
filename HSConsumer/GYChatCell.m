//
//  ChatCell.m
//  Chat
//
//  Created by 00 on 15-1-9.
//  Copyright (c) 2015年 00. All rights reserved.
//


#import "GYChatCell.h"
#import "GYChatTap.h"
#import "UIImageView+WebCache.h"


@implementation GYChatCell

// add by songjk增加复制粘贴文本
- (void)awakeFromNib
{
    [self makeView];
    UILongPressGestureRecognizer * pgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    pgr.minimumPressDuration = 0.5;
    [self addGestureRecognizer:pgr];
}

-(void)longPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateBegan)
    {
        return;
    }

    NSMutableArray *arrMenuItems = [NSMutableArray array];
    if (self.chatItem.msg_Type == kMsg_Type_Immediate_Chat && self.chatItem.msg_Code == kMsg_Code_Picture_Msg)
//    if ([self.chatItem.content  isEqualToString: @"[图片]"])
    {
        if (self.chatItem.isSelf && self.chatItem.msgSendState == kMessagSentState_Send_Failed)//发送失败的图片不弹出
        {
            return;
        }
        
        UIMenuItem *saveImgLink = [[UIMenuItem alloc] initWithTitle:@"保存到相册"
                                                          action:@selector(saveImageToPhotos:)];
        UIMenuItem *delMsgLink = [[UIMenuItem alloc] initWithTitle:@"删除"
                                                            action:@selector(delMsg:)];
        [arrMenuItems addObject:delMsgLink];
        [arrMenuItems addObject:saveImgLink];
        
    }else if (self.chatItem.msg_Type == kMsg_Type_Immediate_Chat && self.chatItem.msg_Code == kMsg_Code_Text_Msg)
    {
        UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"
                                                          action:@selector(copyMsg:)];
        UIMenuItem *delMsgLink = [[UIMenuItem alloc] initWithTitle:@"删除"
                                                            action:@selector(delMsg:)];
        [arrMenuItems addObject:copyLink];
        [arrMenuItems addObject:delMsgLink];

    }else return;
    
    [self becomeFirstResponder];
    CGRect frame;
    if ([self.self.imgLeft isHidden])
    {
        frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+30, self.frame.size.width, self.frame.size.height-20);
    }
    else{
        frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+30, self.frame.size.width, self.frame.size.height-20);
    }
    [[UIMenuController sharedMenuController] setMenuItems:nil];
    [[UIMenuController sharedMenuController] setMenuItems:arrMenuItems];
    [[UIMenuController sharedMenuController] setTargetRect:frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}
// 为了能接收到事件（能成为第一响应者），我们需要覆盖一个方法：
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyMsg:) ||
        action == @selector(delMsg:) ||
        action == @selector(saveImageToPhotos:)
        )
    {
        return YES;
    }
    return NO;
}

//针对于响应方法的实现
-(void)delMsg:(id)sender
{
    if (self.chatDelegate && [self.chatDelegate respondsToSelector:@selector(deleteMessage:)])
    {
        [self.chatDelegate deleteMessage:self];
    }
}

-(void)saveImageToPhotos:(id)sender
{
    if (self.chatDelegate && [self.chatDelegate respondsToSelector:@selector(saveImageToPhotos:)])
    {
        [self.chatDelegate saveImageToPhotos:self];
    }
}

-(void)copyMsg:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.chatItem.content;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)makeView{
//文字气泡
    UIImage* leftImage = [UIImage imageNamed:@"ReceiverTextNodeBkg.png"];
    UIImage* rightImage = [UIImage imageNamed:@"SenderTextNodeBkg.png"];
    //在35行35列像素上进行拉伸
    
    leftImage = [leftImage stretchableImageWithLeftCapWidth:35 topCapHeight:40];
    rightImage = [rightImage stretchableImageWithLeftCapWidth:35 topCapHeight:40];
    
//图片气泡
    UIImage* leftImg = [UIImage imageNamed:@"upBgL.png"];
    UIImage* rightImg = [UIImage imageNamed:@"upBgR.png"];
    //在35行35列像素上进行拉伸
    
    leftImg = [leftImg stretchableImageWithLeftCapWidth:35 topCapHeight:60];
    rightImg = [rightImg stretchableImageWithLeftCapWidth:35 topCapHeight:60];
    
    
    //左边
    self.imgLeft.image = leftImage;

    self.imgPicBubbleL.image = leftImg;
    [self.imgLeft addSubview:self.vLeft];
    [self.imgLeft addSubview:self.imgPicL];
    [self.imgPicL addSubview:self.imgPicBubbleL];
    
    //右边
    self.imgRight.image = rightImage;

    self.imgPicBubbleR.image = rightImg;
    [self.imgRight addSubview:self.vRight];
    [self.imgRight addSubview:self.imgPicR];
    [self.imgPicR addSubview:self.imgPicBubbleR];

    self.imgFL.layer.masksToBounds = YES;
    self.imgFL.layer.cornerRadius = 3;
    
    self.imgFR.layer.masksToBounds = YES;
    self.imgFR.layer.cornerRadius = 3;

}

// 点击好友头像显示好友信息
-(void)showInfo
{
    if ([self.chatDelegate respondsToSelector:@selector(ChatCellShowFriendInfo:)]) {
        [self.chatDelegate ChatCellShowFriendInfo:self];
    }
}
-(void)setHiddenCell
{
    self.aiv.hidden = YES;//活动指示器
    self.btnR.hidden = YES;//右按钮
    
//    DDLogInfo(@"self.chatItem.img === %@",self.chatItem.img);
    NSString *imgUrlTo = kSaftToNSString(self.chatItem.msgIcon);
    if (![imgUrlTo hasPrefix:@"http"]) {
        imgUrlTo = [NSString stringWithFormat:@"%@%@", [GlobalData shareInstance].tfsDomain, imgUrlTo];
    }
    [self.imgFL sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrlTo]] placeholderImage:kLoadPng(@"defaultheadimg")];
    UITapGestureRecognizer *showInfo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInfo)];
    self.imgFL.userInteractionEnabled = YES;
    [self.imgFL addGestureRecognizer:showInfo];
    
    NSString *imgUrl = kSaftToNSString([GlobalData shareInstance].IMUser.strHeadPic);
    if (![imgUrl hasPrefix:@"http"]) {
        imgUrl = [NSString stringWithFormat:@"%@%@", [GlobalData shareInstance].tfsDomain, imgUrl];
    }
    [self.imgFR sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:kLoadPng(@"defaultheadimg")];
//    
//    [self.imgFL sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.chatItem.msgIcon]] placeholderImage:kLoadPng(@"defaultheadimg")];
//    [self.imgFR sd_setImageWithURL:[NSURL URLWithString:[GlobalData shareInstance].IMUser.strHeadPic] placeholderImage:kLoadPng(@"defaultheadimg")];//设置自己的头像
//    [self.imgFR sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.chatItem.msgIcon]] placeholderImage:kLoadPng(@"defaultheadimg")];
    
    if (self.indexPath.row > 1) {
        
        GYChatItem* beforeChatItem = self.arrData[self.indexPath.row -1];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        
        NSDate  *date1 = [formatter dateFromString :beforeChatItem.dateTimeSend ];
        NSDate  *date2 = [formatter dateFromString :self.chatItem.dateTimeSend ];

        if (date1 && date2)//20分钟内不显示信息时间
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            unsigned int unitFlags = NSCalendarUnitMinute;
            NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1  toDate:date2  options:0];
            int minute = [comps minute];
            
            if (minute < 20) {
                
                self.lbTime.hidden = YES;
            }else{
                self.lbTime.hidden = NO;
            }
        }else
        {
            self.lbTime.hidden = YES;
        }
    }
    
    if (self.isPic) {
        
        //添加点击手势，用于放大图片
        self.imgLeft.userInteractionEnabled = YES;
        self.imgRight.userInteractionEnabled = YES;
        self.imgPicL.userInteractionEnabled = YES;
        self.imgPicR.userInteractionEnabled = YES;
        self.imgPicBubbleL.userInteractionEnabled = YES;
        self.imgPicBubbleR.userInteractionEnabled = YES;
        
        if (self.isSelf) {
            self.imgFL.hidden = YES;
            self.imgLeft.hidden = YES;//左文字气泡
            self.imgPicL.hidden = YES;//左图片
            self.imgPicBubbleL.hidden = YES;//左图片气泡
            self.vLeft.hidden = YES;
            
            self.imgFR.hidden = NO;//右头像
            self.vRight.hidden = YES;
            self.imgRight.hidden = NO;//右文气泡
            self.imgPicR.hidden = NO;//右图片
            self.imgPicBubbleR.hidden = NO;//右图片气泡
            
            if (self.chatItem.msgSendState == kMessagSentState_Sending) {
                [self.aiv startAnimating];
                self.aiv.hidden = NO;
            }else if(self.chatItem.msgSendState == kMessagSentState_Send_Failed){
                [self.aiv stopAnimating];
                self.aiv.hidden = YES;
                self.btnR.hidden = NO;
            }else if (self.chatItem.msgSendState == kMessagSentState_Sent)
            {
                [self.aiv stopAnimating];
                self.aiv.hidden = YES;
            }

            [self.imgPicR sd_setImageWithURL:[NSURL URLWithString:self.chatItem.pictureRUL] placeholderImage:self.chatItem.img completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                self.chatItem.img = self.imgPicR.image;
                CGSize imgSize;
                
                if (image) {
                    imgSize = [self imgWithImage:image];
                }else{
                    imgSize = [self imgWithImage:self.chatItem.img];
                }
                
                //右边图片
                self.imgPicR.frame = CGRectMake(0, 0, imgSize.width + 30, imgSize.height + 20);
                //右边图片气泡
                self.imgPicBubbleR.frame = CGRectMake(0, 0, imgSize.width + 30, imgSize.height + 20);
                //右边文本气泡
                self.imgRight.frame = CGRectMake(280 - imgSize.width - 40, 30, imgSize.width + 30, imgSize.height + 20);
                //设置图片
                self.imgPicR.image = self.chatItem.img;
                self.btnR.frame = CGRectMake(self.imgRight.frame.origin.x - 5 - 36, 31, 36,36);
                //活动指示器位置
                self.aiv.frame = CGRectMake(280 - imgSize.width - 40, 30, imgSize.width + 25, imgSize.height + 20);
                self.aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
                self.aiv.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                self.aiv.layer.cornerRadius = 4.0;
            }];
            
   
                        
        }else{
            self.imgFL.hidden = NO;
            self.vLeft.hidden = YES;
            self.imgLeft.hidden = NO;//左文字气泡
            self.imgPicL.hidden = NO;//左图片
            self.imgPicBubbleL.hidden = NO;//左图片气泡
            
            self.imgFR.hidden = YES;//右头像
            self.vRight.hidden = YES;
            self.imgRight.hidden = YES;//右文气泡
            self.imgPicR.hidden = YES;//右图片
            self.imgPicBubbleR.hidden = YES;//右图片气泡
            
            //图片
            [self.imgPicL sd_setImageWithURL:[NSURL URLWithString:self.chatItem.pictureRUL] placeholderImage:kLoadPng(@"ep_placeholder_image_type1") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                self.chatItem.img = self.imgPicL.image;
                CGSize imgSize;
                if (image) {
                    imgSize = [self imgWithImage:image];
                }else{
                    imgSize = [self imgWithImage:self.chatItem.img];
                }
                
                //右边图片
                self.imgPicL.frame = CGRectMake(0, 0, imgSize.width + 30, imgSize.height + 20);
                //右边图片气泡
                self.imgPicBubbleL.frame = CGRectMake(0, 0, imgSize.width + 30, imgSize.height + 20);
                //右边文本气泡
                self.imgLeft.frame = CGRectMake(50, 30, imgSize.width + 30, imgSize.height + 20);
                //设置图片
                self.imgPicL.image = image ;

                
            }];
            
            
        }
        
    }else{
        
        if (self.isSelf) {
            self.imgFL.hidden = YES;
            self.vLeft.hidden = YES;
            self.imgLeft.hidden = YES;//左文字气泡
            self.imgPicL.hidden = YES;//左图片
            self.imgPicBubbleL.hidden = YES;//左图片气泡
            
            self.imgFR.hidden = NO;//右头像
            self.vRight.hidden = NO;
            self.imgRight.hidden = NO;//右文气泡
            self.imgPicR.hidden = YES;//右图片
            self.imgPicBubbleR.hidden = YES;//右图片气泡

            //self.vRight = marrDataView[self.indexPath.row];
            
            self.aiv.frame = self.btnR.frame;
            
            if (self.chatItem.msgSendState == kMessagSentState_Sending) {
                [self.aiv startAnimating];
                self.aiv.hidden = NO;
            }else if(self.chatItem.msgSendState == kMessagSentState_Send_Failed){
                [self.aiv stopAnimating];
                self.aiv.hidden = YES;
                self.btnR.hidden = NO;
            }else if (self.chatItem.msgSendState == kMessagSentState_Sent)
            {
                [self.aiv stopAnimating];
                self.aiv.hidden = YES;
                
            }
            
            CGSize size = CGSizeMake(self.vRight.frame.size.width, self.vRight.frame.size.height);
            
            
            if (self.vRight.frame.size.width == MAX_WIDTH) {
                self.imgRight.frame = CGRectMake(280 - self.vRight.frame.size.width - 40 - 5, 30, size.width + 28 + 5, size.height);
                
            }else{
                self.imgRight.frame = CGRectMake(280 - self.vRight.frame.size.width - 40, 30, size.width + 28, size.height);
                
            }
            
            //            self.imgRight.frame = CGRectMake(280 - self.vRight.frame.size.width - 40, 20, size.width + 28, size.height);
            self.vRight.frame = CGRectMake(7, 11, self.vRight.frame.size.width, self.vRight.frame.size.height);
            
            
            
            self.btnR.frame = CGRectMake(self.imgRight.frame.origin.x - 5 - 36, 31, 36,36);
            //活动指示器位置
            self.aiv.frame = self.btnR.frame;
            
            [self.imgRight addSubview:self.vRight];
            
        }else{
            self.imgFL.hidden = NO;
            self.vLeft.hidden = NO;
            self.imgLeft.hidden = NO;//左文字气泡
            self.imgPicL.hidden = YES;//左图片
            self.imgPicBubbleL.hidden = YES;//左图片气泡
            
            self.imgFR.hidden = YES;//右头像
            self.vRight.hidden = YES;
            self.imgRight.hidden = YES;//右文气泡
            self.imgPicR.hidden = YES;//右图片
            self.imgPicBubbleR.hidden = YES;//右图片气泡

            // self.vLeft = marrDataView[indexPath.row];
            
            CGSize size = CGSizeMake(self.vLeft.frame.size.width, self.vLeft.frame.size.height);
            
            if (self.vLeft.frame.size.width == MAX_WIDTH) {
                self.imgLeft.frame = CGRectMake(50, 30, size.width + 28 + 5, size.height);
                
            }else{
                self.imgLeft.frame = CGRectMake(50, 30, size.width + 28, size.height);
                
            }
            self.vLeft.frame = CGRectMake(18, 11, self.vLeft.frame.size.width, self.vLeft.frame.size.height);
            [self.imgLeft addSubview:self.vLeft];

        }
    }
}



- (CGSize)imgWithImage:(UIImage *)image{
    
    //创建消息体，获取图片

    CGSize size = CGSizeZero;
    CGFloat rect;
    
    if (image.size.width >= image.size.height) {
        rect = image.size.width/image.size.height;
        size.width = 100.0f;
        size.height = 100.0f/rect;
    }else
    {
        rect = image.size.height/image.size.width;
        size.height = 100.0f;
        size.width = 100.0f/rect;
    }
    
    return size;
}


@end
