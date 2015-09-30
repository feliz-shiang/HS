//
//  GYCartViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYCartViewController.h"
#import "GYCartGoodsCell.h"
#import "UIView+CustomBorder.h"
#import "GYPayoffViewController.h"
#import "GYEasyPurchaseMainViewController.h"
#import "CartModel.h"
#import "GYLoadImg.h"
#import "GYGoodsDetailController.h"
#import "UIImageView+WebCache.h"
#import "GYGoodDetailViewController.h"
#import "GYEasyBuyModel.h"
#import "GYARMainViewController.h"
#import "GYSearchShopViewController.h"
#import "GYAppDelegate.h"
#define pageCount 4

@interface GYCartViewController ()<UITableViewDataSource,UITableViewDelegate,GYCartGoodsCellDelegate>

{
    __weak IBOutlet UITableView *tbvGoods;//tableView
    __weak IBOutlet UIView *vButtons;//按键行
    __weak IBOutlet UIButton *btnAll;//全选按钮
    __weak IBOutlet UIButton *btnPayoff;//结算按钮
    __weak IBOutlet UILabel *lbTotalPrice;
    __weak IBOutlet UILabel *lbTotalPV;
    
    
    __weak IBOutlet UIView *vEmptyCart;
    __weak IBOutlet UIButton *btnBuy;
    
    __weak IBOutlet UIView *vNoNetWork;
    
    BOOL isAll;
    
    
    NSMutableArray *mArrData;
    NSMutableArray *mArrData1;
    
    NSMutableArray *mArrShop;//排列后的数组
    
    NSInteger selectedGoodsRow;
    
  }
@property (strong, nonatomic)UIView *blackBackGroundView;
@property (strong, nonatomic) IBOutlet UIView *setCountView;
@property (weak, nonatomic) IBOutlet UIButton *setCountCutBtn;
@property (weak, nonatomic) IBOutlet UIButton *setCountAddBtn;
@property (weak, nonatomic) IBOutlet UITextField *setCountTextField;
@property (weak, nonatomic) IBOutlet UIButton *setCountCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *setCountConfirmBtn;
@property (assign, nonatomic)NSInteger maxGoodsNum;
- (IBAction)setCountCutBtnClicked:(id)sender;
- (IBAction)setCountAddBtnClicked:(id)sender;
- (IBAction)setCountCancelBtnClicked:(id)sender;
- (IBAction)setCountConfirmBtnClicked:(id)sender;


@end

@implementation GYCartViewController

//全选点击事件
- (IBAction)btnAllClick:(id)sender {
    isAll = !isAll;
    for (CartModel *model in mArrData) {
        model.isSel = isAll;
    }
    if (isAll) {
        [sender setImage:[UIImage imageNamed:@"ep_cart_selected.png"] forState:UIControlStateNormal];
        [self total];
        
    }else{
        [sender setImage:[UIImage imageNamed:@"ep_cart_unselected.png"] forState:UIControlStateNormal];
    }
    
    [tbvGoods reloadData];
}

//结算点击事件
- (IBAction)btnPayoffClick:(id)sender {
    
    
    mArrShop = [self buildShopArray];
    
    if (mArrShop.count > 0) {
        GYPayoffViewController *vc = [[GYPayoffViewController alloc] init];
        NSMutableArray *mArrTemp = [self buildPayoffJson];
        vc.isRightAway = @"0";
        vc.mArrShop = mArrTemp;
        vc.title = @"确认订单";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请选择商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [av show];
    }
    
}

