//
//  GYPayoffViewController.m
//  HSConsumer
//
//  Created by 00 on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYPayoffViewController.h"
#import "GYAddresseeCell.h"
#import "GYPayoffCell.h"
#import "GYSelWayVC.h"
#import "UIView+CustomBorder.h"
#import "GYSelShopVC.h"

#import "GYPOSDealDetailViewController.h"
#import "GYPayoffModel.h"
#import "UPPayPlugin.h"
#import "GYGetAddressDelegate.h"

#import "GYGetPaymentTypeViewController.h"//选择支付方式

#import "GYPayoffWayChoose.h"
#import "GYIconPayTypeViewController.h"
#import "GYExpress.h"
#import "GYDisCountViewController.h"// 不需要跳转选择抵扣券
#import "UIImageView+WebCache.h"
#import "GYEPMyAllOrdersViewController.h"
#import "UIButton+enLargedRect.h"
#import "GYImgTap.h"
#import "MBProgressHUD.h"

#import "GYBuyGoodDetailModel.h"
#import "MJExtension.h"
#import "GYDiscountInfoModel.h"
#import "GYDiscountUseInfoModel.h"
#import "GYResultView.h"
typedef void (^Result)(BOOL result);
//zhangqy textView 代理
@interface GYPayoffViewController ()<GYSelWayDelegate,GYAddresseeCellDelegate,GYPayoffCellDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,GYSelShopDelegate, UPPayPluginDelegate,GYGetAddressDelegate,selectPaymentType,GYResultViewDelegate>
{
    
    __weak IBOutlet UITableView *tbv;
    
    NSString *strSelPayWay;//保存支付方式
    
    __weak IBOutlet UIView *vBtn;
    
    __weak IBOutlet UIButton *btnSubmitOrder;
    AddrModel *addrModel;//收获地址数据模型
    
    NSMutableArray *mArrJson;//json第一层数组
    NSMutableArray *mArrOrderList;//json第二层数组
    
    GYPayoffModel *payoffModel;
    
    //－－－－－－－－－－－－收货人信息－－－－－－－－－－－－－
    
    NSMutableString *strpostAge;
    NSString *strReceiver;//收件人
    NSString *strReceiverAddress;//收货地址
    NSString *strReceiverContact;//收件人电话
    NSString *strReceiverPostCode;//邮编
    
    //－－－－－－－－－－－－收货人信息－－－－－－－－－－－－－
    
    NSString *strDeliveryType;// 1 快递 2 实体店自提 3 送货上门，默认为1
    NSString *strInvoiceTitle;//发票台头
    NSString *strIsDrawed;//是否开具发票 0：默认不开具，1：开具
    NSString *strUserNote;//买家备注
    
    NSString *strShopID;//实体店ID
    NSString *strShopName;//实体店名
    NSString *strSendWay;//配送方法
    NSString *strDiscount;//优惠券
    
    NSString *discountJson;//优惠券信息
    NSString *discountSum;//优惠券金额
    
    NSString *payType;//支付类型
    NSString *sendType;//配送方式
    NSMutableArray * isDelivery;//支付方式
    
    GYPayoffWayChoose * footviewPayoffWay;//支付方式的VIEW
    
    NSMutableArray * marrShopid;//存放 shopid的ARR
    NSString * strIconpriceAmount;
    NSString * strIconpvAmount;
    
    int feePrice;//运费
    NSInteger  savedIndexPathRow;//代理传递的indexpath.row
    
}
@property (nonatomic,weak)UITextView *tvBill;
@property (nonatomic,weak)UITextView *tvLeaveWorld;

// add by songjk 保存所有商品
@property (nonatomic,strong) NSMutableArray * marrGoods;
// add by songjk 保存抵扣券和快递费信息
@property (nonatomic,strong) GYDiscountInfoModel * discountModel;
// add by songjk 记录第一次展示的默认快递
@property (nonatomic,strong) NSMutableDictionary * mdictShowExpress;
// add by songjk 记录用户使用抵扣券的情况
@property (nonatomic,strong) NSMutableArray * marrDiscountUse;
// add by songjk 记录用户已经使用抵扣券的情况
@property (nonatomic,strong) NSMutableArray * marrDiscountAlreadyUse;
@end

