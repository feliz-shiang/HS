//
//  GYOrderRefundDetailsViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kCellDatetimeHeight 40.f

#import "GYOrderRefundDetailsViewController.h"
#import "ViewForRefundDetailsLeft.h"
#import "ViewForRefundDetailsRight.h"

@interface GYOrderRefundDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrResult;
@property (assign, nonatomic) BOOL isCardUser;
@property (strong, nonatomic) UserData *user;

@end

@implementation GYOrderRefundDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //初始化设置tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView.tableHeaderView setHidden:YES];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    self.arrResult = [NSMutableArray array];
    [self getDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 3;
    return self.arrResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *cellID = @"cell";

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    UIView *view = nil;
    UILabel *lbNickName = nil;
    CGRect rect = cell.bounds;
    CGFloat labelH = kCellDatetimeHeight;
    CGFloat fontSize = 13.f;
    
    switch (row)
    {
        case 0:
        {
            NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewForRefundDetailsLeft class]) owner:self options:nil];
            ViewForRefundDetailsLeft *v = [subviewArray objectAtIndex:0];
            rect = v.frame;
            rect.origin.y = labelH+10;
            v.frame = rect;
            
            [v setValues:self.arrResult[row]];
            
            view = v;
            
            
            rect = cell.bounds;
            rect.size.height = labelH;
            rect.size.width = 160.f;
            rect.origin.x = 10.f;
            rect.origin.y = 17.f;
            lbNickName = [[UILabel alloc] initWithFrame:rect];
            [lbNickName setTextAlignment:UITextAlignmentLeft];
//            [lbNickName setText:self.arrResult[row][0]];
            [lbNickName setFont:[UIFont systemFontOfSize:fontSize]];

        }
            break;
        default:
        {
            NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewForRefundDetailsRight class]) owner:self options:nil];
            ViewForRefundDetailsRight *v = [subviewArray objectAtIndex:0];
            rect = v.frame;
            rect.origin.x = cell.frame.size.width - rect.size.width;
            rect.origin.y = labelH+10;
            v.frame = rect;
            
            if (row == 1)
            {
                [v setShowTypeIsResult:NO];
            }else if (row == 2)
            {
                [v setShowTypeIsResult:YES];
            }

            [v setValues:self.arrResult[row]];
            view = v;
            
            rect = cell.bounds;
            rect.size.height = labelH;
            rect.size.width = 180.f;
            rect.origin.x = cell.bounds.size.width - rect.size.width -10.0f;
            rect.origin.y +=15;
            lbNickName = [[UILabel alloc] initWithFrame:rect];
            [lbNickName setTextAlignment:UITextAlignmentRight];
//            [lbNickName setText:@"xxx李李李"];
            [lbNickName setFont:[UIFont systemFontOfSize:fontSize]];
            
        }
            break;
    }
    
    [cell.contentView addSubview:view];
    
    rect = cell.bounds;
    rect.size.height = labelH;
    UILabel *dataTime = [[UILabel alloc] initWithFrame:rect];
    [dataTime setTextAlignment:UITextAlignmentCenter];
    [dataTime setText:self.arrResult[row][1]];
    [dataTime setFont:[UIFont systemFontOfSize:fontSize]];