//去购买点击事件
- (IBAction)btnBuyClick:(id)sender {

    for (UIViewController * temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[GYEasyPurchaseMainViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
      else if ([temp isKindOfClass:[GYARMainViewController class]]) {
    self.tabBarController.selectedViewController = self.tabBarController.viewControllers[2];
       [self.navigationController popToViewController:temp animated:YES];
      }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    btnBuy.layer.borderWidth = 1.0;
    btnBuy.layer.cornerRadius = 2.0;
    btnBuy.layer.borderColor = kDefaultViewBorderColor.CGColor;
    
    mArrData = [[NSMutableArray alloc] init];
    isAll = YES;
    [self btnAllClick:btnAll];
    
    btnPayoff.layer.cornerRadius = 2.0;
    
    //设置边框
    [vButtons addTopBorder];
    
    
    tbvGoods.delegate = self;
    tbvGoods.dataSource = self;
    tbvGoods.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tbvGoods registerNib:[UINib nibWithNibName:@"GYCartGoodsCell" bundle:nil] forCellReuseIdentifier:@"CELL"
     ];
    
    [self getNetData];
    GYAppDelegate *delegate = (GYAppDelegate*)[UIApplication sharedApplication].delegate;
    _maxGoodsNum = delegate.goodsNum;
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)//返回
    {
        if ([self.navigationController.topViewController isKindOfClass:[GYEasyPurchaseMainViewController class]])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    
}
#pragma mark - UITableViewDataSource



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArrData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierCell=@"cell";
    
    GYCartGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell==nil) {
        NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"GYCartGoodsCell" owner:self options:nil];
        cell =[arr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                      
    }
    
    CartModel *model = mArrData[indexPath.row];
    cell.nav=self.navigationController;
    
    cell.ShopID=model.vShopId;
    cell.btnEnterShop.tag=indexPath.row;
    //add by shiang
    cell.btnAdd.tag=indexPath.row;
    cell.btnCut.tag=indexPath.row;
    cell.tfNum.tag=indexPath.row;
    [cell.btnEnterShop addTarget:self action:@selector(btnEnterShop:) forControlEvents:UIControlEventTouchUpInside];
    cell.lbShopName.text = model.vShopName;
    cell.lbGoodName.text = model.title;
    cell.lbColor.text = model.sku;
    cell.lbPrice.text = [NSString stringWithFormat:@"%.02f",[model.price doubleValue]];
    cell.price = [model.price floatValue];
    cell.lbNumBIg.text = [NSString stringWithFormat:@"共%d件商品",[model.count intValue]];
    cell.tfNum.text = [NSString stringWithFormat:@"%d",[model.count intValue]];
    cell.num = [model.count intValue];
    cell.lbPV.text = [NSString stringWithFormat:@"%.02f",[model.pv doubleValue]];
    cell.pv = [model.pv floatValue];
    cell.isSel = model.isSel;
    // add by osngjk
    cell.lbShopNameDetail.text = model.shopName;
    [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
    //    cell.lbPriceTotal.text = [NSString stringWithFormat:@"%f",[model.count intValue] * [model.price floatValue]];
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell setData];
    
    if (cell.isSel) {
        [cell.btnSel setImage:[UIImage imageNamed:@"ep_cart_selected.png"] forState:UIControlStateNormal];
    }else{
        [cell.btnSel setImage:[UIImage imageNamed:@"ep_cart_unselected.png"] forState:UIControlStateNormal];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self.navigationController.topViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GYGoodsDetailController *gooddetail=kLoadVcFromClassStringName(NSStringFromClass([GYGoodsDetailController class]));
    CartModel *model = mArrData[indexPath.row];
    
    GYEasyBuyModel *easyModel=[[GYEasyBuyModel alloc]init];
    easyModel.strGoodId=model.cartItemsId;//////////////////////////////商品ID
    ShopModel *shopModel=[[ShopModel alloc]init];
    
    shopModel.strShopId=model.vShopId;/////////////////////////////商铺Id
    easyModel.shopInfo=shopModel;
    easyModel.strGoodName=model.title;///商品的名称
    easyModel.strGoodPictureURL=model.url;///图片URL
    easyModel.strGoodId=model.cartItemsId;////商品Id
    easyModel.strGoodPrice=model.price;
    
    gooddetail.model=easyModel;
    [self pushVC:gooddetail animated:YES];
    
}

- (void)btnEnterShop:(UIButton *)sender
{
      CartModel *model = mArrData[sender.tag];
   
    

}

