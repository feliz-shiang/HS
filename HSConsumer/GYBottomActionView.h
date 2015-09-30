//
//  GYBottomActionView.h
//  SelfActionSheetTest
//
//  Created by Apple03 on 15/8/4.
//  Copyright (c) 2015年 Apple03. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYBottomActionView;
@class GYBottomActionViewItemModel;
@protocol GYBottomActionViewDelegate <NSObject>

-(void)BottomActionView:(GYBottomActionView*)BottomActionView model:(GYBottomActionViewItemModel*)model;

@end


@interface GYBottomActionView : UIView

@property (nonatomic,strong) NSArray * arrList;
@property (nonatomic,weak) id<GYBottomActionViewDelegate> delegate;
-(instancetype)initWithView:(UIView *)view arrayData:(NSArray *)arrayData;
-(void)show;
@end






@interface GYBottomActionViewItemModel : NSObject
@property (nonatomic,assign) NSInteger type;// 1为普通 2为带头像
@property (nonatomic,copy) NSString * strImgName;
@property (nonatomic,copy) NSString * strTitle;
@property (nonatomic,assign) BOOL  isSelect;
@property (nonatomic,assign) BOOL  isAdd;
@end