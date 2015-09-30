//
//  GYResultView.h
//  company
//
//  Created by Apple03 on 15-4-25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYResultView;

@protocol GYResultViewDelegate <NSObject>
@optional
-(void)ResultViewConfrimButtonClicked:(GYResultView *)ResultView success:(BOOL)success;


@end

@interface GYResultView : UIView
@property (nonatomic,copy) NSString * strResultInfo;
@property (nonatomic,assign) BOOL bSuccess;

@property (nonatomic,weak) id<GYResultViewDelegate>delegate;

-(void)show;
-(void)showWithView:(UIView *)view status:(BOOL)bStatus message:(NSString *)message;
@end
