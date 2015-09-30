//
//  GYShopHeader.h
//  HSConsumer
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYMallBaseInfoModel;
@class GYShopHeader;

@protocol ShopHeaderDelegate <NSObject>
@optional
-(void)ShopHeaderDidSelectPayAtentionBtn:(GYShopHeader*)header;
-(void)ShopHeaderDidSelectShowBigPicWithHeader:(GYShopHeader*)header index:(NSInteger)index;
@end


@interface GYShopHeader : UIView
+(instancetype)initWithXib;
+(CGFloat ) height;

@property (nonatomic,strong)GYMallBaseInfoModel * model;

@property (nonatomic,weak) id <ShopHeaderDelegate> delegate;

-(void)changePayAttentionBtnWithStatus:(BOOL)status;
@end
