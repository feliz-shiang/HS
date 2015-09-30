//
//  GYImUserInfo.h
//  HSConsumer
//
//  Created by apple on 15-1-26.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYImUserInfo : NSObject

//以下登录返回
@property (nonatomic, copy) NSString *strAccountId;//
@property (nonatomic, copy) NSString *strAccountNo;//如： 06186010001
@property (nonatomic, copy) NSString *strAddress;//地址
@property (nonatomic, copy) NSString *strAge;//年龄
@property (nonatomic, copy) NSString *strArea;//
@property (nonatomic, copy) NSString *strBirthday;//生日
@property (nonatomic, copy) NSString *strBloodType;//血型
@property (nonatomic, copy) NSString *strCard;//是否有卡，c为有卡，nc为无卡
@property (nonatomic, copy) NSString *strCity;//城市
@property (nonatomic, copy) NSString *strCountry;//国家
@property (nonatomic, copy) NSString *strEmail;//电子邮件
@property (nonatomic, copy) NSString *strHeadPic;//用户头像URL
@property (nonatomic, copy) NSString *strId;//
@property (nonatomic, copy) NSString *strInterest;//兴趣
@property (nonatomic, copy) NSString *strMobile;//移动电话号码
@property (nonatomic, copy) NSString *strName;//真实姓名
@property (nonatomic, copy) NSString *strNickName;//用户昵称
@property (nonatomic, copy) NSString *strOccupation;//职业
@property (nonatomic, copy) NSString *strProvince;//
@property (nonatomic, copy) NSString *strQQNo;//QQ号
@property (nonatomic, copy) NSString *strResourceNo;//企业管理号
//@property (nonatomic, copy) NSString *strRows;//不知道是什么
@property (nonatomic, copy) NSString *strSchool;//学校
@property (nonatomic, copy) NSString *strSex;//性别
@property (nonatomic, copy) NSString *strSign;//个性签名
@property (nonatomic, copy) NSString *strStart;//
@property (nonatomic, copy) NSString *strTag;//
@property (nonatomic, copy) NSString *strTelNo;//固定电话号码
@property (nonatomic, copy) NSString *strUserId;//用户id
@property (nonatomic, copy) NSString *strWeixinNo;//微信号码
@property (nonatomic, copy) NSString *strZipNo;//邮编 518000headBigPic
@property (nonatomic, copy) NSString *strHeadBigPic;//用户大头像URL
@property (nonatomic, copy) NSString *strRemark;//备注
//以下为按需要添加
@property (nonatomic,copy) NSString *strIMLoginUser;//如： m_c_06186010001
@property (nonatomic,copy) NSString *strIMSubUser;//如： c_06186010001

- (void)setValuesFromDictionary:(NSDictionary *)dic;
@end