@implementation GYPayoffViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mArrShop = [[NSMutableArray alloc] init];
        marrShopid = [[NSMutableArray alloc]init];
    }
    return self;
}
-(NSMutableDictionary *)mdictShowExpress
{
    if (_mdictShowExpress==nil) {
        _mdictShowExpress = [NSMutableDictionary dictionary];
    }
    return _mdictShowExpress;
}
-(NSMutableArray *)marrDiscountUse
{
    if (!_marrDiscountUse) {
        _marrDiscountUse = [NSMutableArray array];
    }
    return _marrDiscountUse;
}
-(NSMutableArray *)marrDiscountAlreadyUse
{
    if (!_marrDiscountAlreadyUse) {
        _marrDiscountAlreadyUse = [NSMutableArray array];
    }
    return _marrDiscountAlreadyUse;
}
//提交按钮点击事件
- (IBAction)btnSubmit:(id)sender {
    
    if (strShopName.length == 0 || [strShopName isEqualToString:@"选择"]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请选择营业点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        
    }else{
        
        [self submitOrdersData];
        
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"确认订单";
    self.vBottomBackground.backgroundColor=[UIColor whiteColor];
    strDeliveryType = @"1";
    strInvoiceTitle = @"";
    strUserNote = @"";
    strShopID = @"";
    strDiscount = @"";
    strIsDrawed = @"0";
    discountSum = @"0";
    discountJson = @"";
    strpostAge=[@"0" mutableCopy];
    isDelivery=[NSMutableArray arrayWithObject:@"10"];
    payType=@"0";
    savedIndexPathRow=9999;
    
    for (NSDictionary * tempDict in self.mArrShop) {
        [marrShopid addObject:tempDict[@"shopId"]];
        
    }
    
    
    if ([marrShopid containsObject:@"0"]) {
        btnSubmitOrder.enabled=NO;
        [btnSubmitOrder setBackgroundColor:[UIColor grayColor]];
    }
    
    float price = 0;
    float pv = 0;
    
    for (NSMutableDictionary *dic in self.mArrShop) {
        price += [dic[@"actuallyAmount"] floatValue];
        pv += [dic[@"totalPoints"] floatValue];
        
    }
    
    self.lbPrice.text = [NSString stringWithFormat:@"%.2f",price];
    self.lbPV.text = [NSString stringWithFormat:@"%.2f",pv];
    strIconpriceAmount = [NSString stringWithFormat:@"%.2f",price];
    strIconpvAmount = [NSString stringWithFormat:@"%.2f",pv];
    
    [self initJsonData];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];
//    [self getNetData]; 当获取抵扣券之后再获取地址信息
    
    //添加边框
    [vBtn addAllBorder];
    
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbv.tableFooterView=[[UIView alloc]init];
    [tbv registerNib:[UINib nibWithNibName:@"GYAddresseeCell" bundle:nil] forCellReuseIdentifier:@"CELLTITLT"];
    [tbv registerNib:[UINib nibWithNibName:@"GYPayoffCell" bundle:nil] forCellReuseIdentifier:@"PayoffCELL"];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYPayoffWayChoose class]) owner:self options:nil];
    footviewPayoffWay = [subviewArray objectAtIndex:0];
    [footviewPayoffWay.btnChangePayoffWay setEnlargEdgeWithTop:5 right:60 bottom:5 left:40];
    [footviewPayoffWay.btnChangePayoffWay addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
    tbv.tableFooterView=footviewPayoffWay;
    
    // 获取抵扣券信息
    [self httpRequestForDiscountWithResult:^(BOOL result) {
//        if (result)
//        {
            [self getNetData];
//        }
    }];
}
#pragma  mark 进入支付页面
-(void)btnclicked:(UIButton *)sender
{
    if (isDelivery.count<=1) {
        [Utils showMessgeWithTitle:nil message:@"请选择配货方式" isPopVC:nil];
        return ;
    }
    
    if ([marrShopid containsObject:@"0"]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请完善订单信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [av show];
    }else
    {
        if (marrShopid.count>0) {
            NSString * strShopIdstring = [marrShopid  componentsJoinedByString:@","];
            
            GYGetPaymentTypeViewController * vcGetPayment = [[GYGetPaymentTypeViewController alloc]initWithNibName:@"GYGetPaymentTypeViewController" bundle:nil];
            
            NSMutableArray * marrDelivery =[NSMutableArray array];
            for (NSMutableDictionary *dic in self.mArrShop) {
                
                [marrDelivery addObject:dic[@"deliveryType"]];
                
            }
            
            if ([marrDelivery containsObject:@"1"]) {
                vcGetPayment.isDelivery=@"1";
            }else{
                vcGetPayment.isDelivery=@"0";
            }
            vcGetPayment.strShopid=strShopIdstring;
            vcGetPayment.delegate=self;
            [self.navigationController pushViewController:vcGetPayment animated:YES];
        }
        else{
            
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请选择营业点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [av show];
            
        }
        
    }
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.mArrShop.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 16;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    [view addAllBorder];
    
    return view;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 95;
    }else{
        
        NSMutableArray *mArrGoodsList = [self setGoodsList:self.mArrShop :indexPath];
        CGFloat height = 372 + 100*mArrGoodsList.count;
        // 根据营业点高度变化
//        NSMutableDictionary *dic = self.mArrShop[indexPath.row];
//        if (!dic[@"shopName"]||[dic[@"shopId"] isEqualToString:@"0"]) {
//            strShopName = @"请选择营业点";
//        }else
//        {
//            strShopName = dic[@"shopName"];
//            if ([strShopName isEqualToString:@"<null>"]) {
//                strShopName = @"请选择营业点";
//            }
//        }
//        // 计算营业点控件位置
//        CGFloat shopNameW = KShopNameWidth;
//        CGFloat shopNameH = KShopNameHeight;
//        CGSize shopNameSize = [Utils sizeForString:strShopName font:KShopNameFont width:shopNameW];
//        if (shopNameSize.height>shopNameH)
//        {
//            height = height - shopNameH + shopNameSize.height;
//        }
//        
        return height; //259 + 100*mArrGoodsList.count
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        GYAddresseeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLTITLT"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.indexPath = indexPath;
        
        if (!strSelPayWay) {
            strSelPayWay =@"网银支付";
        }
        [cell.btnSelWay setTitle:strSelPayWay forState:UIControlStateNormal];
        
        if (addrModel) {
            
            cell.btnChangeAddress.hidden=YES;
            cell.lbAddressee.text = [NSString stringWithFormat:@"收货人:%@", addrModel.consignee];
            if ([addrModel.area isEqualToString:@"<null>"]) {
//                cell.lbAddress.text = [NSString stringWithFormat:@"%@%@%@",addrModel.province,addrModel.city,addrModel.detail];
            }else{
                cell.lbAddress.text = [NSString stringWithFormat:@"%@%@%@%@",addrModel.province,addrModel.city,addrModel.area,addrModel.detail];
            }
            cell.lbAddress.text = [NSString stringWithFormat:@"收货地址:%@",cell.lbAddress.text];
            
        }
        cell.lbPhone.text = addrModel.mobile;
        
        strReceiver =  addrModel.consignee;
        strReceiverAddress = cell.lbAddress.text;
        //add by zhangqy 解决收货地址问题
        if ([strReceiverAddress hasPrefix:@"收货地址"]) {
            strReceiverAddress = [strReceiverAddress substringFromIndex:5];
        }
        strReceiverContact = addrModel.mobile;
        strReceiverPostCode = addrModel.PostCode;
        
        return cell;
        
    }
    else
    {
        
        GYPayoffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayoffCELL"];
        
        //zhangqy
//        [cell.tfBill addTarget:self action:@selector(cellTfBillEditingChanged:) forControlEvents:UIControlEventEditingChanged];
//        [cell.tfLeaveWord addTarget:self action:@selector(cellTfLeaveWordEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        //
        
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        NSMutableDictionary *dic = self.mArrShop[indexPath.row];
        
        if (!dic[@"isDrawed"]) {
            [dic setValue:@"0" forKey:@"isDrawed"];
        }
        
        if (!dic[@"shopName"]||[dic[@"shopId"] isEqualToString:@"0"]) {
            strShopName = @"请选择营业点";
        }else{
          
            strShopName = dic[@"shopName"];
            
            
            if ([strShopName isEqualToString:@"<null>"]) {
                strShopName = @"请选择营业点";
            }
            
        }

        //－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
        // add by songjk 显示抵扣券
        NSString * strDiscountInof = @"";
        if (self.discountModel)
        {
            NSArray * arrDiscountList = self.discountModel.orderCouponList;
            if (arrDiscountList.count>0)
            {
                for (GYDiscountFeeModel * feeModel in arrDiscountList)
                {
                    // modify by songjk 传入vshopid改为shopId
                    NSString * strShopid = feeModel.orderKey ;
                    NSArray * arrDiscountFeeDetailList = feeModel.list;
                    // 目前只有一种抵扣券 以后可能有多种
                    if (arrDiscountFeeDetailList.count>0 && [strShopid isEqualToString:dic[@"shopId"]])
                    {
                        GYDiscountFeeDetailModel * ditailModel = arrDiscountFeeDetailList[0];
                        // 判断可用抵扣券
                        NSString * strCanUse = ditailModel.num;
                        // 检查是否为使用的
                        for (GYDiscountUseInfoModel * model in self.marrDiscountAlreadyUse)
                        {
                            if (![model.orderKey isEqualToString:dic[@"shopId"]])
                            {
                                for (GYDiscountUseInfoModel * infoModel  in self.marrDiscountUse)
                                {
                                    if ([infoModel.couponId isEqualToString:ditailModel.couponId])
                                    {
                                        NSInteger canUse = [infoModel.num integerValue]-[infoModel.useNum integerValue];
                                        if (canUse < [strCanUse integerValue])
                                        {
                                            strCanUse = [NSString stringWithFormat:@"%zi",canUse];
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                        
                        
                        NSString * strMoney = [NSString stringWithFormat:@"%zi",[strCanUse longLongValue]*[ditailModel.amount longLongValue]];
                        strDiscountInof = [NSString stringWithFormat:@"%@%@张,抵扣%@元",ditailModel.couponName,strCanUse,strMoney];
                        break;
                    }
                }

            }
            
            // 默认快递
            NSString * strIsShow = [self.mdictShowExpress objectForKey:indexPath];
            if (!strIsShow)
            {
                NSArray * arrExpressList = self.discountModel.expressFeeList;
                [self.mdictShowExpress setObject:@"1" forKey:indexPath];
                for (GYExpressFeeModel * model in arrExpressList)
                {
                    // modify by songjk vShopId 改为 shopId
                    if ([model.orderKey isEqualToString:dic[@"shopId"]])
                    {
                        GYExpress * eModel = [[GYExpress alloc] init];
                        eModel.strExpress = @"快递";
                        eModel.strExpressCode = @"1";
                        [self setExpressFeeWithExpress:eModel indexPath:indexPath fee:model.expressFee cell:cell];
                        break;
                    }
                }
            }
        }
        [cell setDiscountShowWithInfo:strDiscountInof];
                
        if (!dic[@"sendWay"]) {
            strSendWay = @"请选择配送方式";
        }else{
            strSendWay = dic[@"sendWay"];
        }
        // modif by songjk 营业点显示在 lbShopNameInfo 上面
//        [cell.btnSelShop setTitle:strShopName forState:UIControlStateNormal];
        cell.strShopName = strShopName;
        [cell.btnSelWay setTitle:strSendWay forState:UIControlStateNormal];
        
        // by songjk 抵扣券修改为是否选择使用 下面代码不用了
//        if (!dic[@"discount"]) {
//            strDiscount = @"未使用";
//        }else{
//            strDiscount = dic[@"discount"];
//        }
//        
//        [cell.btnDiscount setTitle:strDiscount forState:UIControlStateNormal];
        
        //－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
        NSMutableArray *mArray = dic[@"orderDetailList"];
        cell.mArrGoodsList = mArray;
        //cell 中商品的图片。
        cell.strPictureUrl = self.strPictureUrl;
        cell.isRightAway = self.isRightAway;
        cell.lbShopName.text = dic[@"vShopName"];
        
        float  price=0;
        float point=0;
        for (NSDictionary * dicTemp in mArray) {
            price += [dicTemp[@"price"] floatValue]*[dicTemp[@"quantity"] intValue];
            point += [dicTemp[@"point"] floatValue]*[dicTemp[@"quantity"] intValue];
        }
        
        cell.lbTotalPrice.text = [NSString stringWithFormat:@"%.2f",price];
        cell.lbTotalPV.text = [NSString stringWithFormat:@"%.2f",point];
        
        NSInteger goodsNum = 0;
        for (NSDictionary *dic in mArray) {
            goodsNum += [dic[@"quantity"] integerValue];
            
        }
        cell.lbGoodsNum.text = [NSString stringWithFormat:@"共%zi件商品",goodsNum];
        cell.tag = 20001 +indexPath.row;
        //zhangqy tfbill改为textView
        cell.tfBill.delegate = self;
//        _tvBill = cell.tfBill;
        cell.tfBill.tag = 800 + indexPath.row;
        cell.tfLeaveWord.delegate = self;
//        _tvLeaveWorld = cell.tfLeaveWord;
//        _tvLeaveWorld.delegate=self;
        cell.tfLeaveWord.tag = 900 + indexPath.row;
        
        // 是否可以申请互生卡
        BOOL isApply = false;
        for (NSDictionary *dictItem in mArray) {
            NSString * isApplyCard = [dictItem objectForKey:@"isApplyCard"];
            if ([isApplyCard isEqualToString:@"1"])
            {
                [cell setCanApplyCardWithInfo:@"申请赠送互生卡"];
                isApply = YES;
                break;
            }
        }
        if (!isApply) {
            [cell setCanApplyCardWithInfo:@""];
        }
        [cell reloadTbv];
        
        return cell;
    }
}
// add by songjk 设置快递
-(void)setExpressFeeWithExpress:(GYExpress*)model indexPath:(NSIndexPath*)indexPath fee:(NSString *)fee cell:(GYPayoffCell *)cell
{
    if ([cell.vExpress viewWithTag:(indexPath.row+100)]) {
//        UIView * v=[cell.contentView viewWithTag:(indexPath.row+100)];
//        [v removeFromSuperview];
        UIView * v=[cell.vExpress viewWithTag:(indexPath.row+100)];
        [v removeFromSuperview];
        cell.vExpress.hidden = YES;
        cell.btnSelWay.hidden=NO;
    }
    
    //返回运费
    strSelPayWay = model.strExpress;
    [isDelivery addObject:model.strExpressCode];
    strDeliveryType = model.strExpressCode;
    strSendWay = model.strExpress;
    
    float totalPrice;
    
    NSMutableDictionary *dic = self.mArrShop[indexPath.row];
    
    id obj = dic[@"changePostAge"];
    strpostAge = [fee mutableCopy];
    
    [dic setValue:model.strExpressCode forKey:@"deliveryType"];
    [dic setValue:strSendWay forKey:@"sendWay"];
    //             cell.btnSelWay.hidden=NO;
    //只有在 配送方式为1 时修改 运费 。并且添加 修改标示符 changePostAge
    //obj 不存在的时候，才能添加，避免重复添加运费
    UIView * v;
    if (![obj isEqualToString:@"1"]&&[model.strExpressCode isEqualToString:@"1"])
    {
        cell.btnSelWay.hidden=YES;
        cell.vExpress.hidden = NO;
        v =[[UIView alloc ]init];
        
//        CGRect FrameSelway = cell.btnSelWay.frame;
        CGRect FrameSelway = cell.vExpress.frame;
        v.frame=FrameSelway;
        v.tag=indexPath.row+100;
        UIFont * font = [UIFont systemFontOfSize:14.0];
        CGSize titleSize = [[NSString stringWithFormat:@"%.02f",[fee floatValue]] sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 100)];
        
        UILabel * lbPostAge =[[UILabel alloc]initWithFrame:CGRectMake(FrameSelway.size.width-titleSize.width-5, 0, titleSize.width, 30)];
        
        
        //                UIImageView * imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(lbPostAge.frame.origin.x-4-15-4, 5, 18, 18)];
        UIImageView * imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(lbPostAge.frame.origin.x - 18, 5, 18, 18)];
        imgvIcon.image=[UIImage imageNamed:@"hs_coin.png"];
        //                UILabel * lbExpress  = [[ UILabel alloc]initWithFrame:CGRectMake(lbPostAge.frame.origin.x-4-15-40-5, 0, 40, 30)];
        UILabel * lbExpress  = [[ UILabel alloc]initWithFrame:CGRectMake(imgvIcon.frame.origin.x - 38, 0, 38, 30)];
        lbExpress.text=model.strExpress;
        lbPostAge.textColor=kCellItemTitleColor;
        lbExpress.textColor=kCellItemTitleColor;
        
        
        lbExpress.textAlignment = NSTextAlignmentRight;
        lbExpress.backgroundColor=[UIColor clearColor];
        lbExpress.font= font;
        
        lbPostAge.text= [NSString stringWithFormat:@"%.02f",[fee floatValue]];
        lbPostAge.textAlignment = NSTextAlignmentRight;
        lbPostAge.backgroundColor=[UIColor clearColor];
        lbPostAge.font= font;
        [v addSubview:lbPostAge];
        [v addSubview:imgvIcon];
        [v addSubview:lbExpress];
        
        GYImgTap * tap = [[GYImgTap alloc]initWithTarget:self action:@selector(toPayWayVc:)];
        tap.tag=(int)indexPath.section;
        [v addGestureRecognizer:tap];
        
//        [cell.contentView addSubview:v];
        v.frame = CGRectMake(0, 0, v.frame.size.width, v.frame.size.height);
        [cell.vExpress addSubview:v];
        
        strSendWay = [NSString stringWithFormat:@"%@ ￥%@",model.strExpress,fee ];
        [dic setValue:strSendWay forKey:@"sendWay"];
        
        NSString * strActuallyAmount = dic[@"actuallyAmount"];
        float actuallAmount;
        actuallAmount = strActuallyAmount.floatValue+fee.floatValue;
        //添加了运费
        [dic setValue:strpostAge forKey:@"postAge"];
        
        [dic setValue:@(actuallAmount) forKey:@"actuallyAmount"];
        [dic setValue:@"1" forKey:@"changePostAge"];
        [dic setValue:fee forKey:@"fee"];
        totalPrice= strIconpriceAmount.floatValue +fee.floatValue;
        strIconpriceAmount=[NSString stringWithFormat:@"%.2f",totalPrice];
        
        //obj 存在说明 已经通过快递  添加了运费。减去运费
    }
    else if (obj&&![model.strExpressCode isEqualToString:@"1"])
    {
        if ([cell.vExpress viewWithTag:(indexPath.row+100)]) {
//            v=[cell.contentView viewWithTag:(indexPath.row+100)];
//            [v removeFromSuperview];
            UIView * v=[cell.vExpress viewWithTag:(indexPath.row+100)];
            [v removeFromSuperview];
            cell.vExpress.hidden = YES;
            cell.btnSelWay.hidden=NO;
        }
        
        [cell bringSubviewToFront:cell.btnSelWay];
        
        float  GetFee = [dic[@"fee"] floatValue];
        
        totalPrice= strIconpriceAmount.floatValue -GetFee;
        strIconpriceAmount=[NSString stringWithFormat:@"%.2f",totalPrice];
        NSString * strActuallyAmount = dic[@"actuallyAmount"];
        float actuallAmount;
        actuallAmount = strActuallyAmount.intValue-GetFee;
        [dic setValue:@(actuallAmount) forKey:@"actuallyAmount"];
        [dic removeObjectForKey:@"fee"];
        [dic removeObjectForKey:@"changePostAge"];
    }
    
    self.lbPrice.text=strIconpriceAmount;
}

- (void)cellTfBillEditingChanged:(UITextField*)textField
{
    int length = 20;
    NSString *str = textField.text;
    if (str.length>length) {
        textField.text = [str substringToIndex:length];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"发票抬头字数最多为%d",length] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }//
}

- (void)cellTfLeaveWordEditingChanged:(UITextField *)textField
{
    int length = 200;
    NSString *str = textField.text;
    if (str.length>length) {
        textField.text = [str substringToIndex:length];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"留言字数最多为%d",length] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row === %ld",(long)indexPath.row);
    
}


#pragma mark - GYAddresseeCellDelegate
-(void)pushSelWayVCWithmArray:(NSMutableArray *)mArray WithIndexPath:(NSIndexPath *)IndexPath
{
    
    GYSelWayVC *vc = [[GYSelWayVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - GYSelShopDelegate
-(void)pushSelShop:(NSInteger)index
{
    
    GYSelShopVC *vc = [[GYSelShopVC alloc] init];
    vc.title = @"选择营业点";
    vc.tag = index - 1;
    vc.delegate = self;
    vc.selIndex = index - 1;
    GYGoodsDetailModel *detailmodel = [[GYGoodsDetailModel alloc] init];
    NSMutableDictionary *dic = self.mArrShop[index - 1];
    NSMutableArray * marrGoodsId = [NSMutableArray array];
    
    for (NSDictionary * tempDic in dic[@"orderDetailList"]) {
        [marrGoodsId  addObject:tempDic[@"itemId"]];
    }
    
    detailmodel.vShopId = dic[@"vShopId"];
    detailmodel.goodsID= [marrGoodsId componentsJoinedByString:@","];
    vc.model = detailmodel;
    
    NSSet * set =[NSSet setWithArray:marrShopid];
    marrShopid=[[set allObjects] mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


-(void)pushSelAddrVC
{
    GYGetGoodViewController *vc = [[GYGetGoodViewController alloc] init];
    vc.deletage = self;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark  选择店铺后返回的数据

-(void)returnSelShopModel:(SelShopModel *)selShopModel selectIndex:(NSInteger)index tag:(NSInteger)tag WithShopid:(NSString *)shopid
{
    NSMutableDictionary *dic = self.mArrShop[index];
    strShopID = selShopModel.shopId;
    strShopName = selShopModel.shopName;
    [dic setValue:strShopID forKey:@"shopId"];
    [dic setValue:strShopName forKey:@"shopName"];
    
    //传过去的 shopid 是用来回调的时候删除
    [marrShopid removeObject:shopid];
    [marrShopid addObject:dic[@"shopId"]];
    [tbv reloadData];
}

#pragma mark - GYGetAddressDelegate

#warning 就是这里

-(void)getAddressModle:(GYAddressModel *)model
{
    
    addrModel = [[AddrModel alloc] init];
    addrModel.area = model.Area;
    addrModel.city = model.City;
    addrModel.consignee = model.CustomerName;
    addrModel.addrID = model.AddressId;
    addrModel.mobile = model.CustomerPhone;
    addrModel.province = model.Province;
    addrModel.detail = model.DetailAddress;
    addrModel.PostCode=model.PostCode;
    
    [tbv reloadData];
    
    
}
#pragma mark - GYPayoffCellDelegate

//选择配送方式
-(void)pushSelWayWithMArray:(NSMutableArray *)mArray WithIndexPath:(NSIndexPath *)indexPath
{
    //创建SelWay
    GYSelWayVC *vc = [[GYSelWayVC alloc] init];
    vc.indexPath = indexPath;
    vc.delegate = self;
    savedIndexPathRow=indexPath.row;
    
    if ([payType integerValue] == 1) {
        
    }else{
        
        vc.dictShopInfo = self.mArrShop[indexPath.row];
        
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


//点击开发票返回数据
-(void)returnbtn:(NSString *)isDrawed WithIndex:(NSInteger)index
{
    strIsDrawed = isDrawed;
    NSMutableDictionary *dic = self.mArrShop[index];
    [dic setValue:strIsDrawed forKey:@"isDrawed"];
    
}

// modify by songjk 不在请求抵扣券 改为是否选择抵扣券
-(NSMutableArray *)marrGoods
{
    if (_marrGoods == nil)
    {
        _marrGoods = [NSMutableArray array];
    }
    return _marrGoods;
}
// 是否选择使用抵扣券
-(void)PayoffCellDidSelectedDiscountWithCell:(GYPayoffCell *)cell isDiscount:(BOOL)discount index:(NSInteger)index
{
    NSMutableDictionary *dic = self.mArrShop[index - 1];
    if (discount)
    {
        DiscountModel * model = [[DiscountModel alloc] init];
        // add by songjk 显示抵扣券
        if (self.discountModel)
        {
            NSArray * arrDiscountList = self.discountModel.orderCouponList;
            if (arrDiscountList.count>0)
            {
                for (GYDiscountFeeModel * feeModel in arrDiscountList)
                {
                    // modify by songjk vshopid改为shopId
                    NSString * strShopid = feeModel.orderKey ;
                    NSArray * arrDiscountFeeDetailList = feeModel.list;
                    // 目前只有一种抵扣券 以后可能有多种
                    if (arrDiscountFeeDetailList.count>0 && [strShopid isEqualToString:dic[@"shopId"]])
                    {
                        GYDiscountFeeDetailModel * ditailModel = arrDiscountFeeDetailList[0];
                        // 判断可用抵扣券
                        NSString * strCanUse = ditailModel.num;
                        for (GYDiscountUseInfoModel * infoModel  in self.marrDiscountUse)
                        {
                            if ([infoModel.couponId isEqualToString:ditailModel.couponId])
                            {
                                NSInteger canUse = [infoModel.num integerValue]-[infoModel.useNum integerValue];
                                if (canUse < [strCanUse integerValue])
                                {
                                    strCanUse = [NSString stringWithFormat:@"%zi",canUse];
                                }
                                infoModel.useNum = [NSString stringWithFormat:@"%zi",[strCanUse integerValue]+[infoModel.useNum integerValue]];
                                // 记录已经使用的
                                GYDiscountUseInfoModel * model = [[GYDiscountUseInfoModel alloc] init];
                                model.couponId = infoModel.couponId;
                                model.useNum = strCanUse;
                                model.orderKey = dic[@"shopId"];
                                [self.marrDiscountAlreadyUse addObject:model];
                                break;
                            }
                        }
                        model.userCouponId = ditailModel.couponId;
                        model.couponName = ditailModel.couponName;
                        model.amount = ditailModel.num;
                        model.surplusNum = ditailModel.num;
                        model.faceValue = ditailModel.amount;
                        model.sum = [NSString stringWithFormat:@"%zi",[ditailModel.num longLongValue]*[ditailModel.amount longLongValue]];
                        [self returnDiscount:model WithIndex:index-1];
                        break;
                    }
                }
                
            }
        }
    }
    else
    {
        // 还原抵扣券使用到未使用
        for (GYDiscountUseInfoModel * model in self.marrDiscountAlreadyUse)
        {
            // modify by songjk vshopid改为shopId
            if ([model.orderKey isEqualToString:dic[@"shopId"]])
            {
                for (GYDiscountUseInfoModel * infoModel  in self.marrDiscountUse)
                {
                    if ([infoModel.couponId isEqualToString:model.couponId])
                    {
                        if ([infoModel.useNum integerValue]>=[model.useNum integerValue])
                        {
                            infoModel.useNum = [NSString stringWithFormat:@"%zi",[infoModel.useNum integerValue]- [model.useNum integerValue]];
                        }
                        [self.marrDiscountAlreadyUse removeObject:model];
                        break;
                    }
                }
                break;
            }
        }
        [dic setValue:@"" forKey:@"couponInfo"];
        [dic setValue:@"0" forKey:@"couponAmount"];

        NSString *actuallyAmount = [dic objectForKey:@"actuallyAmount"];
        double dactuallyAmount = actuallyAmount.floatValue + [dic[@"setDiscountFee"] floatValue];
        actuallyAmount = [NSString stringWithFormat:@"%.2f",dactuallyAmount];
        [dic setObject:actuallyAmount forKey:@"actuallyAmount"];
        
        CGFloat totalPrice= strIconpriceAmount.floatValue +[dic[@"setDiscountFee"] floatValue] ;
        strIconpriceAmount=[NSString stringWithFormat:@"%.2f",totalPrice];
        
        [dic removeObjectForKey:@"setDiscount"];
        [dic removeObjectForKey:@"setDiscountFee"];
        
        self.lbPrice.text=strIconpriceAmount;
    }
    [tbv reloadData];
}
// 申请互生卡代理事件
-(void)PayoffCellDidSelectedApplyHScardWithCell:(GYPayoffCell *)cell isApplyHScard:(BOOL)hsCard index:(NSInteger)index
{
    NSLog(@"是否申请互生卡改变了");
    NSMutableDictionary *dic = self.mArrShop[index - 1];
    NSString * strApplyHSCard = @"买家申请互生卡";
    NSString * struserNote = kSaftToNSString([dic objectForKey:@"userNote"]);
    if (hsCard)
    {
        if (struserNote.length>0)
        {
            [dic setObject:[struserNote stringByAppendingString:[NSString stringWithFormat:@";%@",strApplyHSCard]] forKey:@"userNote"];
        }
        else
        {
            [dic setObject:strApplyHSCard forKey:@"userNote"];
        }
    }
    else
    {
        if ([struserNote rangeOfString:strApplyHSCard].location != NSNotFound)
        {
            struserNote = [struserNote substringToIndex:struserNote.length - strApplyHSCard.length];
            if ([struserNote hasSuffix:@";"])
            {
                struserNote = [struserNote substringToIndex:struserNote.length-1];
            }
            [dic setObject:struserNote forKey:@"userNote"];
        }
    }
}
// add by songjk 获取抵扣券
-(void)httpRequestForDiscountWithResult:(Result)result
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    NSMutableArray * arrData = [NSMutableArray array];
    
    for(int i = 0 ;i<self.mArrShop.count;i++)
    {
        NSDictionary * dictOrderList = self.mArrShop[i];
        NSArray * arrGoodsList = [dictOrderList objectForKey:@"orderDetailList"];
        
        NSMutableArray * arrOrder = [NSMutableArray array];
        for (int j = 0; j<arrGoodsList.count; j++)
        {
            GYBuyGoodDetailModel * model = [GYBuyGoodDetailModel objectWithKeyValues:arrGoodsList[j]];
            NSDictionary *dictGood = [NSDictionary dictionaryWithObjectsAndKeys:model.itemId,@"itemId",model.subTotal,@"itemPrice",model.ruleId,@"ruleId",[dictOrderList objectForKey:@"vShopId"],@"vShopId",nil];
            [arrOrder addObject:dictGood];
        }
        // modify by songjk 传入vshopid改为shopId
         NSDictionary * dictData = [NSDictionary dictionaryWithObjectsAndKeys:[dictOrderList objectForKey:@"shopId"],@"orderKey",arrOrder,@"list", nil];
        [arrData addObject:dictData];
    }
    NSData * dataParm = [NSJSONSerialization dataWithJSONObject:arrData options:NSJSONWritingPrettyPrinted error:nil];
    NSString * strParm = [[NSString alloc] initWithData:dataParm encoding:NSUTF8StringEncoding];
    strParm = [self encodeToPercentEscapeString:strParm];
    [dict setObject:strParm forKey:@"params"];
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getConfirmOrderInfo",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        BOOL bResult = NO;
        if (error)
        {
            //网络请求错误
//            [Utils showMessgeWithTitle:@"友情提示" message:@"网络错误" isPopVC:self.navigationController];
        }
        else
        {
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"])
            {
                NSDictionary * dictData = [ResponseDic objectForKey:@"data"];
                // 抵扣券信息
                self.discountModel = [GYDiscountInfoModel objectWithKeyValues:dictData];
                NSArray * arrSum = [dictData objectForKey:@"userCouponList"];
                if (![arrSum isKindOfClass:[NSNull class]])
                {
                    for (NSDictionary *dict in arrSum)
                    {
                        GYDiscountUseInfoModel * model = [GYDiscountUseInfoModel objectWithKeyValues:dict];
                        [self.marrDiscountUse addObject:model];
                    }
                }
                bResult = YES;
            }
            else
            {
//                [Utils showMessgeWithTitle:@"友情提示" message:@"系统繁忙" isPopVC:self.navigationController];
            }
        }
        result(bResult);
    }];
    
}
 //选择优惠券按钮
/*
-(void)pushSelDiscount:(NSInteger)index
{
    NSMutableDictionary *dic = self.mArrShop[index - 1];
    GYDisCountViewController *vc = [[GYDisCountViewController alloc] init];
    vc.title = @"选择抵扣券";
    vc.delegateDisCount = self;
    vc.index = index - 1;
    
    savedIndexPathRow=index - 1;
    vc.vShopId = kSaftToNSString(dic[@"vShopId"]);
    vc.shopId = kSaftToNSString(dic[@"shopId"]);
    //传数据，包住 需要传的字典。
    NSMutableArray * marrDiscountValues =[NSMutableArray array];
    for (NSDictionary * tempDict in dic[@"orderDetailList"]) {
        NSMutableDictionary * DictValues =[NSMutableDictionary dictionary];
        [DictValues setValue:tempDict[@"itemId"] forKey:@"id"];
        [DictValues setValue:tempDict[@"skuId"] forKey:@"skuId"];
        [DictValues setValue:tempDict[@"quantity"] forKey:@"num"];
        [marrDiscountValues addObject:DictValues];
    }
    
       vc.marrJeson=marrDiscountValues;
    
    if (vc.vShopId.length > 0 && vc.shopId.length > 0 ) {
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
 }
 */

// by songjk 抵扣券修改为是否选择使用 下面代码不用了
#pragma mark - GYDiscountDelegate

-(void)returnDiscount:(DiscountModel *)discount WithIndex:(NSInteger)index
{
    
    if (!discount) {
        return;
    }

    NSMutableDictionary *dic = self.mArrShop[index];
    
    strDiscount = [NSString stringWithFormat:@"%@ %@张，抵¥%@",discount.couponName,discount.surplusNum,discount.sum];
    
    [dic setValue:strDiscount forKey:@"discount"];
    
    NSMutableDictionary *discountDic = [[NSMutableDictionary alloc] init];
    [discountDic setObject:[NSNumber numberWithLongLong:discount.userCouponId.longLongValue] forKey:@"id"];
    [discountDic setObject:discount.couponName forKey:@"name"];
    [discountDic setObject:@(discount.amount.integerValue) forKey:@"num"];
    [discountDic setObject:@(discount.faceValue.integerValue) forKey:@"faceValue"];
 
    discountSum = discount.sum;
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    
    GYPayoffCell * cell =(GYPayoffCell *) [tbv  cellForRowAtIndexPath:indexPath];
    
    
    float  totalPrice;
    cell.btnDiscount.hidden=NO;

    if ([cell.contentView viewWithTag:(indexPath.row+9000)])
    {
        UIView *   vHas=[cell.contentView viewWithTag:(indexPath.row+9000)];
        [vHas removeFromSuperview];
        
    }
    
    // modify by songjk 抵扣券改造 vDiscount不再使用
//    UIView *   vDiscount =[[UIView alloc ]init];
    cell.btnDiscount.hidden=YES;
//    CGRect FrameSelway = cell.btnDiscount.frame;
//    FrameSelway.size.width=FrameSelway.size.width+5;
//    FrameSelway.origin.x=FrameSelway.origin.x-5;
//    vDiscount.frame=FrameSelway;
    
//    vDiscount.tag=indexPath.row+9000;
//    vDiscount.backgroundColor=[UIColor clearColor];
//    UIFont * font = [UIFont systemFontOfSize:16.0];
//    
//    CGSize titleSize = [discount.sum sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
//    
//    
//    CGSize discountSize = [[NSString stringWithFormat:@"%@ %@张，抵",discount.couponName,discount.surplusNum] sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
//    discountSize.width = discountSize.width>120?120:discountSize.width;
//    
//    
//    UILabel * lbPostAge =[[UILabel alloc]initWithFrame:CGRectMake(FrameSelway.size.width-titleSize.width-7, 0, titleSize.width+2, 30)];
//    UILabel * lbExpress  = [[ UILabel alloc]initWithFrame:CGRectMake(0, 0, discountSize.width, 30)];
//    lbExpress.text=[NSString stringWithFormat:@"%@ %@张，抵",discount.couponName,discount.surplusNum];
//    lbPostAge.backgroundColor=[UIColor clearColor];
//    lbPostAge.textColor=kCellItemTitleColor;
//    lbExpress.textColor=kCellItemTitleColor;
//    
//    
//    lbExpress.textAlignment = NSTextAlignmentRight;
//    lbExpress.backgroundColor=[UIColor clearColor];
//    lbExpress.font= [UIFont systemFontOfSize:16.0f];
//    UIImageView * imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(lbPostAge.frame.origin.x-2-15-2, 5, 21, 21)];
//    imgvIcon.image=[UIImage imageNamed:@"hs_coin.png"];
//    
//    lbPostAge.text=discount.sum;
//    lbPostAge.textAlignment = NSTextAlignmentRight;
//    lbPostAge.font= [UIFont systemFontOfSize:16.0f];
    
    /*
    [vDiscount addSubview:lbPostAge];
    [vDiscount addSubview:imgvIcon];
    [vDiscount addSubview:lbExpress];
    
    GYImgTap * tap = [[GYImgTap alloc]initWithTarget:self action:@selector(toDiscountVc:)];
    tap.tag=1;
    
    [vDiscount addGestureRecognizer:tap];
    [cell.contentView addSubview:vDiscount];
     */
    id obj = dic[@"setDiscount"];
    if ( ![obj isEqualToString:@"1"] )
    {
        //实算金额
        NSString * strPrice =self.mArrShop[index][@"actuallyAmount"];
        strPrice = [NSString stringWithFormat:@"%d",(int)(strPrice.integerValue-discountSum.integerValue) ];
        
        //生产discount json数据
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:discountDic options:NSJSONReadingMutableLeaves error:nil];
        discountJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.mArrShop[index] setValue:discountJson forKey:@"couponInfo"];
        [self.mArrShop[index] setValue:discount.sum forKey:@"couponAmount"];
        [self.mArrShop[index] setValue:strPrice forKey:@"actuallyAmount"];
        [self.mArrShop[index] setValue:@"1" forKey:@"setDiscount"];
        [self.mArrShop[index] setValue:discount.sum forKey:@"setDiscountFee"];
        totalPrice= strIconpriceAmount.floatValue -(int)discountSum.floatValue;
        strIconpriceAmount=[NSString stringWithFormat:@"%.2f",totalPrice];
        self.lbPrice.text=strIconpriceAmount;
        
    }
//    else if (obj)
//    {
//        
//        
//        int dicCountFee = [self.mArrShop[index][@"setDiscountFee"]  intValue];
//        totalPrice= strIconpriceAmount.intValue + dicCountFee-discountSum.intValue;
//        [self.mArrShop[index] setValue:discountSum forKey:@"setDiscountFee"];
//        strIconpriceAmount=[NSString stringWithFormat:@"%.2f",totalPrice];
//        [self.mArrShop[index] setValue:strIconpriceAmount forKey:@"actuallyAmount"];
//        self.lbPrice.text=strIconpriceAmount;
//        
//        
//    }
    
    
    [tbv reloadData];
    
}
// modify by songjk 抵扣券改造不用了
/*
-(void)toDiscountVc:(GYImgTap *)tap
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tap.view.tag-9000 inSection:tap.tag];
    
    [self pushSelDiscount:indexPath.row+1];
    
    
}
*/

#pragma mark - GYSelWayDelegate   选择配送方式回调
-(void)returnTitle:(GYExpress *)model WithIndexPath:(NSIndexPath *)indexPath WithRetIndex:(NSInteger)index WithFee:(NSString *)fee
{
   // add by songjk 清空支付方式
    payType = @"0";
    [footviewPayoffWay.btnChangePayoffWay setTitle:@"" forState:UIControlStateNormal];
    //返回运费
    strSelPayWay = model.strExpress;
    [isDelivery addObject:model.strExpressCode];
    strDeliveryType = model.strExpressCode;
    strSendWay = model.strExpress;
    
    GYPayoffCell * cell =(GYPayoffCell *)[tbv  cellForRowAtIndexPath:indexPath];
    
    float totalPrice;
    
    NSMutableDictionary *dic = self.mArrShop[indexPath.row];
    
    id obj = dic[@"changePostAge"];
    
    if (savedIndexPathRow==indexPath.row )
    {
        
        strpostAge = [fee mutableCopy];
        
        if (indexPath.section == 0) {
            
        }else{
            
            [dic setValue:model.strExpressCode forKey:@"deliveryType"];
            [dic setValue:strSendWay forKey:@"sendWay"];
            //             cell.btnSelWay.hidden=NO;
            //只有在 配送方式为1 时修改 运费 。并且添加 修改标示符 changePostAge
            //obj 不存在的时候，才能添加，避免重复添加运费
            UIView * v;
            if (![obj isEqualToString:@"1"]&&[model.strExpressCode isEqualToString:@"1"]) {
                cell.vExpress.hidden = NO;
                cell.btnSelWay.hidden=YES;
                
                v =[[UIView alloc ]init];
                
//                CGRect FrameSelway = cell.btnSelWay.frame;
                CGRect FrameSelway = cell.vExpress.frame;
                v.frame=FrameSelway;
                v.tag=indexPath.row+100;
                UIFont * font = [UIFont systemFontOfSize:14.0];
                CGSize titleSize = [[NSString stringWithFormat:@"%.02f",[fee floatValue]] sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 100)];
                
                UILabel * lbPostAge =[[UILabel alloc]initWithFrame:CGRectMake(FrameSelway.size.width-titleSize.width-5, 0, titleSize.width, 30)];
                
                
                //                UIImageView * imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(lbPostAge.frame.origin.x-4-15-4, 5, 18, 18)];
                UIImageView * imgvIcon = [[UIImageView alloc]initWithFrame:CGRectMake(lbPostAge.frame.origin.x - 18, 5, 18, 18)];
                imgvIcon.image=[UIImage imageNamed:@"hs_coin.png"];
                //                UILabel * lbExpress  = [[ UILabel alloc]initWithFrame:CGRectMake(lbPostAge.frame.origin.x-4-15-40-5, 0, 40, 30)];
                UILabel * lbExpress  = [[ UILabel alloc]initWithFrame:CGRectMake(imgvIcon.frame.origin.x - 38, 0, 38, 30)];
                lbExpress.text=model.strExpress;
                lbPostAge.textColor=kCellItemTitleColor;
                lbExpress.textColor=kCellItemTitleColor;
                
                
                lbExpress.textAlignment = NSTextAlignmentRight;
                lbExpress.backgroundColor=[UIColor clearColor];
                lbExpress.font= font;
                
                lbPostAge.text= [NSString stringWithFormat:@"%.02f",[fee floatValue]];
                lbPostAge.textAlignment = NSTextAlignmentRight;
                lbPostAge.backgroundColor=[UIColor clearColor];
                lbPostAge.font= font;
                [v addSubview:lbPostAge];
                [v addSubview:imgvIcon];
                [v addSubview:lbExpress];
                
                GYImgTap * tap = [[GYImgTap alloc]initWithTarget:self action:@selector(toPayWayVc:)];
                tap.tag=(int)indexPath.section;
                [v addGestureRecognizer:tap];
                
//                [cell.contentView addSubview:v];
                v.frame = CGRectMake(0, 0, v.frame.size.width, v.frame.size.height);
                [cell.vExpress addSubview:v];
                
                strSendWay = [NSString stringWithFormat:@"%@ ￥%@",model.strExpress,fee ];
                [dic setValue:strSendWay forKey:@"sendWay"];
                
                NSString * strActuallyAmount = dic[@"actuallyAmount"];
                float actuallAmount;
                actuallAmount = strActuallyAmount.floatValue+fee.floatValue;
                //添加了运费
                [dic setValue:strpostAge forKey:@"postAge"];
                
                [dic setValue:@(actuallAmount) forKey:@"actuallyAmount"];
                [dic setValue:@"1" forKey:@"changePostAge"];
                [dic setValue:fee forKey:@"fee"];
                totalPrice= strIconpriceAmount.floatValue +fee.floatValue;
                strIconpriceAmount=[NSString stringWithFormat:@"%.2f",totalPrice];
                
                //obj 存在说明 已经通过快递  添加了运费。减去运费
            }else if (obj&&![model.strExpressCode isEqualToString:@"1"])
            {
                
                
                if ([cell.vExpress viewWithTag:(indexPath.row+100)]) {
//                    v=[cell.contentView viewWithTag:(indexPath.row+100)];
//                    [v removeFromSuperview];
                    v=[cell.vExpress viewWithTag:(indexPath.row+100)];
                    [v removeFromSuperview];
                    cell.vExpress.hidden = YES;
                    cell.btnSelWay.hidden=NO;
                }
                
                [cell bringSubviewToFront:cell.btnSelWay];
                
                float  GetFee = [dic[@"fee"] floatValue];
                
                totalPrice= strIconpriceAmount.floatValue -GetFee;
                strIconpriceAmount=[NSString stringWithFormat:@"%.2f",totalPrice];
                NSString * strActuallyAmount = dic[@"actuallyAmount"];
                float actuallAmount;
                actuallAmount = strActuallyAmount.doubleValue-GetFee;
                [dic setValue:@(actuallAmount) forKey:@"actuallyAmount"];
                [dic removeObjectForKey:@"fee"];
                [dic removeObjectForKey:@"changePostAge"];
                // add by songjk
                [dic setValue:@"0" forKey:@"postAge"];
            }
        }
        
        
    }
    
    self.lbPrice.text=strIconpriceAmount;
    [tbv reloadData];
    
    
}

-(void)toPayWayVc:(GYImgTap *)tap
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tap.view.tag-100 inSection:tap.tag];
    
    [self pushSelWayWithMArray:nil WithIndexPath:indexPath];
    
}


-(NSMutableArray*)setGoodsList :(NSMutableArray *)mArrayShop :(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = mArrayShop[indexPath.row];
    NSMutableArray *mArray = dic[@"orderDetailList"];
    
    return mArray;
}

#pragma mark -getAddrData
-(void)getNetData
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getDefaultDeliveryAddress",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            //网络请求错误
            
        }else{
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"]) {
                //返回正确数据，并进行解析
                
                if ([ResponseDic[@"data"]  isKindOfClass:[NSDictionary class]]) {
                    
                    addrModel = [[AddrModel alloc] init];
                    addrModel.area = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"area"]];
                    addrModel.beDefault = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"beDefault"]];
                    addrModel.city = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"city"]];
                    addrModel.consignee = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"consignee"]];
                    addrModel.detail = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"detail"]];
                    addrModel.addrID = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"id"]];
                    addrModel.mobile = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"mobile"]];
                    addrModel.province = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"province"]];
                    addrModel.PostCode = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"postcode"]];
                    
                }
                
            }else{
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [av show];
                //返回数据不正确
            }
        }
        
        [tbv reloadData];
    }];
}



- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             
                                                                             NULL, /* allocator */
                                                                             
                                                                             (__bridge CFStringRef)input,
                                                                             
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             
                                                                             kCFStringEncodingUTF8);
    
    
    return
    outputStr;
}

- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0,
                                                      [outputStr length])];
    
    return
    [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


#pragma mark - submitOrdersData
-(void)submitOrdersData
{
    //创建 json数组
    [self buildJsonData];
    
    if (!addrModel) {
        [Utils showMessgeWithTitle:nil message:@"请选择收货地址!" isPopVC:nil];
        return ;
    }
    
    if (isDelivery.count<=1) {
        [Utils showMessgeWithTitle:nil message:@"请选择配送方式" isPopVC:nil];
        return ;
    }
    
    if ([payType isEqualToString:@"0"]) {
        [Utils showMessgeWithTitle:nil message:@"请选择支付方式!" isPopVC:nil];
        return ;
    }
    
    
    
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"正在提交..."];
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:self.mArrShop options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //对orderjeson 进行编码 避免出现% 等特殊符号，后台无法获取。
    jsonString = [self encodeToPercentEscapeString :jsonString ];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:jsonString forKey:@"orderJson"];
    [dict setValue:self.isRightAway forKey:@"isRightAway"];
    // add by songjk 互生币支付的code为 000
    if ([payType isEqualToString:@"3"]) {
        [dict setValue:@"000" forKey:@"coinCode"];
    }
    else
    {
        [dict setValue:[GlobalData shareInstance].user.currencyCode forKey:@"coinCode"];
    }
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    
    
    //发起request
    [Network HttpPostRequetURL:[NSString stringWithFormat:@"%@/easybuy/confirmationOrder",[GlobalData shareInstance].ecDomain] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            //网络请求错误
            [Utils showMessgeWithTitle:@"友情提示" message:@"网络错误" isPopVC:nil];
            
        }
        else
        {
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"])
            {
                if ([payType  isEqualToString:@"2"])
                {
                    //调用银联支付
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *tnCode = kSaftToNSString(ResponseDic[@"data"]);
                        NSLog(@"-------%@------tncode",tnCode);
                        if (tnCode.length > 0)
                        {
                            [UPPayPlugin startPay:tnCode mode:kUPPayPluginMode viewController:self delegate:self];
                        }
                        else
                        {
                            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"订单提交失败！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                            [av show];
                            
                        }
                    });
                    
                }
                else if ([payType  isEqualToString:@"3"])
                {
                    
                    NSString *tnCode = kSaftToNSString(ResponseDic[@"data"]);
                    
                    if (tnCode&&tnCode.length>0&&![tnCode isEqualToString:@"<null>"])
                    {
                        
                        GYIconPayTypeViewController * vcIconPayType =[[GYIconPayTypeViewController alloc]initWithNibName:@"GYIconPayTypeViewController" bundle:nil];
                        vcIconPayType.strPriceAmount=strIconpriceAmount;
                        vcIconPayType.strPvAmount=strIconpvAmount;
                        vcIconPayType.strOrderId=tnCode;
                        [self.navigationController pushViewController:vcIconPayType animated:YES];
                    }
                    else
                    {
                        
                        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"订单提交失败！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        [av show];
                        
                    }
                    
                }
                else
                {
                    [UIAlertView showWithTitle:nil message:@"提交货到付款订单成功。" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        GYEPMyAllOrdersViewController * vcMyOrder = [[GYEPMyAllOrdersViewController alloc]initWithNibName:@"GYEPMyAllOrdersViewController" bundle:nil];
                        vcMyOrder.title=@"全部订单";// modify by songjk 改成全部订单
                        [self.navigationController pushViewController:vcMyOrder animated:YES];
                    }];
                }
                //返回正确数据，并进行解析
            }
            else if ([str isEqualToString:@"502"])
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"订单提交失败" message:@"购买商品数量过大！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
            else
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"订单提交失败" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                //返回数据不正确
            }
        }
    }];
}


