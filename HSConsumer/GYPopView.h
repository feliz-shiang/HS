//
//  GYPopView.h
//  GYPopView
//
//  Created by 00 on 14-12-27.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPopView.h"

@protocol GYPopViewDelegate <NSObject>
@optional
-(void)pushVCWithIndex:(NSIndexPath *)indexPath;
-(void)deleteDataWithIndex:(NSIndexPath *)indexPath;
-(void)deleteDataWithIndex:(NSIndexPath *)indexPath WithSelectRow:(int)row;
-(void)didSelWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface GYPopView : UIView<UITableViewDataSource,UITableViewDelegate>


@property (strong , nonatomic) UITableView *popView;
@property (strong , nonatomic) NSArray *arrData;
@property (strong , nonatomic) NSArray *arrImg;
@property (strong , nonatomic) NSIndexPath *indexPath;


@property (assign , nonatomic) id<GYPopViewDelegate> delegate;

@property (assign , nonatomic) CGRect bigFrame;
@property (assign , nonatomic) CGRect smallFrame;
@property (strong , nonatomic) UIColor * bgColor;
@property (assign , nonatomic) NSInteger cellType;

-(id)initWithCellType:(NSInteger)cellType WithArray:(NSArray *)array WithImgArray:(NSArray *)imgArray WithBigFrame:(CGRect)bigFrame WithSmallFrame:(CGRect)smallFrame WithBgColor:(UIColor *)bgColor;


@end