#pragma mark - getNetData
//网络请求函数，包含网络等待弹窗控件，数据解析回调函数
-(void)getNetData
{
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];
    //测试get
    
    
    NSString *url = [[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getCartList"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    
    [Network  HttpGetForRequetURL:url parameters:parameters requetResult:^(NSData *jsonData, NSError *error){
        
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            
            vNoNetWork.hidden = NO;
            
            [Utils hideHudViewWithSuperView:self.view];
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            int retCode = kSaftToNSInteger(ResponseDic[@"retCode"]);//  [ResponseDic[@"retCode"] intValue];
            if (retCode == 200) {
                for (NSDictionary *dic in ResponseDic[@"data"]) {
                    
//                    NSLog(@"dic == %@",dic);
                    
                    CartModel *model = [[CartModel alloc] init];
                    model.categoryId = [NSString stringWithFormat:@"%@",dic[@"categoryId"]];
                    model.companyResourceNo = [NSString stringWithFormat:@"%@",dic[@"companyResourceNo"]];
                    model.count = [NSString stringWithFormat:@"%@",dic[@"count"]];
                    model.heightAuction = [NSString stringWithFormat:@"%@",dic[@"heightAuction"]];
                    model.cartItemsId = [NSString stringWithFormat:@"%@",dic[@"id"]];
                    model.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
                    model.pv = [NSString stringWithFormat:@"%@",dic[@"pv"]];
                    model.sku = [NSString stringWithFormat:@"%@",dic[@"sku"]];
                    model.skuId = [NSString stringWithFormat:@"%@",dic[@"skuId"]];
                    model.title = [NSString stringWithFormat:@"%@",dic[@"title"]];
                    model.vShopId = [NSString stringWithFormat:@"%@",dic[@"vShopId"]];
                    model.vShopName = [NSString stringWithFormat:@"%@",dic[@"vShopName"]];
                    
                    model.serviceResourceNo = [NSString stringWithFormat:@"%@",dic[@"serviceResourceNo"]];
                    model.shopId = [NSString stringWithFormat:@"%@",dic[@"shopId"]];
                    model.shopName = [NSString stringWithFormat:@"%@",dic[@"shopName"]];
                    model.url = [NSString stringWithFormat:@"%@",dic[@"url"]];
                    model.cartId = [NSString stringWithFormat:@"%@",dic[@"cartId"]];
                    
                    model.isSel = NO;
                    // add by songjk 规则di
                    model.ruleID = [NSString stringWithFormat:@"%@",dic[@"ruleId"]];
                    // songjk 是否申请互生卡
                    model.isApplyCard = [NSString stringWithFormat:@"%@",dic[@"isApplyCard"]];
//                    CGFloat f = [model.price floatValue];
                    
                    [mArrData addObject:model];
                    
                }
                
                //当购物车为空展示空车页面
                if (mArrData.count == 0) {
                    vEmptyCart.hidden = NO;
                    
                }
                
                
            }else{
                
                // 使用本地数据
                
            }
            
            
            //网络请求回调后弹窗
            [tbvGoods reloadData];
            [self total];
            [Utils hideHudViewWithSuperView:self.view];
        }
        
    }];
}