//初始化json数组 内默认数据
-(void)initJsonData
{
    for (NSMutableDictionary *dic in self.mArrShop) {
        [dic setValue:strReceiver forKey:@"receiver"];
        [dic setValue:strReceiverAddress forKey:@"receiverAddress"];
        [dic setValue:strReceiverContact forKey:@"receiverContact"];
        [dic setValue:strReceiverPostCode forKey:@"receiverPostCode"];
        [dic setValue:strpostAge forKey:@"postAge"];
        [dic setValue:payType forKey:@"payType"];//货到付款
        [dic setValue:strInvoiceTitle forKey:@"invoiceTitle"];
        [dic setValue:strUserNote forKey:@"userNote"];
        [dic setValue:strDeliveryType forKey:@"deliveryType"];
        [dic setValue:discountSum forKey:@"couponAmount"];
        [dic setValue:@"" forKey:@"couponInfo"];
//        [dic setValue:strIconpriceAmount forKey:@"totalAmount"]; // 本身就有了 不用添加
    }
    
}



-(void)buildJsonData
{
    // modify by songjk 修改留言和发票信息传入
    for (int i =0; i<self.mArrShop.count; i++)
    {
        NSMutableDictionary *dic = self.mArrShop[i];
        [dic setValue:strReceiver forKey:@"receiver"];
        [dic setValue:strReceiverAddress forKey:@"receiverAddress"];
        [dic setValue:strReceiverContact forKey:@"receiverContact"];
        [dic setValue:strReceiverPostCode forKey:@"receiverPostCode"];
        [dic setValue:payType forKey:@"payType"];
//        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:1];
//        GYPayoffCell * cell =(GYPayoffCell *)[tbv  cellForRowAtIndexPath:indexPath];
//        [dic setValue:cell.tfLeaveWord.text forKey:@"userNote"];
//        [dic setValue:cell.tfBill.text forKey:@"invoiceTitle"];
        
        for (NSMutableDictionary * orderDict in dic[@"orderDetailList"]) {
            if (orderDict[@"url"]) {
                [orderDict removeObjectForKey:@"url"];
            }
        }
        
        
        //提交之前，对字典中 用户之前 标示 或者 临时显示的字段进行清理。
        if (dic [@"changePostAge"]) {
            [dic removeObjectForKey:@"changePostAge"];
        }
        
        if (dic[@"setDiscount"]) {
            [dic removeObjectForKey:@"setDiscount"];
        }
        
        if (dic[@"fee"]) {
            [dic removeObjectForKey:@"fee"];
        }
        
        if (dic[@"setDiscountFee"]) {
            [dic removeObjectForKey:@"setDiscountFee"];
        }
        
        if ([dic[@"sendWay"] isEqualToString:@""]) {
            [dic setValue:@"快递" forKey:@"sendWay"];
        }
    }
    /*
    for (NSMutableDictionary *dic in self.mArrShop)
    {
        [dic setValue:strReceiver forKey:@"receiver"];
        [dic setValue:strReceiverAddress forKey:@"receiverAddress"];
        [dic setValue:strReceiverContact forKey:@"receiverContact"];
        [dic setValue:strReceiverPostCode forKey:@"receiverPostCode"];
        [dic setValue:payType forKey:@"payType"];
//        [dic setValue:strInvoiceTitle forKey:@"invoiceTitle"];
//        [dic setValue:strUserNote forKey:@"userNote"];
        // mdify by songjk 留言和发票抬头搞反了
//        [dic setValue:_tvLeaveWorld.text forKey:@"invoiceTitle"];
//        [dic setValue:_tvBill.text forKey:@"userNote"];
        [dic setValue:_tvLeaveWorld.text forKey:@"userNote"];
        [dic setValue:_tvBill.text forKey:@"invoiceTitle"];
        

        
        for (NSMutableDictionary * orderDict in dic[@"orderDetailList"]) {
            if (orderDict[@"url"]) {
                [orderDict removeObjectForKey:@"url"];
            }
        }
        
        
        //提交之前，对字典中 用户之前 标示 或者 临时显示的字段进行清理。
        if (dic [@"changePostAge"]) {
            [dic removeObjectForKey:@"changePostAge"];
        }
        
        if (dic[@"setDiscount"]) {
            [dic removeObjectForKey:@"setDiscount"];
        }
        
        if (dic[@"fee"]) {
            [dic removeObjectForKey:@"fee"];
        }
        
        if (dic[@"setDiscountFee"]) {
            [dic removeObjectForKey:@"setDiscountFee"];
        }
        
        if ([dic[@"sendWay"] isEqualToString:@""]) {
            [dic setValue:@"快递" forKey:@"sendWay"];
        }
        
        
    }*/
    
    
    
}




