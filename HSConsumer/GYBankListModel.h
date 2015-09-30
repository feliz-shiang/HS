//
//  GYBankListModel.h
//  HSConsumer
//
//  Created by apple on 15-1-27.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYBankListModel : NSObject<NSCoding>
@property (nonatomic,copy)NSString * strBankCode;
@property (nonatomic,copy)NSString * strBankAddress;
@property (nonatomic,copy)NSString * strBankName;
@property (nonatomic,copy)NSString * strBankNo;
@property (nonatomic,copy)NSString * strCreated;
@property (nonatomic,copy)NSString * strFullName;
@property (nonatomic,copy)NSString * strIsPage;
@property (nonatomic,copy)NSString * strSettleCode;
@property (nonatomic,copy)NSString * strUpdated;
@property (nonatomic,copy)NSString * strIsDisplayStart;
@property (nonatomic,copy)NSString * strEnName;
@end
