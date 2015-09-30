//
//  GYGoodDetailViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchGoodModel.h"
#import "JGActionSheet.h"


@interface GYGoodDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,JGActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnContactShop;
@property (weak, nonatomic) IBOutlet UIButton *btnBrowse;
@property (weak, nonatomic) IBOutlet UIView   *vBottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToShopCar;
@property (nonatomic,assign)BOOL fromHotGoods;

@property (weak, nonatomic) IBOutlet UIButton *btnContactShopPop;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToShopCarPop;
@property (weak, nonatomic) IBOutlet UIButton *btnBrowsePop;
@property (weak, nonatomic) IBOutlet UIButton *btnEnterShop;
@property (weak, nonatomic) IBOutlet UIButton *btnEnterShopPro;

@property (weak, nonatomic) IBOutlet UIView *vBottomViewPop;

@property (nonatomic,strong)SearchGoodModel * model;

@end