#pragma mark - delGoodsList
//网络请求函数，包含网络等待弹窗控件，数据解析回调函数
-(void)delGoodsList:(NSString*)cartItemsId andRemoveCellForIndex:(NSNumber *)index
{
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];
    //测试get
    
    NSString *url = [[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/deleteCart"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [parameters setValue:cartItemsId forKey:@"cartItemsId"];
    
    [Network  HttpGetForRequetURL:url parameters:parameters requetResult:^(NSData *jsonData, NSError *error){
        
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            
            [Utils hideHudViewWithSuperView:self.view];
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            int retCode = kSaftToNSInteger(ResponseDic[@"retCode"]);//[ResponseDic[@"retCode"] intValue];
            if (retCode == 200) {
                
                // 使用本地数据
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [av show];
                
                if (index)
                {
                    [mArrData removeObjectAtIndex:[index integerValue]];
                    [tbvGoods reloadData];
                    [self total];
                    
                }
                
            }else{
                
                
                
            }
            
        }
        
    }];
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CartModel *model = mArrData[indexPath.row];
//
//    
//    GYEasyBuyModel * mod = [[GYEasyBuyModel alloc]init];
//    mod.strGoodId=model.cartItemsId;
//    
//    mod.shopInfo.strVshopId=model.vShopId;
//    ShopModel * shopMod = [[ShopModel alloc]init];
//    
//       shopMod.strShopId=model.vShopId;
//    NSLog(@"%@------strvshopid",shopMod.strVshopId);
//    mod.shopInfo=shopMod;
//    
////    ShopModel * shopMod =[[ShopModel alloc]init];
////    shopMod.strShopId=kSaftToNSString([dic objectForKey:@"vShopId"]);
////    model.shopInfo=shopMod;
//
////    [dict setValue:self.model.strGoodId forKey:@"itemId"];
////    [dict setValue:self.model.shopInfo.strShopId forKey:@"vShopId"];
////
//    
////    model.categoryId = [NSString stringWithFormat:@"%@",dic[@"categoryId"]];
////    model.companyResourceNo = [NSString stringWithFormat:@"%@",dic[@"companyResourceNo"]];
////    model.count = [NSString stringWithFormat:@"%@",dic[@"count"]];
////    model.heightAuction = [NSString stringWithFormat:@"%@",dic[@"heightAuction"]];
////    model.cartItemsId = [NSString stringWithFormat:@"%@",dic[@"id"]];
////    model.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
////    model.pv = [NSString stringWithFormat:@"%@",dic[@"pv"]];
////    model.sku = [NSString stringWithFormat:@"%@",dic[@"sku"]];
////    model.skuId = [NSString stringWithFormat:@"%@",dic[@"skuId"]];
////    model.title = [NSString stringWithFormat:@"%@",dic[@"title"]];
////    model.vShopId = [NSString stringWithFormat:@"%@",dic[@"vShopId"]];
////    model.vShopName = [NSString stringWithFormat:@"%@",dic[@"vShopName"]];
////    
////    model.serviceResourceNo = [NSString stringWithFormat:@"%@",dic[@"serviceResourceNo"]];
////    model.shopId = [NSString stringWithFormat:@"%@",dic[@"shopId"]];
////    model.shopName = [NSString stringWithFormat:@"%@",dic[@"shopName"]];
////    model.url = [NSString stringWithFormat:@"%@",dic[@"url"]];
////    model.cartId = [NSString stringWithFormat:@"%@",dic[@"cartId"]];
//    
//    mod.strGoodPictureURL=model.url;
//    mod.strGoodId=model.title;
//    mod.strGoodPrice=model.price;
//    mod.strGoodId=model.shopId;
//    mod.shopInfo.strShopId=model.shopId;
////    NSDictionary *dicGoods = @{@"goodsPictureUrl":model.strGoodPictureURL,
////                               @"goodsName":model.strGoodName,
////                               @"goodsPrice":model.strGoodPrice,
////                               @"goodsId":model.strGoodId,
////                               @"shopId":model.shopInfo.strShopId,
////                               @"numBroweTime":model.numBroweTime
////                               };
//
//    
//    GYGoodsDetailController * vcGoodDetail =[[GYGoodsDetailController alloc]initWithNibName:@"GYGoodsDetailController" bundle:nil];
//    vcGoodDetail.model=mod;
//    self.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:vcGoodDetail animated:YES];
//    
//    NSLog(@"%@=========id",  model.cartItemsId);
//
//}

//计算总数据

-(void)total
{
    CGFloat price = 0;
    CGFloat pv = 0;
    
    for (CartModel *model in mArrData) {
        price = price + [model.count intValue] *[model.price floatValue] * model.isSel;
        
        pv = pv + [model.count intValue] *[model.pv floatValue] * model.isSel;
    }
    
    lbTotalPrice.text = [NSString stringWithFormat:@"%.2f",price];
    lbTotalPV.text = [NSString stringWithFormat:@"%.2f",pv];
}



#pragma mark - GYCartGoodsCellDelegate

-(void)showSetCountViewGoodsNum:(NSInteger)goodsNum withRow:(NSInteger)row
{
    self.editing = YES;
    //add by shiang
    selectedGoodsRow=row;
     _blackBackGroundView= [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _blackBackGroundView.backgroundColor = [UIColor blackColor];
    _blackBackGroundView.alpha = 0.5;

    [self.view addSubview:_blackBackGroundView];
    _setCountView.center =CGPointMake(kScreenWidth*0.5, kScreenHeight*0.3);
    [self.view addSubview:_setCountView];
    _setCountView.clipsToBounds = YES;
    _setCountView.layer.cornerRadius = 10;
    _setCountTextField.text = @(goodsNum).stringValue;
    [_setCountTextField addTarget:self action:@selector(setCountTextFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _setCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_setCountTextField becomeFirstResponder];
    

}



-(void)isSelCell:(BOOL)isSel :(NSIndexPath *)indexPath
{
    CartModel *model = mArrData[indexPath.row];
    model.isSel = isSel;
    
    [self total];
}

-(void)changeCount:(NSInteger)count :(NSIndexPath *)indexPath
{
    CartModel *model = mArrData[indexPath.row];
    model.count = [NSString stringWithFormat:@"%d",count];
    
    [self total];
}

-(void)delCell:(NSIndexPath *)indexPath
{
    CartModel *model = mArrData[indexPath.row];
    [self delGoodsList:model.cartId andRemoveCellForIndex:@(indexPath.row)];
}


-(NSMutableArray *)buildPayoffJson
{
    NSMutableArray *mArrShopSend = [[NSMutableArray alloc] init];

    for (NSMutableArray *shop in mArrShop) {
        
        CartModel *model = shop[0];
        
        NSMutableDictionary *mDicShop = [[NSMutableDictionary alloc] init];
        
        [mDicShop setValue:@"2" forKey:@"channelType"];
        [mDicShop setValue:model.companyResourceNo forKey:@"companyResourceNo"];
        [mDicShop setValue:model.serviceResourceNo forKey:@"serviceResourceNo"];
        [mDicShop setValue:[GlobalData shareInstance].user.currencyCode forKey:@"coinCode"];
        [mDicShop setValue:model.shopName forKey:@"shopName"];
        [mDicShop setValue:model.vShopId forKey:@"vShopId"];
        [mDicShop setValue:model.vShopName forKey:@"vShopName"];
        [mDicShop setValue:@"0" forKey:@"postAge"];//快递费
        NSMutableArray *mArrGoodsList = [[NSMutableArray alloc] init];
        [mDicShop setValue:mArrGoodsList forKey:@"orderDetailList"];
        [mDicShop setValue:@(model.count.floatValue * model.price.floatValue) forKey:@"totalAmount"];
        
        float  autuallyAmount =0;
        float  totalPoint =0;
        NSMutableArray * marrShopId = [NSMutableArray array];
        for (CartModel *modelInside in shop) {
            
            NSMutableDictionary *mDicGoodsList = [[NSMutableDictionary alloc] init];
            [marrShopId addObject:modelInside.shopId];
            [mDicGoodsList setObject:modelInside.categoryId forKey:@"categoryId"];
            [mDicGoodsList setObject:modelInside.cartItemsId forKey:@"itemId"];
            [mDicGoodsList setObject:modelInside.title forKey:@"itemName"];
            [mDicGoodsList setObject:modelInside.pv forKey:@"point"];
            [mDicGoodsList setObject:modelInside.price forKey:@"price"];
            [mDicGoodsList setObject:modelInside.count forKey:@"quantity"];
            [mDicGoodsList setObject:modelInside.skuId forKey:@"skuId"];
            [mDicGoodsList setObject:modelInside.sku forKey:@"skus"];
            [mDicGoodsList setObject:modelInside.url forKey:@"url"];//购物车到订单确认 没有图片 需要放到字典中 方便取出。
            float subTotal = [modelInside.price floatValue] * [modelInside.count floatValue];
            float subPoints = [modelInside.pv floatValue] * [modelInside.count floatValue];
            [mDicGoodsList setObject:[NSString stringWithFormat:@"%.2f",subPoints] forKey:@"subPoints"];
            [mDicGoodsList setObject:[NSString stringWithFormat:@"%.2f",subTotal] forKey:@"subTotal"];
            [mDicGoodsList setObject:modelInside.vShopId forKey:@"vShopId"];
            // add by songjk 抵扣券ruleid
            [mDicGoodsList setObject:modelInside.ruleID forKey:@"ruleId"];
            // add by songjk 是否选择互生卡
            [mDicGoodsList setObject:modelInside.isApplyCard forKey:@"isApplyCard"];
            // add by songjk 增加shopid
            [mDicGoodsList setObject:modelInside.shopId forKey:@"shopId"];
            //所有model 中的实体店 shopid
            autuallyAmount +=subTotal;
            totalPoint +=subPoints;
            [mArrGoodsList addObject:mDicGoodsList];
        }
  
        NSMutableDictionary *  dictShopid = [NSMutableDictionary dictionary];
        
        
        for (int i=0; i<marrShopId.count; i++) {
            [dictShopid  setValue:@"test" forKey:marrShopId[i]];
            
        }
        
        if ([dictShopid allKeys].count==1) {
             [mDicShop setValue:model.shopId forKey:@"shopId"];
        }else
        {
        
         [mDicShop setValue:@"0" forKey:@"shopId"];
        }
       
        [mDicShop setValue:@(autuallyAmount) forKey:@"actuallyAmount"];
        [mDicShop setValue:@(totalPoint) forKey:@"totalPoints"];
        [mDicShop setValue:@(autuallyAmount) forKey:@"totalAmount"];
        
        [mArrShopSend addObject:mDicShop];
        
    }
    return mArrShopSend;
}

// 拆单
-(NSMutableArray *)buildShopArray
{
    
    
    mArrData1 = [[NSMutableArray alloc] initWithArray:mArrData];
    
    NSMutableArray *mArrTemp = [[NSMutableArray alloc] init];
    
    for (CartModel *model in mArrData1) {
        if (model.isSel && [model.count integerValue] != 0 ) {
            [mArrTemp addObject:model];
        }
    }
    
    mArrData1 = mArrTemp;
    
    NSMutableArray *allShop = [[NSMutableArray alloc] init];
    
    
    
    //构建排序描述器
    NSSortDescriptor *vShopID = [NSSortDescriptor sortDescriptorWithKey:@"vShopId" ascending:YES];
    NSSortDescriptor *vSkuId = [NSSortDescriptor sortDescriptorWithKey:@"skuId" ascending:YES];
    
    //把排序描述器放进数组里，放入的顺序就是你想要排序的顺序
    NSArray *descriptorArray = [NSArray arrayWithObjects:vShopID,vSkuId, nil];
    NSArray *sortedArray = [mArrData1 sortedArrayUsingDescriptors: descriptorArray];
    
    // modify by songjk 由vshopid拆单改为shopid拆单
    NSString *strShopID = @"0";
    for (CartModel *model in sortedArray) {
//        if (![strShopID isEqualToString:model.vShopId]) {
        if (![strShopID isEqualToString:model.shopId]) {
            NSMutableArray *mArrShop0 = [[NSMutableArray alloc] init];
            [mArrShop0 addObject:model];
            [allShop addObject:mArrShop0];
        }else{
            NSMutableArray *mArrShop0 = allShop[allShop.count - 1];
            [mArrShop0 addObject:model];
        }
//        strShopID = model.vShopId;
        strShopID = model.shopId;
        

    }
    
    
    return allShop;
}




- (IBAction)setCountCutBtnClicked:(id)sender {
    NSInteger num = [_setCountTextField.text integerValue];
    if (num>1) {

    num--;
    _setCountTextField.text = @(num).stringValue;
        _setCountCutBtn.alpha = 1;
        _setCountCutBtn.enabled = YES;
    }
    else
    {
        [self makeAlertTip:1 :@"最小购买数量为1"];
        _setCountCutBtn.alpha = 0.8;
        _setCountCutBtn.enabled = NO;
    }
    if (num>1) {
        _setCountCutBtn.enabled = YES;
        _setCountCutBtn.alpha = 1;
    }
    if (num<100) {
        _setCountAddBtn.enabled = YES;
        _setCountAddBtn.alpha = 1;
    }

    
}

- (IBAction)setCountAddBtnClicked:(id)sender {
    NSInteger num = [_setCountTextField.text integerValue];
    
   
    if (num<_maxGoodsNum) {

        num++;
    _setCountTextField.text = @(num).stringValue;
        _setCountAddBtn.enabled = YES;
        _setCountAddBtn.alpha = 1;
    }
    else
    {
        [self makeAlertTip:_maxGoodsNum :[NSString stringWithFormat:@"最大购买数量为%ld",_maxGoodsNum]];
        _setCountAddBtn.alpha = 0.8;
        _setCountAddBtn.enabled = NO;
    }
    if (num>1) {
        _setCountCutBtn.enabled = YES;
        _setCountCutBtn.alpha = 1;
    }
    if (num<100) {
        _setCountAddBtn.enabled = YES;
        _setCountAddBtn.alpha = 1;
    }
}

- (IBAction)setCountCancelBtnClicked:(id)sender {
    [_blackBackGroundView removeFromSuperview];
    [_setCountView removeFromSuperview];
}

- (void)makeAlertTip:(NSInteger)goodsNum :(NSString*)tipStr {
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    tipLabel.backgroundColor = [UIColor blackColor];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.center = CGPointMake(kScreenWidth*0.5, _setCountConfirmBtn.frame.origin.y-10);
    [_setCountView addSubview:tipLabel];
    tipLabel.text = tipStr;//;
    _setCountTextField.text = @(goodsNum).stringValue;
    [UIView animateWithDuration:2 animations:^{
        tipLabel.alpha = 0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tipLabel removeFromSuperview];
    });
}

- (IBAction)setCountConfirmBtnClicked:(id)sender {
    NSInteger num = [_setCountTextField.text integerValue];
    
    if (num<=0) {
        [self makeAlertTip:1 :@"最小购买数量为1"];
    }
    else if (num>_maxGoodsNum)
    {
        NSString *str = [NSString stringWithFormat:@"最大购买数量为%ld",_maxGoodsNum] ;
        [self makeAlertTip:_maxGoodsNum : str];
    }
    else{
    [_blackBackGroundView removeFromSuperview];
    [_setCountView removeFromSuperview];
    _cartCellsetNumBlock(num);
        
    //modify by shiang
    [self updateCartGoodsNumber:num inWhichRow:selectedGoodsRow];
    }
}

//modify by shiang,修改购物车商品数量
-(void)updateCartGoodsNumber:(NSInteger)number inWhichRow:(NSInteger)row
{
    NSString *url = [[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/updateCartNumber"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@(number).stringValue forKey:@"number"];
    [parameters setValue:[mArrData[row] cartId] forKey:@"cartId"];
    [parameters setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    
    [Network  HttpGetForRequetURL:url parameters:parameters requetResult:^(NSData *jsonData, NSError *error){
        
        //[Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            
            //[Utils hideHudViewWithSuperView:self.view];
        }else{
            
        }
        
    }];
}

- (void)setCountTextFieldDidChanged:(UITextField*)textField
{
    NSString *str = textField.text;
    NSInteger count = str.integerValue;
    if (count>_maxGoodsNum) {
        _setCountAddBtn.alpha = 0.8;
        _setCountAddBtn.enabled = NO;
        textField.text = @(_maxGoodsNum).stringValue;
        [self makeAlertTip:_maxGoodsNum :[NSString stringWithFormat:@"最大购买数量为%ld",_maxGoodsNum]];
    }
    if (str&&str.length>0&&count<1) {
        _setCountCutBtn.alpha = 0.8;
        _setCountCutBtn.enabled = NO;
        textField.text = @(1).stringValue;
        [self makeAlertTip:1:[NSString stringWithFormat:@"最小购买数量为%ld",1]];
    }
    if (count>1) {
        _setCountCutBtn.enabled = YES;
        _setCountCutBtn.alpha = 1;
    }
    if (count<_maxGoodsNum) {
        _setCountAddBtn.enabled = YES;
        _setCountAddBtn.alpha = 1;
    }
}


@end
