//
//  GYCartGoodsCell.h
//  HSConsumer
//
//  Created by 00 on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYCartGoodsCellDelegate <NSObject>

-(void)isSelCell:(BOOL)isSel :(NSIndexPath *)indexPath;

-(void)changeCount:(NSInteger)count :(NSIndexPath *)indexPath;
-(void)delCell:(NSIndexPath *)indexPath;
-(void)showSetCountViewGoodsNum:(NSInteger)goodsNum withRow:(NSInteger)row;

@end


@interface GYCartGoodsCell : UITableViewCell<UITextFieldDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property(nonatomic,copy)NSString *ShopID;
//数据属性
@property (assign, nonatomic) NSInteger num;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) CGFloat pv;
@property (assign, nonatomic) BOOL isSel;
@property (strong , nonatomic) NSIndexPath *indexPath;
@property (nonatomic, strong) UINavigationController *nav;///跳转时候添加的导航栏

@property (weak, nonatomic) IBOutlet UIView *vMain;//cell底图

@property (weak, nonatomic) IBOutlet UIButton *btnEnterShop;

@property (weak, nonatomic) IBOutlet UIImageView *imgLOGO;//店LOGO图

@property (weak, nonatomic) IBOutlet UILabel *lbShopName;//店名

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;//垃圾桶


@property (weak, nonatomic) IBOutlet UILabel *lbLine;//分隔线1
@property (weak, nonatomic) IBOutlet UILabel *lbLine2;//分隔线2
@property (weak, nonatomic) IBOutlet UILabel *lbLineBig;//分隔线大


@property (weak, nonatomic) IBOutlet UILabel *lbGoodName;//产品名字
@property (weak, nonatomic) IBOutlet UILabel *lbColor;//参数，例如表盘颜色
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;//单价
@property (weak, nonatomic) IBOutlet UILabel *lbNumBIg;//数量
@property (weak, nonatomic) IBOutlet UILabel *lbPriceTotal;//总价钱
@property (weak, nonatomic) IBOutlet UILabel *lbPV;//PV数

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;//图片
@property (weak, nonatomic) IBOutlet UIButton *btnCut;//减按钮
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;//加按钮
@property (weak, nonatomic) IBOutlet UITextField *tfNum;//输入框

@property (weak, nonatomic) IBOutlet UIButton *btnSel;//选中按钮

// songjk 添加营业点
@property (weak, nonatomic) IBOutlet UIView *vShopName;
@property (weak, nonatomic) IBOutlet UILabel *lbShopNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbShopNameDetail;

@property (nonatomic,assign) NSInteger goodsNum;//商品的库存总数


@property (assign, nonatomic) id<GYCartGoodsCellDelegate> delegate;

-(void)setData;



@end
