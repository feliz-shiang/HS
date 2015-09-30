//
//  GYMakeEvaluationViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEvaluateGoodModel.h"
typedef void(^refreshListBlock)(GYEvaluateGoodModel*);
@interface GYMakeEvaluationViewController : UIViewController<UITextViewDelegate>


@property (nonatomic,strong)GYEvaluateGoodModel * model;


@property (nonatomic,copy)NSString * strComment;
//add by zhangqy 9295 iOS消费者--我的评价--待评价列表中商品评价提交跳转回列表后，此条评价还保留在待评价列表，需刷新才消失
@property (nonatomic,copy)refreshListBlock refreshListBlock;
@end
