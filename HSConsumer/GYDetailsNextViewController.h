//
//  GYDetailNextViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//查看详情

typedef NS_ENUM(NSUInteger, EMDetailsCode) {
    kDetailsCode_Point = 0, //积分账户明细
    kDetailsCode_Cash = 1,  //货币账户明细
    kDetailsCode_HSDToCash = 2,  //流通币明细
    kDetailsCode_HSDToCon = 3,  //消费币明细
    kDetailsCode_InvestPoint = 4,  //投资账户-积分投资明细
    kDetailsCode_InvestDividends = 5,  //投资账户-投资分红明细,
    kDetailsCode_BusinessPro = 6  //业务办理查询
};

#import <UIKit/UIKit.h>

@interface GYDetailsNextViewController : UIViewController

@property (strong, nonatomic) NSString *strTradeSn;     //交易流水号
@property (nonatomic, assign) EMDetailsCode detailsCode;//账户类型
@property (strong, nonatomic) NSDictionary *dicTransCodes; //交易类型字典
@property (strong, nonatomic) NSDictionary *dicDetailsProperty;  //传过来的字典属性文件
@property (strong, nonatomic) NSDictionary *dicCurrencyCodes;  //货币代码字典
@property (strong, nonatomic) NSDictionary *dicItem;  //d
@property (strong, nonatomic) NSString *strTransString; //传过来的交易类型


//@property (strong, nonatomic) NSString *transToAcc;  //转入账户

//@property (assign, nonatomic) NSInteger detailRows;//
//@property (assign, nonatomic) NSInteger rowAmountIndex;

@end
