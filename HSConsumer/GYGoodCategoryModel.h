//
//  GYGoodCategoryModel.h
//  HSConsumer
//
//  Created by apple on 15-1-20.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYGoodCategoryModel : NSObject
@property (nonatomic,copy)NSString * strCategoryTitle;
@property (nonatomic,copy)NSString * strCategoryId;
@property (nonatomic,strong)NSMutableArray * marrSubCategory;

@end
