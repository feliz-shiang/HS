//
//  GYEasyBuyViewController.h
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//   逛商品

#import "DropDownWithChildChooseProtocol.h"

#import <UIKit/UIKit.h>
#import "DropDownWithChildListView.h"
#import "SearchGoodModel.h"
#import "JGActionSheet.h"


@interface GYBuyGoodViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DropDownWithChildChooseDataSource,DropDownWithChildChooseDelegate,deleteTableviewInSectionOne,JGActionSheetDelegate>

@property (strong , nonatomic) SearchGoodModel *modelCommins;
@property (nonatomic,copy) NSString * strSpecialService;
@property (nonatomic,weak)id  <sendTitleText> delegate;

@end
