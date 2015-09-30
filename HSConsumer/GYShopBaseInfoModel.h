//
//  GYShopBaseInfoModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/8/25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
//"currentPageIndex": 0,
//"data": {
//    "addr": "广东省深圳市南山区科技园科苑路",
//    "area": "南山区",
//    "bePre": false,
//beFocus false
//    "city": "深圳市",
//    "companyResourceNo": "06114000001",
//    "evacount": 37,
//    "hotline": "22222222222222",
//    "id": "2426810730267648",
//    "images": [
//               {}
//               ],
//    "introduce": "",
//    "lat": "22.55065",
//    "longitude": "113.955186",
//    "name": "",
//    "picList": [
//                {
//                    "url": "http://192.168.228.97:9099/v1/tfs/T1KNdTBXZT1RXrhCrK.jpg"
//                },
//                {
//                    "url": "http://192.168.228.97:9099/v1/tfs/T1KNdTBXZT1RXrhCrK.jpg"
//                }
//                ],
//    "province": "广东省",
//    "rating": 4.414414414414415,
//    "shops": [
//              {
//                  "addr": "广东省深圳市福田区福田区华富路21号",
//                  "id": "2419553707279360",
//                  "lat": "22.550269",
//                  "longitude": "114.087903",
//                  "name": "",
//                  "tel": "58888888"
//              },
//              {
//                  "addr": "广东省深圳市南山区科技园科苑路",
//                  "id": "2426810730267648",
//                  "lat": "22.55065",
//                  "longitude": "113.955186",
//                  "name": "",
//                  "tel": "22222222222222"
//              },
//              {
//                  "addr": "广东省深圳市福田区岗厦",
//                  "id": "2429652871300096",
//                  "lat": "22.527985",
//                  "longitude": "114.06062",
//                  "name": "",
//                  "tel": "444444"
//              },
//              {
//                  "addr": "广东省深圳市罗湖区翠竹",
//                  "id": "2445227357062144",
//                  "lat": "22.560966",
//                  "longitude": "114.133051",
//                  "name": "",
//                  "tel": "2233"
//              },
//              {
//                  "addr": "广东省深圳市福田区市民广场",
//                  "id": "2445229355140096",
//                  "lat": "22.547881",
//                  "longitude": "114.066283",
//                  "name": "",
//                  "tel": "5676876"
//              }
//              ],
//    "vShopId": "2338691435086848",
//    "vShopName": "深圳互商成员",
//    "vShopUrl": "http://06114000001.hsec.net/modules/vShop/tpl/vShop.html"
//},
//"msg": null,
//"retCode": 200,
//"rows": null,
//"totalPage": 0
@interface GYShopBaseInfoModel : NSObject
@property (nonatomic,copy) NSString * addr;
@property (nonatomic,copy) NSString * area;
@property (nonatomic,assign) BOOL  bePre;
@property (nonatomic,assign) BOOL  beFocus;
@property (nonatomic,copy) NSString * city;
@property (nonatomic,copy) NSString * companyResourceNo;
@property (nonatomic,copy) NSString * evacount;
@property (nonatomic,copy) NSString * hotline;
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * introduce;
@property (nonatomic,copy) NSString * lat;
@property (nonatomic,copy) NSString * longitude;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * province;
@property (nonatomic,copy) NSString * rating;
@property (nonatomic,copy) NSString * vShopId;

@property (nonatomic,copy) NSString * vShopName;
@property (nonatomic,copy) NSString * vShopUrl;

@property (nonatomic,strong) NSArray * images;
@property (nonatomic,strong) NSArray * picList;
@property (nonatomic,strong) NSArray * shops;
@end

@interface GYShopBaseInfoPicListModel : NSObject
@property (nonatomic,copy) NSString * url;
@end

@interface GYShopBaseInfoImagesModel : NSObject

@end

@interface GYShopBaseInfoShopsModel : NSObject
@property (nonatomic,copy) NSString * addr;
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * longitude;
@property (nonatomic,copy) NSString * lat;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * tel;
@end