//#pragma mark - UITextFieldDelegate
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    
//    if (textField.tag < 900) {
//        strInvoiceTitle = textField.text;
//        NSMutableDictionary *dic = self.mArrShop[textField.tag - 800];
//        [dic setValue:strInvoiceTitle forKey:@"invoiceTitle"];
//        
//    }else{
//        
//        strUserNote = textField.text;
//        NSMutableDictionary *dic = self.mArrShop[textField.tag - 900];
//        [dic setValue:strUserNote forKey:@"userNote"];
//    }
//    
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    // modify by songjk 计算长度修改
//    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    unsigned long len = toBeString.length;
//    if (textField.tag==100)
//    {
//        if(len > 80) return NO;
//        
//    }
//    if (textField.tag==101) {
//        if(len > 200) return NO;
//    }
//    
//    return YES;
//    
//}

#pragma mark - UItextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag < 900) {
        strInvoiceTitle = textView.text;
        NSMutableDictionary *dic = self.mArrShop[textView.tag - 800];
        [dic setValue:strInvoiceTitle forKey:@"invoiceTitle"];
        
    }else{
        
        strUserNote = textView.text;
        NSMutableDictionary *dic = self.mArrShop[textView.tag - 900];
        [dic setValue:strUserNote forKey:@"userNote"];
    }
}
//add by zhangqy 限制输入字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *str = textView.text;
    NSLog(@"str === %@",str);
    if (textView.tag < 900) {
        strInvoiceTitle = textView.text;
        NSMutableDictionary *dic = self.mArrShop[textView.tag - 800];
        [dic setValue:strInvoiceTitle forKey:@"invoiceTitle"];
        
    }else{
        
        strUserNote = textView.text;
        NSMutableDictionary *dic = self.mArrShop[textView.tag - 900];
        [dic setValue:strUserNote forKey:@"userNote"];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (textView.tag < 900) {
        if (str.length>50) {
            textView.text = [str substringToIndex:50];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"发票抬头字数最多为%d",50] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
            return NO;
        }
    }
    else {
        if (str.length>200) {
            textView.text = [str substringToIndex:200];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"留言字数最多为%d",200] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
            return NO;
        }
    }
    return YES;
}
//创建SelWay，selWay为所有选择页面的公用tableVivew ,创建需要传入数据源数组

