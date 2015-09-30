//
//  GYBankListModel.m
//  HSConsumer
//
//  Created by apple on 15-1-27.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYBankListModel.h"

@implementation GYBankListModel

//编码
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_strBankCode forKey:@"bankCode"];
    [aCoder encodeObject:_strBankAddress forKey:@"BankAddress"];
    [aCoder encodeObject:_strBankName forKey:@"BankName"];
    [aCoder encodeObject:_strBankNo forKey:@"BankNo"];
    [aCoder encodeObject:_strCreated forKey:@"Created"];
    [aCoder encodeObject:_strFullName forKey:@"FullName"];
    [aCoder encodeObject:_strIsPage forKey:@"IsPage"];
    [aCoder encodeObject:_strSettleCode forKey:@"SettleCode"];
    [aCoder encodeObject:_strUpdated forKey:@"Updated"];
    [aCoder encodeObject:_strIsDisplayStart forKey:@"IsDisplayStart"];
    [aCoder encodeObject:_strEnName forKey:@"EnName"];

}


//解码
-(id)initWithCoder:(NSCoder *)aDecoder
{

    if (self =[super init]) {
        
        _strBankCode = [aDecoder decodeObjectForKey:@"bankCode"];
        _strBankAddress = [aDecoder decodeObjectForKey:@"BankAddress"];
        _strBankName = [aDecoder decodeObjectForKey:@"BankName"];
        _strBankNo = [aDecoder decodeObjectForKey:@"BankNo"];
        _strCreated = [aDecoder decodeObjectForKey:@"Created"];
        _strFullName = [aDecoder decodeObjectForKey:@"FullName"];
        _strIsPage = [aDecoder decodeObjectForKey:@"IsPage"];
        _strSettleCode = [aDecoder decodeObjectForKey:@"SettleCode"];
        _strUpdated = [aDecoder decodeObjectForKey:@"Updated"];
        _strIsDisplayStart = [aDecoder decodeObjectForKey:@"IsDisplayStart"];
        _strEnName = [aDecoder decodeObjectForKey:@"EnName"];
 
    }
    

    return self;
}

@end