#warning LBNICKNAME FIX
    NSString *userNickName = self.arrResult[row][0];
    if (!self.isCardUser) {
        if (!userNickName||userNickName.length<1) {
            userNickName = self.user.phoneNumber;
            if (userNickName&&userNickName.length>10) {
    
            NSString *pre = [userNickName substringToIndex:3];
            NSString *end = [userNickName substringFromIndex:7];
            userNickName = [[pre stringByAppendingString:@"****"] stringByAppendingString:end];
            }
        }
        else
        {
            
        }
            
    }
    else
    {
        if (!userNickName||userNickName.length<1) {
            userNickName = self.user.cardNumber;
        }
        else
        {
            userNickName = [NSString stringWithFormat:@"%@(%@)",userNickName,self.user.cardNumber];
        }
    }
    [lbNickName setText:userNickName];
    [lbNickName setTextColor:kCellItemTextColor];
    [dataTime setTextColor:kCellItemTextColor];

    lbNickName.numberOfLines = 1;
    lbNickName.minimumFontSize = 10;
    lbNickName.adjustsFontSizeToFitWidth = YES;
    
    [Utils setFontSizeToFitWidthWithLabel:dataTime labelLines:1];
    
    [dataTime setBackgroundColor:kClearColor];//ios6
    [lbNickName setBackgroundColor:kClearColor];
    [cell.contentView addSubview:dataTime];
    [cell.contentView addSubview:lbNickName];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:kDefaultVCBackgroundColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 1)
    {
        return 60.f + kCellDatetimeHeight;
    }else if (row == 2)
    {
        return 109 + kCellDatetimeHeight + 30;//30用于让最后一个cell离底边保持高度
    }
    
//    return 136.f + kCellDatetimeHeight;
    return 140.f + kCellDatetimeHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    GYGoodsDetailController * vcGoodDetail = kLoadVcFromClassStringName(NSStringFromClass([GYGoodsDetailController class]));
//    vcGoodDetail.model = self.arrResult[indexPath.row];
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vcGoodDetail animated:YES];
}

#pragma - get details
- (void)getDetails
{
    if (!_orderID) return;
    
    GlobalData *data = [GlobalData shareInstance];
    self.isCardUser = data.isCardUser;
    self.user = data.user;
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"refId": _orderID
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getRefundInfo"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    dic = dic[@"data"];
                    NSLog(@"dic=%@",dic);
                    NSArray *arr0 = @[kSaftToNSString(dic[@"nickName"]),//顺序不可变
                                      kSaftToNSString(dic[@"createTime"]),//顺序不可变
                                      kSaftToNSString(dic[@"refundType"]),
                                      kSaftToNSString(dic[@"goodsStatus"]),
                                      kSaftToNSString(dic[@"price"]),
                                      kSaftToNSString(dic[@"point"]),
                                      kSaftToNSString(dic[@"reasonDesc"])
                                      ];
                    [self.arrResult addObject:arr0];
//                    NSLog(@"confirmResult:%@, %@", kSaftToNSString(dic[@"confirmResult"]), dic[@"confirmResult"]);
                    if (dic[@"confirmResult"] && kSaftToNSInteger(dic[@"confirmResult"]) != 0)
                    {
                        NSArray *arr1 = @[kSaftToNSString(dic[@"refunder"]),//顺序不可变
                                          kSaftToNSString(dic[@"confirmDate"]),//顺序不可变
                                          kSaftToNSString(dic[@"refundType"]),
                                          kSaftToNSString(dic[@"confirmResult"]),//商家确认结果，1 不退款，其它退款
                                          kSaftToNSString(dic[@"confirmDesc"])
                                          ];
                        [self.arrResult addObject:arr1];
                    }
                    
                    if ([kSaftToNSString(dic[@"refundResult"]) isEqualToString:@"6"] ||
                        [kSaftToNSString(dic[@"refundResult"]) isEqualToString:@"7"])
                    {
                        NSArray *arr2 = @[kSaftToNSString(dic[@"refunder"]),//顺序不可变 index:0
                                          kSaftToNSString(dic[@"refundDate"]),//顺序不可变 index:1
                                          kSaftToNSString(dic[@"refundType"]),//index:2
                                          kSaftToNSString(dic[@"refundResult"]),//商家确认结果，1 不退款，其它退款 //index:3
                                          kSaftToNSString(dic[@"price"]),       //index:4
                                          kSaftToNSString(dic[@"point"]),       //index:5
                                          kSaftToNSString(dic[@"refundDesc"]),  //index:6
                                          kSaftToNSString(dic[@"refundId"])  //index:7
                                          ];
                        [self.arrResult addObject:arr2];
                    }
//
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"查询退款详情失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"查询退款详情失败." isPopVC:nil];
            }
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

@end
