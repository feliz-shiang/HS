//
//  GYCartModel.h
//  HSConsumer
//
//  Created by 00 on 14-12-19.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYCartModel : NSObject



//方式选择页面传值用数组
@property (strong, nonatomic) NSArray *arrSelWay;
@property (assign, nonatomic) NSInteger tag;//方式选择tag值

@property (assign, nonatomic) NSInteger payTag;//支付方式tag值


//新属性

@property (nonatomic , assign) BOOL hid;
@property (nonatomic , assign) NSInteger type;

@property (nonatomic , copy) NSString *strPayWayTitle;//支付方式
@property (nonatomic , copy) NSString *strPayWay;


@property (nonatomic , copy) NSString *strPWTitlt;//不同密码标题
@property (nonatomic , copy) NSString *strPWPlaceHolder;


@property (nonatomic , strong) NSArray *arrTitle;//jsaon数据
@property (nonatomic , strong) NSArray *arrData;

@property (nonatomic , strong) NSArray *testData1;//测试数据1
@property (nonatomic , strong) NSArray *testData2;//测试数据2


@property (nonatomic , strong) NSArray *netTitle;//测试数据3
@property (nonatomic , strong) NSArray *netData;//测试数据4





@end
