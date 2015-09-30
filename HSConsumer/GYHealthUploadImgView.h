//
//  GYHealthUploadImgView.h
//  HSConsumer
//
//  Created by Apple03 on 15/7/24.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHealthUploadImgModel;
@class GYHealthUploadImgView;
@protocol GYHealthUploadImgViewDelegate <NSObject>
@optional
-(void)HealthUploadImgViewShowExampleWithButton:(UIButton *)button;
-(void)HealthUploadImgViewChooseImgWithButton:(UIButton *)button;
@end

@interface GYHealthUploadImgView : UIView
@property (nonatomic,strong) GYHealthUploadImgModel* model;
@property (nonatomic,weak) id<GYHealthUploadImgViewDelegate> delegate;

-(void)setShowTag:(NSInteger)showTag chooseImageTag:(NSInteger)chooseImageTag;
-(void)setImageWithImage:(UIImage *)image;
-(NSInteger)getImgChooseTag;
@end
