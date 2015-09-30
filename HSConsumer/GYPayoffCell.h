//
//  GYPayoffCell.h
//  HSConsumer
//
//  Created by 00 on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYCartModel.h"


// add by songjk 营业点空间大小
//#define KShopNameWidth 185
//#define KShopNameHeight 21
//#define KShopNameFont [UIFont systemFontOfSize:15]

@class GYPayoffCell;

@protocol GYPayoffCellDelegate <NSObject>
@optional
-(void)pushSelWayViewWithModel:(NSMutableArray *)arrData;

-(void)returnbtn:(NSString *)isDrawed WithIndex:(NSInteger)index;

-(void)pushSelShop:(NSInteger)index;

-(void)pushSelDiscount:(NSInteger)index;

-(void)pushSelWayWithMArray:(NSMutableArray *)mArray WithIndexPath:(NSIndexPath *)indexPath;

// add by songjk 选择抵扣券
-(void)PayoffCellDidSelectedDiscountWithCell:(GYPayoffCell *)cell isDiscount:(BOOL)discount index:(NSInteger)index;
// songjk 申请互生卡代理
-(void)PayoffCellDidSelectedApplyHScardWithCell:(GYPayoffCell *)cell isApplyHScard:(BOOL)hsCard index:(NSInteger)index;
@end

@interface GYPayoffCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (strong ,nonatomic) NSIndexPath *indexPath;


@property (weak, nonatomic) IBOutlet UITableView *tbv;//tableView

@property (weak, nonatomic) IBOutlet UILabel *lbShopName;//店名
@property (weak, nonatomic) IBOutlet UILabel *lbGoodsNum;//该店铺商品数量
@property (weak, nonatomic) IBOutlet UILabel *lbTotalPrice;//该店铺商品总价
@property (weak, nonatomic) IBOutlet UILabel *lbTotalPV;//该店铺商品总PV
@property (weak, nonatomic) IBOutlet UIButton *btnSelWay;//配送方式选择按钮

@property (weak, nonatomic) IBOutlet UIButton *btnSelShop;//选择实体店按钮

@property (weak, nonatomic) IBOutlet UILabel *lbBill;//发票抬头lb
//modify by zhangqy  换行显示
@property (weak, nonatomic) IBOutlet UITextView *tfBill;//发票抬头tf
@property (weak, nonatomic) IBOutlet UILabel *lbLeaveWord;//买家留言lb
@property (weak, nonatomic) IBOutlet UITextView *tfLeaveWord;//买家留言tf

@property (weak, nonatomic) IBOutlet UIButton *btnDiscount;//优惠券按钮
// add by songjk 显示快递
@property (weak, nonatomic) IBOutlet UIView *vExpress;
// add by songjk 是否是快递
@property (assign, nonatomic) BOOL isExpress;
@property (assign, nonatomic) id<GYPayoffCellDelegate>delegate;//代理



@property (weak, nonatomic) IBOutlet UILabel *lbLine1;
@property (weak, nonatomic) IBOutlet UILabel *lbLine2;
@property (weak, nonatomic) IBOutlet UILabel *lbLine3;
@property (weak, nonatomic) IBOutlet UILabel *lbLine4;

@property (weak, nonatomic) IBOutlet UILabel *lbLineBig;
@property (weak, nonatomic) IBOutlet UIButton *btnAppleHSCard;
@property (weak, nonatomic) IBOutlet UILabel *lbApplyHSCard;
// add by songjk营业点
@property (weak, nonatomic) IBOutlet UILabel *lbShopNameInfo;

@property (strong , nonatomic) NSMutableArray *mArrGoodsList;
@property (nonatomic,copy ) NSString * strPictureUrl;
@property (nonatomic,copy) NSString * isRightAway;


@property (strong , nonatomic) NSString *isPayOnDelivery;

@property (copy,nonatomic)NSString * strShopName; // 营业点名次 songjk
-(void)reloadTbv;


// add by songjk 设置抵扣券显示文字
-(void)setDiscountShowWithInfo:(NSString * )info;
// songjk 是否可以申请互生卡
-(void)setCanApplyCardWithInfo:(NSString *)info;
@end
