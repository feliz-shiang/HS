//
//  GYEasyBuyViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//   逛商铺

#import "DropDownWithChildChooseProtocol.h"
#import <UIKit/UIKit.h>
#import "DropDownWithChildListView.h"
#import <BaiduMapAPI/BMapKit.h>
#import "JGActionSheet.h"





@interface GYFindShopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DropDownWithChildChooseDataSource,DropDownWithChildChooseDelegate,deleteTableviewInSectionOne,BMKLocationServiceDelegate,JGActionSheetDelegate>

@property (nonatomic,weak) id  <sendTitleText> delegate;


@property (nonatomic , copy) NSString *modelTitle;
@property (nonatomic , copy) NSString *modelID;

//下面好评 综合 人气的传值
@property (nonatomic , copy) NSString * strSortType;
@property (nonatomic , assign) BOOL FromBottomType;//之前业务需求中，周边逛findshopviewcontroller上面的topSelectView 中BTN显示title和来自下面的分类不一样。在此添加此变量作为标示。



@end