-(void)buildSelWayWithArray:(NSMutableArray *)array
{
    GYSelWayVC *vc = [[GYSelWayVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
    // modify by songjk 改变提示方式
    [Utils hideHudViewWithSuperView:self.view];
    GYResultView* vReslut = [[GYResultView alloc] init];
    vReslut.delegate = self;
    if ([result isEqualToString:@"success"])
    {
        [vReslut showWithView:self.view status:YES message:@"付款成功。"];
        
//        [UIAlertView showWithTitle:nil message:@"付款成功。" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//          
//            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//            hud.removeFromSuperViewOnHide = YES;
//            hud.labelText = @"正在跳转...";
//            [self.view addSubview:hud];
//            [hud showAnimated:YES whileExecutingBlock:^{
//                sleep(6.f);
//                
//            } completionBlock:^{
//                [hud removeFromSuperview];
//                GYEPMyAllOrdersViewController * vcMyOrder = [[GYEPMyAllOrdersViewController alloc]initWithNibName:@"GYEPMyAllOrdersViewController" bundle:nil];
//                vcMyOrder.title=@"全部订单";// modify by songjk 改为全部订单
//                [self.navigationController pushViewController:vcMyOrder animated:YES];
//                           }];
//            
//            
//        }];
        
    }else
    {
        [vReslut showWithView:self.view status:NO message:@"付款失败。"];
//        [UIAlertView showWithTitle:nil message:@"付款失败。" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            
//            GYEPMyAllOrdersViewController * vcMyOrder = [[GYEPMyAllOrdersViewController alloc]initWithNibName:@"GYEPMyAllOrdersViewController" bundle:nil];
//            vcMyOrder.title=@"全部订单";// modify by songjk 改为全部订单
//            [self.navigationController pushViewController:vcMyOrder animated:YES];
//            
//            
//        }];
    }
    
}
#pragma mark gyresultViewDelegate
-(void)ResultViewConfrimButtonClicked:(GYResultView *)ResultView success:(BOOL)success
{
    if (success)
    {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.removeFromSuperViewOnHide = YES;
        hud.labelText = @"正在跳转...";
        [self.view addSubview:hud];
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(6.f);
            
        } completionBlock:^{
            [hud removeFromSuperview];
            GYEPMyAllOrdersViewController * vcMyOrder = [[GYEPMyAllOrdersViewController alloc]initWithNibName:@"GYEPMyAllOrdersViewController" bundle:nil];
            vcMyOrder.title=@"全部订单";// modify by songjk 改为全部订单
            [self.navigationController pushViewController:vcMyOrder animated:YES];
        }];
    }else
    {
        GYEPMyAllOrdersViewController * vcMyOrder = [[GYEPMyAllOrdersViewController alloc]initWithNibName:@"GYEPMyAllOrdersViewController" bundle:nil];
        vcMyOrder.title=@"全部订单";// modify by songjk 改为全部订单
        [self.navigationController pushViewController:vcMyOrder animated:YES];
    }
}
#pragma mark  选择支付方式的代理方法
-(void)selectPaymentWithModel :(GYPaymentType *)model
{
    
    NSString * paymentType;
    if ([model.strPayment isEqualToString:@"EP"]) {
        paymentType=@"网银支付";
        payType=[NSString stringWithFormat:@"2"];
    }else if ([model.strPayment isEqualToString:@"AC"])
    {
        paymentType=@"互生币支付";// 修改为互生币支付
        payType=[NSString stringWithFormat:@"3"];
        
        
    }else if ([model.strPayment isEqualToString:@"CD"])
    {
        paymentType=@"货到付款";
        payType=[NSString stringWithFormat:@"1"];
        
    }
    [footviewPayoffWay.btnChangePayoffWay setTitle:paymentType forState:UIControlStateNormal];
    
}

@end
