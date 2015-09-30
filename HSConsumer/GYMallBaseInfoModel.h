//
//  GYMallBaseInfoModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/9/1.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

typedef void (^dictResult)(NSDictionary * dictData, NSError *error);
#import <Foundation/Foundation.h>
//{
//    "currentPageIndex": 0,
//    "data": {
//        "beFocus": false,
//        "companyResourceNo": "06124020000",
//        "introduce": "商城描述",
//        "isApplyCard": 1,
//        "picList": [
//                    {
//                        "url": "http://192.168.228.97:9099/v1/tfs/T1iFxTByVT1RXrhCrK.jpg"
//                    },
//                    {
//                        "url": "http://192.168.228.97:9099/v1/tfs/T1iXxTByVT1RXrhCrK.jpg"
//                    }
//                    ],
//        "rate": 5,
//        "shops": [
//                  {
//                      "addr": "广东省深圳市福田区福中路18号",
//                      "id": "2413883241251840",
//                      "lat": "22.546988",
//                      "longitude": "114.076969",
//                      "tel": "0755-83344111"
//                  },
//                  {
//                      "addr": "广东省深圳市南山区腾讯大厦",
//                      "id": "2419212640879616",
//                      "lat": "22.539167",
//                      "longitude": "113.936959",
//                      "tel": "0755-83344111"
//                  }
//                  ],
//        "vShopName": "神雕侠侣",
//        "vShopUrl": "http://06124020000.hsec.net/modules/vShop/tpl/vShop.html"
//    },
//    "msg": null,
//    "retCode": 200,
//    "rows": null,
//    "totalPage": 0
//}
@interface GYMallBaseInfoModel : NSObject
@property (nonatomic,assign) BOOL  beFocus;
@property (nonatomic,copy) NSString * companyResourceNo;
@property (nonatomic,copy) NSString * introduce;
@property (nonatomic,copy) NSString * isApplyCard;
@property (nonatomic,copy) NSString * rate;
@property (nonatomic,copy) NSString * vShopName;
@property (nonatomic,copy) NSString * vShopUrl;
@property (nonatomic,strong) NSArray * picList;
@property (nonatomic,strong) NSArray * shops;


#pragma mark 加载商城详情
+(void)loadBigShopDataWithVshopid:(NSString *)vShopID result:(dictResult)result;
@end

@interface GYMallBaseInfoPicListModel : NSObject
@property (nonatomic,copy) NSString * url;
@end


@interface GYMallBaseInfoShopsModel : NSObject
@property (nonatomic,copy) NSString * addr;
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * longitude;
@property (nonatomic,copy) NSString * lat;
@property (nonatomic,copy) NSString * tel;
@end
