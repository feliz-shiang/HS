//
//  DropDownListView.h
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownListViewDelegate <NSObject>

@optional
- (void)menuDidSelectIsChange:(BOOL)isChange withObject:(id)sender;

@end

@interface DropDownListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isHideBackground;
@property (nonatomic, assign) id<DropDownListViewDelegate> delegate;

- (id)initWithArray:(NSArray *)array parentView:(UIView *)superView widthSenderFrame:(CGRect)f;
- (BOOL)isShow;
- (void)hideExtendedChooseView;
-(void)showChooseListView;

@end
