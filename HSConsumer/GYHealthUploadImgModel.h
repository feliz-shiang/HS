//
//  GYHealthUploadImgModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/7/24.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KtitleFont [UIFont systemFontOfSize:12]
#define KshowFont [UIFont systemFontOfSize:10]

@interface GYHealthUploadImgModel : NSObject
@property (nonatomic,copy) NSString * strTitle;
@property (nonatomic,assign) BOOL isNeed;

@property (nonatomic,assign)CGRect picFrame;
@property (nonatomic,assign)CGRect needFrame;
@property (nonatomic,assign)CGRect titleFrame;
@property (nonatomic,assign)CGRect showTempFrame;
@property (nonatomic,assign)CGRect mainFrame;
// 是否显示事例图片
@property (nonatomic,assign)BOOL isShow;
@end
