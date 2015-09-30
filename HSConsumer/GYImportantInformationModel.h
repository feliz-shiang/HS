//
//  GYImportantInformationModel.h
//  HSConsumer
//
//  Created by apple on 14-12-9.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYImportantInformationModel : NSObject
@property (nonatomic,copy)NSString * strUserName;//用户姓名
@property (nonatomic,copy)NSString * strUserSex;//用户性别
@property (nonatomic,copy)NSString * strUserNationlilty;//用户国籍
@property (nonatomic,copy)NSString * strUserCertificationType;//证件类型
@property (nonatomic,copy)NSString * strUserCertificationNumber;//证件号码
@property (nonatomic,strong)NSMutableArray * marrImages;//图片数组
@end
