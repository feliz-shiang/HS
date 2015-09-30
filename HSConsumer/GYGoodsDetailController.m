
//
//  GYGoodsDetailController.m
//  HSConsumer
//
//  Created by 00 on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYGoodsDetailController.h"
#import "GYPayoffViewController.h"
#import "UIView+CustomBorder.h"
#import "GYGoodsDetaiCell.h"
#import "GYSelCell.h"
#import "GYSelModel.h"
#import "GYSetNumCell.h"
#import "GYGoodsDetailModel.h"
#import "UIImageView+WebCache.h"
#import "GYGoodsParameterViewController.h"
#import "GYSelShopVC.h"
#import "GYSelBtn.h"
#import "GYMainEvaluateDetailViewController.h"
#import "GYPicDtVC.h"
#import "GYChatItem.h"
#import "GYChatViewController.h"
#import "GYCartViewController.h"
#import "GYShopDetailViewController.h"
 
#import "GYStoreDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import "GYPhoneScr.h"
#import "MWPhotoBrowser.h"

@interface GYGoodsDetailController ()<UITableViewDelegate,UITableViewDataSource,GYSelShopDelegate,GYSetNumCellDelegate,MWPhotoBrowserDelegate,UIWebViewDelegate>
{
    
    __weak IBOutlet UIScrollView *scv;//scrollView
    __weak IBOutlet UIImageView *imgBig;//大图
    __weak IBOutlet UITableView *tbv;
    
    __weak IBOutlet UIView *vDetail;//细节View－－－－－－－－－－－－－
    __weak IBOutlet UILabel *lbGoodsTitle;//商品名称
    __weak IBOutlet UILabel *lbPrice;//商品价格
    __weak IBOutlet UILabel *lbPVTitle;//PV名称
    __weak IBOutlet UILabel *lbPV;//PV值
    __weak IBOutlet UILabel *lbSales;//月销量
    __weak IBOutlet UIButton *btnCollect;//收藏按钮
    
    //    __weak IBOutlet UIView *_vButton;//按钮View－－－－－－－－－－－－－－
    __weak IBOutlet UIButton *btnContact;//联系买家按钮
    __weak IBOutlet UIButton *btnAdd;//添加至购物车按钮
    __weak IBOutlet UIButton *btnBuy;//立即购买按钮
    
    __weak IBOutlet UIView *vSel;//弹窗View
    __weak IBOutlet UIView *vTitle;//标题View
    __weak IBOutlet UIImageView *imgTitle;//图片
    __weak IBOutlet UILabel *lbTitle;//商品标题
    __weak IBOutlet UILabel *lbPriceSel;//商品价格
    __weak IBOutlet UIButton *btnSelClose;//关闭弹窗按钮
    
//    __weak IBOutlet UITableView *_tbvSel;//弹窗tableView
    __weak IBOutlet UIView *_vButtonSel;//弹窗按钮View
    
    __weak IBOutlet UIButton *btnContactPro;
    __weak IBOutlet UIButton *btnEnterShop;
    UIView * touchView;
    NSArray * arrData;
    
    CGRect frame;
    CGRect frameSel;
    
    
    
    GYGoodsDetailModel *detailmodel;
    CGFloat tbvSelHeight;
    NSMutableArray *mArrBtnView;//btnView
    NSMutableArray *mArrBtn;//按钮数组
    NSString *strRetShopName;//返回店名
    NSString *strRetShopId;//返回店名
    NSString *strRetParameter;//返回参数项目名字
    NSMutableString *strRetParameterVl;//返回参数项目名字
    NSMutableString * strSkus;
    
    NSMutableArray *mArrjson;//选择按钮的数组
    
    SelShopModel *selShopModel1;
    
    NSString * defaultShopId;
    NSString * defaultShopName;
    NSString * strPictureUrl;
    
    NSString * strSelectStandard;
    NSMutableArray * marrSelectStandard;
    
    __weak IBOutlet UIButton *btnEnterShopPro;
        //后添加的View
    __weak IBOutlet UILabel *lbBeReach;
    
    __weak IBOutlet UIImageView *imgvBeReach;

    __weak IBOutlet UILabel *lbBeSell;
    __weak IBOutlet UIImageView *imgvBeSell;
    __weak IBOutlet UILabel *lbBeCash;
    
    __weak IBOutlet UIImageView *imgvBeCash;
    
    __weak IBOutlet UILabel *lbBeTake;
    __weak IBOutlet UIImageView *imgvBeTake;
    
    __weak IBOutlet UILabel *lbBeTicket;
    __weak IBOutlet UIImageView *imgvBeTicket;
    __weak IBOutlet UILabel *lbCity;
    __weak IBOutlet UILabel *lbCompanyName;
    
    BOOL isShow;
    
    __weak IBOutlet UILabel *lbLineOne;
    __weak IBOutlet UILabel *lbMonthlySale;
    NSString *shareContent;///分享内容
    NSString *shareitemUrl;////分享商品链接
    NSString *sharegoods;////分享商品详情
    NSString *shareImageUrl;/////分享图片的url
}
@property (weak, nonatomic) IBOutlet UIView *goodsServiceInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsDetailIV1;
@property (weak, nonatomic) IBOutlet UIImageView *goodsDetailIV2;
@property (weak, nonatomic) IBOutlet UIImageView *goodsDetailIV3;
@property (weak, nonatomic) IBOutlet UIImageView *goodsDetailIV4;
@property (weak, nonatomic) IBOutlet UIImageView *goodsDetailIV5;
@property (nonatomic,strong)NSMutableArray *photos;
@property(nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong)UILabel *moreInfoLabel;
@property (nonatomic,strong)GYPicDtVC *dtvc;
//add by zhangqy
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,assign)BOOL hasAddWebView;
@property (assign,nonatomic)NSInteger goodsNum;
// add by songjk
@property (weak, nonatomic) IBOutlet UILabel *lbExpressFee;
@property (weak, nonatomic) IBOutlet UILabel *lbExpressInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbExpressTitle;
@property (weak, nonatomic) IBOutlet UIImageView *mvExpressCoin;


@end

@implementation GYGoodsDetailController


//按钮点击事件


//收藏
- (IBAction)btnCollectClick:(id)sender {
    
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:YES];
        return;
    }
    
    if (btnCollect.selected) {
        //取消收藏
        NSLog(@"取消收藏");
        
        [self requestToCancelCollect];
        
    }else{
        [self requestToCollect];
    }
}


//联系买家
- (IBAction)btnContactClick:(id)sender {
    
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:YES];
        return;
    }
    
    if (self.navigationController.navigationBarHidden == YES) {
        [self btnSelCloseClick:btnSelClose];
    }
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:[NSString stringWithFormat:@"%@",  detailmodel.companyResourceNo] forKey:@"resourceNo"];
    
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getVShopShortlyInfo" ] parameters:dict requetResult:^(NSData *jsonData, NSError *error){
        
        if (!error)
        {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error)
            {
                
                NSString * retCode =[NSString stringWithFormat:@"%@",dic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"] && [dic[@"data"] isKindOfClass:[NSDictionary class]])
                {
                    dic = dic[@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        GYChatViewController *vc = [[GYChatViewController alloc] init];
                        GYChatItem *chatItem = [[GYChatItem alloc] init];
                        chatItem.msgIcon = kSaftToNSString(dic[@"logo"]);
                        chatItem.vshopName = kSaftToNSString(dic[@"vShopName"]);
                        chatItem.msgNote = kSaftToNSString(dic[@"vShopName"]);
                        chatItem.resNo = kSaftToNSString(detailmodel.companyResourceNo);
                        
                        vc.chatItem = chatItem;
                        vc.chatItem.fromUserId = [NSString stringWithFormat:@"%@@%@",chatItem.resNo, [GlobalData shareInstance].hdDomain];
                        vc.chatItem.msgNote = vc.chatItem.vshopName;
                        vc.chatItem.content = @"";
                        vc.chatItem.msg_Type = 1;
                        vc.chatItem.msg_Code = 103;
                        vc.chatItem.sub_Msg_Code = 10301;
                        vc.msgType = 2;
                        vc.dicShopInfo = dic;
                        vc.chatItem.isSelf = YES;
                        vc.chatItem.vshopID = kSaftToNSString(dic[@"vShopId"]);
                        vc.navigationItem.title = chatItem.vshopName;
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        [vc.chatItem updateNotReadWithKey:vc.chatItem WithTableType:2];
                        
                    });
                    
                }
            }
            
        }
        
    }];
    
}

//加入购物车
- (IBAction)btnAddClick:(id)sender {
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:YES];
        return;
    }
    
    for (GYSelBtn *btn in mArrjson) {
        
        if (btn.selected==NO) {
            if (isShow) {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请先选择商品类型" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
        
        
        if (btn.selected == NO) {
            [self showSKUView];
            break;
        }
        if (btn == mArrjson[mArrjson.count - 1]) {
            if (btn.selected == YES) {
                if (detailmodel.strSkuId) {
                    
                    [self addToNetCard];
                    [self hideSKUView];
                }
            }
        }
    }
}

//立即购买
- (IBAction)btnBuyClick:(id)sender
{



    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:YES];
        return;
    }
    
    for (GYSelBtn *btn in mArrjson) {
        
        
        if (btn.selected==NO) {
            if (isShow) {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请先选择商品类型" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
        
        if (btn.selected == NO) {
            
            NSLog(@"------123");
            [self showSKUView];
            
        
            break;
         
        }
        
        if (_goodsNum <=0) {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"最小购买数量为1" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            break;
        }
        
        
        if (btn == mArrjson[mArrjson.count - 1]) {
            
            
            if (btn.selected == YES) {
                if (detailmodel.strSkuId) {
                    [self hideSKUView];
                    
                    if (self.navigationController.navigationBarHidden == YES) {
                        [self hideSKUView];
                    }
                    
                    
                    GYPayoffViewController *vc = [[GYPayoffViewController alloc] init];
                    NSMutableArray *mArrTemp = [self buildPayoffJson];
                    vc.isRightAway = @"1";
                    vc.mArrShop = mArrTemp;
                    vc.strPictureUrl=strPictureUrl;
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        } else
        {
//            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请选择商品类型" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//            [av show];
        }
       
    }
}


//收回弹窗

- (IBAction)btnSelCloseClick:(id)sender {
    [self hideSKUView];
}


//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－


- (void)viewDidLoad {
    [super viewDidLoad];
    _hasAddWebView = NO;
    scv.showsVerticalScrollIndicator = NO;
    strRetShopName = @"选择";
    strRetParameter = @"000000";
    lbCity.textColor=kCellItemTextColor;
    lbCompanyName.textColor=kCellItemTextColor;
    // add by songjk
    self.lbExpressInfo.textColor =kCellItemTextColor ;
    self.lbExpressFee.textColor =kCellItemTextColor ;
    self.lbExpressTitle.textColor =kCellItemTextColor ;
    self.lbExpressInfo.text =@"0";
    self.lbExpressFee.text = @"0";
    strRetParameterVl = [@"" mutableCopy];
    strSelectStandard=@"";
    strSkus=[@"" mutableCopy];
    marrSelectStandard=[NSMutableArray array];
    mArrjson = [[NSMutableArray alloc] init];
    detailmodel = [[GYGoodsDetailModel alloc] init];
    mArrBtnView = [[NSMutableArray alloc] init];
    mArrBtn = [[NSMutableArray alloc] init];
    [self initSubViews];
    UIImage* image= kLoadPng(@"ep_img_nav_cart");
    CGRect backframe= CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushCartVc:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    UIButton   *btnRight =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnRight setImage:[UIImage imageNamed:@"share_shop.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(sharebtnrating:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rig=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItems=@[btnSetting,rig];//////分享
    [self getNetData];
    self.title = @"商品详情";
    [btnCollect setImage:[UIImage imageNamed:@"ep_btn_collect_yes.png"] forState:UIControlStateSelected];
    [btnCollect setImage:[UIImage imageNamed:@"ep_btn_collect.png"] forState:UIControlStateNormal];
    vSel.frame = CGRectMake(0, 550, 320, 0);
    arrData = [NSArray arrayWithObjects:
               @"选择营业点",
               strRetParameter,
              // @"图文详情",
               @"基本参数",
               @"商品评价",
               nil];
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.scrollEnabled = NO;
    tbv.frame = CGRectMake(tbv.frame.origin.x, tbv.frame.origin.y, tbv.frame.size.width, arrData.count * 44 - 0.5);
    [tbv registerNib:[UINib nibWithNibName:@"GYGoodsDetaiCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    _tbvSel.delegate = self;
    _tbvSel.dataSource = self;
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        [_tbvSel setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    UIView *vFooter = [[UIView alloc] init];
    vFooter.backgroundColor = kClearColor;
    _tbvSel.tableFooterView = vFooter;
    
    [_tbvSel registerNib:[UINib nibWithNibName:@"GYSelCell" bundle:nil] forCellReuseIdentifier:@"CELLSEL"];
    [_tbvSel registerNib:[UINib nibWithNibName:@"GYSetNumCell" bundle:nil] forCellReuseIdentifier:@"CELLNUM"];
    
    //设置控件边框
    
    [_vButton addTopBorderAndBottomBorder];
    [vDetail addTopBorderAndBottomBorder];
    [tbv addTopBorderAndBottomBorder];
    [btnCollect addLeftBorder];
    lbPVTitle.layer.borderWidth = 1.0;
    lbPVTitle.layer.cornerRadius = 2.0;
    lbPVTitle.layer.borderColor = kCorlorFromRGBA(0,170,230,1.0).CGColor;
    
    [vSel addTopBorderAndBottomBorder];
    [vTitle addTopBorderAndBottomBorder];
    [_vButtonSel addTopBorderAndBottomBorder];
    [lbLineOne addTopBorder];
    
    [btnCollect setImage:[UIImage imageNamed:@"ep_btn_collect.png"] forState:UIControlStateNormal];
    btnCollect.titleEdgeInsets = UIEdgeInsetsMake(0,-100,-50, -40);
      [btnEnterShop setImage:[UIImage imageNamed:@"image_enter_shop.png"] forState:UIControlStateNormal];
    
    btnEnterShop.imageEdgeInsets=UIEdgeInsetsMake(0, 19, 18, 19);
    btnEnterShop.titleEdgeInsets=UIEdgeInsetsMake(22, -btnEnterShop.frame.size.width-10, 0, 0);// 调整按钮文字位置
    
       btnEnterShop.titleLabel.font=[UIFont systemFontOfSize:10.0];
    [btnEnterShopPro setImage:[UIImage imageNamed:@"image_enter_shop.png"] forState:UIControlStateNormal];
    btnEnterShopPro.imageEdgeInsets=UIEdgeInsetsMake(0, 19, 18, 19);
    btnEnterShopPro.titleEdgeInsets=UIEdgeInsetsMake(26, -btnEnterShopPro.frame.size.width+10, 0, 0);
    btnEnterShopPro.titleLabel.font=[UIFont systemFontOfSize:10.0];

    [btnContact setImage:[UIImage imageNamed:@"image_contact_shop.png"] forState:UIControlStateNormal];
    btnContact.imageEdgeInsets=UIEdgeInsetsMake(0, 22, 18, 22);
    btnContact.titleLabel.font=[UIFont systemFontOfSize:10.0];
    btnContact.titleEdgeInsets= UIEdgeInsetsMake(22, -btnContact.frame.size.width+19, 0, 0);
    [btnContact addAllBorder];
    [btnContactPro setImage:[UIImage imageNamed:@"image_contact_shop.png"] forState:UIControlStateNormal];
    btnContactPro.imageEdgeInsets=UIEdgeInsetsMake(0, 22, 18, 22);
    btnContactPro.titleLabel.font=[UIFont systemFontOfSize:10.0];
    btnContactPro.titleEdgeInsets= UIEdgeInsetsMake(26, -btnContactPro.frame.size.width+19, 0, 0);
    [btnContactPro addAllBorder];
     [btnContactPro setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
     [btnEnterShopPro setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnEnterShop setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [btnContact setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    
    //临时设置
    _vButton.frame = CGRectMake(0, kScreenHeight - 44, _vButton.frame.size.width, _vButton.frame.size.height);
    [self.tabBarController.view.window addSubview:_vButton];
    
    touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    touchView.backgroundColor = [UIColor blackColor];
    touchView.alpha = 0.5;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnSelCloseClick:)];
    [touchView addGestureRecognizer:tap];
    
    frame = CGRectMake(_vButton.frame.origin.x, _vButton.frame.origin.y, _vButton.frame.size.width, _vButton.frame.size.height);
    
    frameSel = CGRectMake(_vButtonSel.frame.origin.x, _vButtonSel.frame.origin.y, _vButtonSel.frame.size.width, _vButtonSel.frame.size.height);
    
    
    [self.mainScrollView addSubview:imgBig];
    
    UITapGestureRecognizer * tapBigImg =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigScro:)];
    
    [self.mainScrollView addGestureRecognizer:tapBigImg];
    scv.delegate = self;
    _goodsNum = 1;
    
    
    if ([GlobalData shareInstance].currentDeviceScreenInch==kDeviceScreenInch_3_5) {
        scv.contentSize = CGSizeMake(320, 980);
    }else
    {
        scv.contentSize = CGSizeMake(320, 900);
    }
    _vButton.frame = frame;
    _vButtonSel.frame = frameSel;
    [tbv reloadData];
    CGRect mFrame = CGRectMake(0, tbv.frame.origin.y+tbv.frame.size.height, kScreenWidth, 50);
    _moreInfoLabel = [[UILabel alloc]initWithFrame:mFrame];
    _moreInfoLabel.textAlignment = NSTextAlignmentCenter;
    _moreInfoLabel.font = [UIFont systemFontOfSize:14];
    _moreInfoLabel.textColor = [UIColor grayColor];
    _moreInfoLabel.text = @"继续拖动，查看图文详情";
    [scv addSubview:_moreInfoLabel];
    
    
    
}




#pragma mark  几个特殊服务排版
-(UIView *)listSurppotWay
{
    UIView * backGroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    backGroundView.backgroundColor=[UIColor whiteColor];
    NSArray * arrSpecialService = [NSArray arrayWithObjects:detailmodel.beReach,detailmodel.beSell,detailmodel.beCash,detailmodel.beTake,detailmodel.beTicket,nil];
    NSArray *title = @[@"即时送达",@"送货上门",@"货到付款",@"门店自提",@"消费抵扣券"];
    if (!arrData.count>0) {
        return nil;
    }
#pragma mark 特殊服务
    CGFloat xw=16;///首行x轴坐标
    CGFloat Yh=20;//首行Y轴坐标
    CGFloat jux=20;//x方向的间距
    CGFloat juy= 15;//Y方向的间距
    CGFloat w=(kScreenWidth-(xw*2)-(jux*2))/3;///整个bgview 的宽度
    CGFloat h=25;///bgview的高度
    for (int i=0; i<arrSpecialService.count; i++) {
        ///先循环5个图片
        UIView *bgView=[[UIView alloc]init];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.frame = CGRectMake(xw+(w+jux)*(i%3), Yh+(h+juy)*(i/3), w+10, h);
        ///添加小图标
        BOOL imagebg=[[NSString stringWithFormat:@"%@",arrSpecialService[i]] isEqual:@"1"]?YES:NO;
        UIImageView *imag=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, h-2, h-2)];
        if (imagebg)
            imag.image= [UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail%d",i+1]];
        else
            imag.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail_unselected_%d",i+1]];
        [bgView addSubview:imag];
        //添加label
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(h+2, 0, bgView.bounds.size.width-h, h)];
        lab.textColor=kCellItemTextColor;
        lab.backgroundColor = [UIColor clearColor];
        lab.text = [title objectAtIndex:i];
        lab.font=[UIFont systemFontOfSize:12.0f];
        [bgView addSubview:lab];
        [backGroundView addSubview:bgView];
    }
//    CALayer *topBorder = [CALayer layer];
//    topBorder.backgroundColor =[[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_confirm_dialog_yellow.png"] ] CGColor];
//    topBorder.frame = CGRectMake(backGroundView.frame.origin.x+16   , 0, CGRectGetWidth(backGroundView.frame)-32    , 1.0f);
//    [backGroundView.layer addSublayer:topBorder];
    return backGroundView;
}


-(void)initSubViews
{
    lbBeCash.textColor=kCellItemTitleColor;
    lbBeReach.textColor=kCellItemTitleColor;
    lbBeSell.textColor=kCellItemTitleColor;
    lbBeTake.textColor=kCellItemTitleColor;
    lbBeTicket.textColor=kCellItemTitleColor;
    lbMonthlySale.textColor=kCellItemTextColor;
    lbMonthlySale.adjustsFontSizeToFitWidth = YES;
}

-(void)showBigScro:(UITapGestureRecognizer *)tap
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (int i=0; i<detailmodel.arrPicList.count; i++){
        ArrModel * modelForImage =detailmodel.arrPicList[i];
        NSString *strUrl =kSaftToNSString(modelForImage.picUrl);
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:strUrl]]];
    }
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    enableGrid = NO;
    self.photos = photos;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.customRigthButton = NO;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    browser.showIndexOfCount = YES;//add
    browser.clickDismissPhotoBrowser = YES;//add
    [browser setCurrentPhotoIndex:self.currentIndex];
    
    browser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:browser animated:YES completion:nil ];
}

//进入购物车
- (void)pushCartVc:(id)sender
{
    GlobalData *data = [GlobalData shareInstance];
    if (!data.isEcLogined)
    {
        [data showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    DDLogDebug(@"into cart.");//ep_img_nav_cart.png
    GYCartViewController *vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYCartViewController class]));
    vcCart.navigationItem.title = kLocalized(@"ep_shopping_cart");
    [self.navigationController pushViewController:vcCart animated:YES];
}

#pragma mark 分享按钮
-(void)sharebtnrating:(UIButton *)sender
{
    //创建分享参数
    shareContent=[NSString stringWithFormat:@"%@%@%@",detailmodel.title,shareitemUrl,sharegoods];
    UIImage *iamge=[[UIImage alloc ]init];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (detailmodel.arrPicList.count>0) {
        ArrModel *arrModel = [[ArrModel alloc] init];
        arrModel=detailmodel.arrPicList[0];
        NSURL *url=[NSURL URLWithString:arrModel.picUrl];
        NSData *data=[NSData dataWithContentsOfURL:url];
        iamge=[UIImage imageWithData:data];
        [shareParams SSDKSetupShareParamsByText:shareContent
                                         images:@[iamge]
                                            url:[NSURL URLWithString:@"http://www.hsxt.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeImage];
        
    }else{
        [shareParams SSDKSetupShareParamsByText:shareContent
                                         images:nil
                                            url:[NSURL URLWithString:@"http://www.hsxt.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeImage];
    }
    [ShareSDK showShareActionSheet:sender
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           //                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
               }];
}



#warning scvsize
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (kSystemVersionLessThan(@"7.0")) //ios < 7.0
    {
        //设置Navigation颜色
        //[[UINavigationBar appearance]setTintColor:[UIColor redColor]];
        //add by shiang
        [self.navigationController.navigationBar setBackgroundImage:[self buttonImageFromColor:[UIColor redColor]] forBarMetrics:UIBarMetricsDefault];
        
// [[UINavigationBar appearance]setBackgroundColor:[UIColor redColor]];无效
    }else
    {
        //        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
        self.navigationController.navigationBar.barTintColor =[UIColor redColor];
        //        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    }
    
    //隐藏 navigationController
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO   animated:YES];

    _vButton.frame = frame;
    _vButtonSel.frame = frameSel;
    [tbv reloadData];
//    CGRect mFrame = CGRectMake(0, tbv.frame.origin.y+tbv.frame.size.height, kScreenWidth, 50);
//    _moreInfoLabel = [[UILabel alloc]initWithFrame:mFrame];
//    _moreInfoLabel.textAlignment = NSTextAlignmentCenter;
//    _moreInfoLabel.font = [UIFont systemFontOfSize:14];
//    _moreInfoLabel.textColor = [UIColor grayColor];
//    _moreInfoLabel.text = @"继续拖动，查看图文详情";
//    [scv addSubview:_moreInfoLabel];

}

- (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


-(void)setScrollviewContentSize
{
    CGSize size =self.mainScrollView.contentSize;
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth*(detailmodel.arrPicList.count), size.height);
}

-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_mainScrollView.frame)-20, kScreenWidth, 20)];
        _pageControl.numberOfPages=detailmodel.arrPicList.count;
        
        _pageControl.currentPage=0;
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    }
    
    return _pageControl;
}

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 320)];
        _mainScrollView.showsHorizontalScrollIndicator=NO;
        _mainScrollView.contentSize=CGSizeMake(kScreenWidth*1, 200);
        _mainScrollView.bounces=NO;
        _mainScrollView.delegate=self;
        _mainScrollView.pagingEnabled=YES;
        
    }
    return _mainScrollView;
}



#pragma mark scrollview代理方法。





- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger  pageIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    if (scrollView==self.mainScrollView) {
        
        self.pageControl.currentPage=pageIndex;
        
        UIImageView * imageViewPic =[[UIImageView alloc]initWithFrame:CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        [imageViewPic setBackgroundColor:[UIColor whiteColor]];
//        imageViewPic.contentMode=UIViewContentModeCenter;
        [imageViewPic setContentMode:UIViewContentModeScaleAspectFit];
        ArrModel *arrModel = detailmodel.arrPicList[pageIndex];
//        [detailmodel.arrPicList addObject:arrModel];
        [imageViewPic sd_setImageWithURL:[NSURL URLWithString:arrModel.picUrl] placeholderImage:kLoadPng(@"ep_placeholder_image_type1") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image)
            {
                [imageViewPic setImage:image];
            }
        }];
        [scrollView addSubview:imageViewPic];
    }
}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentIndex = (scrollView.contentOffset.x+scrollView.frame.size.width*0.5)/scrollView.frame.size.width;
    //add by zhangqy  上拉加载图文详情
    
    if (scrollView == scv) {
        CGFloat firstOffSetY = tbv.frame.origin.y+tbv.frame.size.height-kScreenHeight+160;
        //CGFloat secondOffSetY = tbv.frame.origin.y+tbv.frame.size.height+50;
        CGFloat offSetY = scv.contentOffset.y;
        
        if (offSetY>firstOffSetY+50)
        {
            [self.view addSubview:self.webView];
            [UIView animateWithDuration:0.25 animations:^{
                CGRect wframe = self.webView.frame;
                wframe.origin.y = 0;
                self.webView.frame = wframe;
                
                CGRect sframe = scv.frame;
                sframe.origin.y = -kScreenHeight;
                scv.frame = sframe;
                scv.alpha = 0;
                self.webView.alpha = 1;
            }];
        }
    }
    else if (scrollView == self.webView.scrollView) {
        CGFloat offSetY = self.webView.scrollView.contentOffset.y;
        if (offSetY<-50&&self.webView.scrollView.zoomScale==1.0f) {
            
            [UIView animateWithDuration:0.25 animations:^{
                CGRect wframe = self.webView.frame;
                wframe.origin.y = kScreenHeight;
                self.webView.frame = wframe;
                
                CGRect sframe = scv.frame;
                sframe.origin.y = 0;
                scv.frame = sframe;
                scv.alpha = 1;
                self.webView.alpha = 0;
                
            }];
            //[self.webView removeFromSuperview];
            
            
            
        }
    }
}
//保存浏览历史记录
- (void)saveBrowsingHistory:(GYEasyBuyModel *)model
{
    model.numBroweTime = @([[NSDate date] timeIntervalSince1970]);//用于显示排序
    NSString *key = kKeyForBrowsingHistory;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dicBrowsing = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    if (!(model.strGoodPictureURL.length>0||model.strGoodName.length>0||model.strGoodPrice.length>0||model.strGoodId.length>0||model.shopInfo.strShopId.length>0)) {
        return;
    }
    NSDictionary *dicGoods = @{@"goodsPictureUrl":model.strGoodPictureURL,
                               @"goodsName":model.strGoodName,
                               @"goodsPrice":model.strGoodPrice,
                               @"goodsId":model.strGoodId,
                               @"shopId":model.shopInfo.strShopId,
                               @"numBroweTime":model.numBroweTime
                               };
    [dicBrowsing setObject:dicGoods forKey:model.strGoodId];
    
    //保存
    [userDefault setObject:dicBrowsing forKey:key];
    [userDefault synchronize];
}

-(void)viewWillDisappear:(BOOL)animated
{
    _vButton.frame = CGRectMake(_vButton.frame.origin.x, _vButton.frame.origin.y + 100, _vButton.frame.size.width, _vButton.frame.size.height);
    _vButtonSel.frame = CGRectMake(_vButton.frame.origin.x, _vButton.frame.origin.y + 100, _vButton.frame.size.width, _vButton.frame.size.height);
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbvSel) {
        return detailmodel.arrPropList.count +1;
    }else{
        return arrData.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbvSel) {
        
        if (indexPath.row == detailmodel.arrPropList.count) {
            return 44;
        }else{
            UIView *view = mArrBtnView[indexPath.row];
            return 44 + view.frame.size.height;
        }
        
    }else
        
    {
        return 44;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbvSel) {
        if (indexPath.row == detailmodel.arrPropList.count) {
            GYSetNumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLNUM"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }else{
            GYSelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLSEL"];
            ArrModel *arrModel = detailmodel.arrPropList[indexPath.row];
            cell.lbTitle.text = arrModel.propName;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (cell.btnView != nil) {
                [cell.btnView removeFromSuperview];
                cell.btnView = nil;
            }
            cell.btnView = mArrBtnView[indexPath.row];
            [cell addSubview:cell.btnView];
            
            return cell;
            
        }
        
    }else{
        GYGoodsDetaiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        
        if (indexPath.row == 0) {
            cell.lbTitle2.hidden = NO;
           cell.lbTitle2.text = strRetShopName;
        }else if (indexPath.row == 3) {
            cell.lbTitle2.hidden = NO;
            cell.lbTitle2.text = [NSString stringWithFormat:@"(%@条评价)",detailmodel.evaCount];
        }else{
            cell.lbTitle2.hidden = YES;
        }
        cell.lbTitle.text = arrData[indexPath.row];
        cell.lbTitle.font=[UIFont systemFontOfSize:15.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

//计算按钮行值
-(NSInteger)countY:(int)arrayCount
{
    NSInteger x;
    if (arrayCount%4 == 0) {
        x = arrayCount/4;
        return x;
    }else{
        x = arrayCount/4 +1;
        return x;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbv) {
        switch (indexPath.row) {
            case 0:
            {
                GYSelShopVC *vc = [[GYSelShopVC alloc] init];
                vc.title = @"选择营业点";
                vc.delegate = self;
                vc.model = detailmodel;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 1:
            {
                [self showSKUView];
            }
                break;
            case 20:
            {
                GYPicDtVC *vc = [[GYPicDtVC alloc] init];
                vc.title = @"图文详情";
                vc.model = detailmodel;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                // add by songjk
                if (detailmodel.arrBasicParameter.count == 0) {
                    [Utils showMBProgressHud:self SuperView:self.view Msg:@"该商品暂没有参数数据" ShowTime:0.5];
                    return;
                }
                GYGoodsParameterViewController *vc = [[GYGoodsParameterViewController alloc] init];
                vc.title = @"基本参数";
                vc.model = detailmodel;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                GYMainEvaluateDetailViewController * vcMainEvaluateDetail =[[ GYMainEvaluateDetailViewController alloc]initWithNibName:@"GYMainEvaluateDetailViewController" bundle:nil];
                vcMainEvaluateDetail.title=@"评价详情";
                vcMainEvaluateDetail.strGoodId=detailmodel.goodsID;
                [self.navigationController pushViewController:vcMainEvaluateDetail animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
}


#pragma mark - getNetData
//网络请求函数，包含网络等待弹窗控件，数据解析回调函数
-(void)getNetData
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:self.model.strGoodId forKey:@"itemId"];
    [dict setValue:self.model.shopInfo.strShopId forKey:@"vShopId"];
    
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getGoodsInfo",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            //网络请求错误
            [Utils showMessgeWithTitle:@"友情提示" message:@"系统繁忙" isPopVC:self.navigationController];
        }else{
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
                if ([str isEqualToString:@"200"]) {
                    detailmodel.title = ResponseDic[@"data"][@"title"];
                    // modify by songjk
                    NSNumber *pv = ResponseDic[@"data"][@"pv"];
                    detailmodel.pv = [NSString stringWithFormat:@"%.02f",[pv doubleValue]];
                    //                    detailmodel.pv = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"pv"]];
                    // add by songjk ruleId
                    shareitemUrl=ResponseDic[@"data"][@"itemUrl"];
                    sharegoods=ResponseDic[@"data"][@"introduces"];
                    detailmodel.strRuleID = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"ruleId"]];
                    detailmodel.vShopName = ResponseDic[@"data"][@"vShopName"];
                    detailmodel.vShopId = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"vShopId"]];
                    detailmodel.goodsID = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"id"]];
                    detailmodel.heightPrice = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"heightPrice"]];
                    NSNumber * lowPrice = ResponseDic[@"data"][@"lowPrice"];
                    detailmodel.lowPrice = [NSString stringWithFormat:@"%.02f",[lowPrice doubleValue]];
                    //                    detailmodel.lowPrice = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"lowPrice"]];
                    detailmodel.monthlySales = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"monthlySales"]];
                    detailmodel.saleCount = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"salesCount"]];
                    detailmodel.saleCount = kSaftToNSString(detailmodel.saleCount);
                    detailmodel.picDetails = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"picDetails"]];
                    
                    detailmodel.evaCount = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"evacount"]];
                    
                    detailmodel.categoryId = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"categoryId"]];
                    detailmodel.companyResourceNo = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"companyResourceNo"]];
                    detailmodel.heightAuction = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"heightAuction"]];
                    detailmodel.orderUrl = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"orderUrl"]];
                    detailmodel.serviceResourceNo = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"serviceResourceNo"]];
                    detailmodel.beFocus = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"beFocus"]];
                    detailmodel.strCity=kSaftToNSString(ResponseDic[@"data"][@"city"]);
                    if ([detailmodel.beFocus boolValue]) {
                        [btnCollect setTitle:@"已收藏" forState:UIControlStateNormal];
                        btnCollect.selected = YES;
                    }else{
                        [btnCollect setTitle:@"收藏" forState:UIControlStateNormal];
                        btnCollect.selected = NO;
                    }
                    // add by songjk 快递信息
                    detailmodel.isApplyCard = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"isApplyCard"]];
                    detailmodel.postage = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"postage"]];
                    detailmodel.postageMsg = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"postageMsg"]];
                    detailmodel.goodsNum = @"1";
                    //获取参数数据
                    for (NSDictionary *dic in ResponseDic[@"data"][@"basicParameter"]) {
                        ArrModel *arrModel = [[ArrModel alloc] init];
                        arrModel.key = [NSString stringWithFormat:@"%@",dic[@"key"]];
                        arrModel.value = [NSString stringWithFormat:@"%@",dic[@"value"]];
                        
                        [detailmodel.arrBasicParameter addObject:arrModel];
                    }
                    shareImageUrl = ResponseDic[@"data"][@"picList"][0];
                    for (NSDictionary *dic in ResponseDic[@"data"][@"picList"]) {
                        ArrModel *arrModel = [[ArrModel alloc] init];
                        arrModel.picUrl = dic[@"url"];
                        
                        [detailmodel.arrPicList addObject:arrModel];
                    }
                    //获取弹窗数据
                    strRetParameter = @"选择";
                    detailmodel.beReach= [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"beReach"]];
                      detailmodel.beSell= [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"beSell"]];
                    detailmodel.beTake= [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"beTake"]];
                    detailmodel.beTicket= [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"beTicket"]];
                    detailmodel.beCash= [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"beCash"]];
                    strRetShopName =  ResponseDic[@"data"][@"shopName"];
                  
                    strRetShopId =kSaftToNSString(ResponseDic [@"data"][@"shopId"]);
                    detailmodel.defaultShopId=kSaftToNSString(ResponseDic [@"data"][@"shopId"]);
                    detailmodel.defaultShopName=ResponseDic[@"data"][@"shopName"];
                    
                    for (NSDictionary *dic in ResponseDic[@"data"][@"propList"]) {
                        ArrModel *arrModel = [[ArrModel alloc] init];
                        arrModel.propId = [NSString stringWithFormat:@"%@",dic[@"id"]];
                        arrModel.propName = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        
                        strRetParameter = [NSString stringWithFormat:@"%@ %@",strRetParameter,arrModel.propName];
                        for (NSDictionary *dic1 in dic[@"subs"]) {
                            ArrSubsModel *subsModel = [[ArrSubsModel alloc] init];
                            subsModel.vid = [NSString stringWithFormat:@"%@",dic1[@"vid"]];
                            subsModel.vName = [NSString stringWithFormat:@"%@",dic1[@"vname"]];
                            
                            [arrModel.arrSubs addObject:subsModel];
                        }
                        [detailmodel.arrPropList addObject:arrModel];
                    }
                    [self setBtn];
                    [self getTbvHeight];
                    [Utils hideHudViewWithSuperView:self.view];
                    [self setViewValue];
                    [tbv reloadData];
                    
                    arrData = [NSArray arrayWithObjects:
                               @"选择营业点",
                               strRetParameter,
                            //   @"图文详情",
                               @"基本参数",
                               @"商品评价",
                               nil];
                    NSString * strGoodsUrl =@" ";
                    if (detailmodel.arrPicList.count > 0) {
                        
                    ArrModel *arrModel = detailmodel.arrPicList[0];
                     __block UIImage *bigImg = nil;
                        strGoodsUrl = arrModel.picUrl ;
                        
                        [imgBig sd_setImageWithURL:[NSURL URLWithString:arrModel.picUrl] placeholderImage:kLoadPng(@"ep_placeholder_image_type1") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image)
                            {
                                [imgBig setImage:image];
                                
                            }
                            [imgTitle setImage:imgBig.image];
                            bigImg=imgBig.image;
                            
                        }];
                    }else
                    {
                        imgBig.image = kLoadPng(@"ep_placeholder_image_type1");
                        [imgTitle setImage:imgBig.image];
                    }
                    self.model.strGoodPrice=detailmodel.lowPrice;
                    self.model.strGoodPictureURL = strGoodsUrl;
                    self.model.strGoodName =  detailmodel.title;
                    self.model.strGoodId =  detailmodel.goodsID;
                    ShopModel * shopModel = [[ShopModel alloc]init];
                    shopModel.strShopId = detailmodel.vShopId;
                    self.model.shopInfo=shopModel;
                    [self saveBrowsingHistory:self.model];
                    
                    [_tbvSel reloadData];
#pragma mark  这里放特殊服务的
                    [_goodsServiceInfoView addSubview:[self listSurppotWay]];//////新版的
//                    [self setSpecailService];///////以前的 特殊服务版本
                    [scv addSubview:self.mainScrollView];
                    
                    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth - 50)*0.5, CGRectGetMaxY(self.mainScrollView.frame)*0.95, 50, 15)];
                    if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
                    {
                        self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
                        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
                    }
                    self.pageControl.numberOfPages = detailmodel.arrPicList.count;
                    [scv addSubview:self.pageControl]; 
                    [ self  setScrollviewContentSize ];
                    [self webView];
                    //返回正确数据，并进行解析
                    
                }else if([str isEqualToString:@"507"])// songji 下架了
                {
                    [Utils showMessgeWithTitle:@"友情提示" message:@"商品已下架" isPopVC:self.navigationController];
                }
                else
                {
                    [Utils showMessgeWithTitle:@"友情提示" message:@"系统繁忙" isPopVC:self.navigationController];
                }
            }
        }
    }];
}


//zhangqy 图文详情页
- (UIWebView*)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-100)];
        _webView.scalesPageToFit = YES;
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:detailmodel.picDetails]];
        [_webView loadRequest:request];
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

-(void)setSpecailService
{
    NSArray * arrSpecialService = @[detailmodel.beReach,detailmodel.beSell,detailmodel.beCash,detailmodel.beTake,detailmodel.beTicket];
    NSArray * arrImgvSpecialService = @[imgvBeReach,imgvBeSell,imgvBeCash,imgvBeTake,imgvBeTicket];
    NSArray *goodsIVs = @[_goodsDetailIV1,_goodsDetailIV2,_goodsDetailIV3,_goodsDetailIV4,_goodsDetailIV5];
    for (int i=0 ; i<arrSpecialService.count;i++  ) {
        if (![arrSpecialService[i] isEqualToString:@"1"]) {
            UIView * tempV = arrImgvSpecialService[i];
            [tempV removeFromSuperview];
            UIImageView *iv = goodsIVs[i];
            iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail_unselected_%d",i+1]];
        }
    }
    

}

#pragma mark - addToNetCard
-(void)addToNetCard
{
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:detailmodel.goodsNum forKey:@"num"];
    
    [dict setValue:detailmodel.strPrice forKey:@"originalPrice"];
    [dict setValue:detailmodel.vShopId forKey:@"vShopId"];
    [dict setValue:detailmodel.vShopName forKey:@"vShopName"];
    [dict setValue:kSaftToNSString(strRetShopId) forKey:@"shopId"];
    [dict setValue:strRetShopName forKey:@"shopName"];
    [dict setValue:detailmodel.goodsID forKey:@"itemId"];
    [dict setValue:detailmodel.strSkuId forKey:@"skuId"];
    [dict setValue:[marrSelectStandard componentsJoinedByString:@","] forKey:@"skus"];
    
    NSLog(@"%@-------",[marrSelectStandard componentsJoinedByString:@","]);
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:@"2" forKey:@"sourceId"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getAddCart",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            //网络请求错误
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            if ([str isEqualToString:@"200"]) {
                //返回正确数据，并进行解析
                [Utils hideHudViewWithSuperView:self.view];
                UIAlertView *av =[[UIAlertView alloc] initWithTitle:nil message:@"成功添加到购物车" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
            }else{
                [Utils hideHudViewWithSuperView:self.view];
                UIAlertView *av =[[UIAlertView alloc] initWithTitle:nil message:@"添加到购物车失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                //返回数据不正确
            }
        }
    }];
    
}
#pragma mark - getSKUNetData
-(void)getSKUNetData
{
    //创建 json数组
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    NSMutableArray * tempArr =[NSMutableArray array];
    for (GYSelBtn *btn in mArrjson) {
        [mArray addObject:btn.dic];
        [tempArr addObject:[NSString stringWithFormat:@"%@:%@",btn.dic[@"pName"],btn.dic[@"pVName"]]];
        
        
        marrSelectStandard=tempArr;
        
        strSelectStandard = [NSString stringWithFormat:@"已选择 %@",[marrSelectStandard componentsJoinedByString:@" "]];
        strRetParameterVl = [[strRetParameterVl stringByAppendingString:[NSString stringWithFormat:@",%@",btn.dic[@"pVId"]]] mutableCopy];
        
    }
    
    strRetParameter=strSelectStandard;
    arrData = [NSArray arrayWithObjects:
               @"选择营业点",
               strRetParameter,
           //    @"图文详情",
               @"基本参数",
               @"商品评价",
               nil];
    
    
    strRetParameterVl = [[strRetParameterVl substringFromIndex:1] mutableCopy];
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"网络请求中"];
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:strRetParameterVl forKey:@"sku"];
    [dict setValue:detailmodel.goodsID forKey:@"itemId"];
    [dict setValue:detailmodel.vShopId forKey:@"vShopId"];
    
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getGoodsSKU",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
         [Utils hideHudViewWithSuperView:self.view.window];
        if (error) {
            //网络请求错误
            
        }else{
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"]) {
               
                strRetParameterVl=[@"" mutableCopy];
                //返回正确数据，并进行解析
                detailmodel.strPicList = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"picList"]];
//                NSLog(@"%@------dict",ResponseDic);
                if (ResponseDic[@"data"][@"picList"]) {
                    strPictureUrl=ResponseDic[@"data"][@"picList"][0][@"url"];
                    [imgTitle sd_setImageWithURL:[NSURL URLWithString:strPictureUrl] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1"]];
                }
                detailmodel.strPrice = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"price"]];
                detailmodel.strPv = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"pv"]];
                detailmodel.strSkuId = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"skuId"]];
                
                [self resetViewPrice];
                [tbv reloadData];
                
            }else{
//                [Utils hideHudViewWithSuperView:self.view];
                
                //返回数据不正确
            }
        }
    }];
}


#pragma mark - requestToCollect
//网络请求函数，包含网络等待弹窗控件，数据解析回调函数
-(void)requestToCollect
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:self.model.strGoodId forKey:@"itemId"];
    [dict setValue:self.model.shopInfo.strShopId forKey:@"vShopId"];
    
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/collectionGoods",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            //网络请求错误
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"]) {
                //返回正确数据，并进行解析
                NSLog(@"收藏成功");
                btnCollect.selected=YES;
                [btnCollect setTitle:@"已收藏" forState:UIControlStateNormal];
                [Utils showMessgeWithTitle:nil message:@"收藏成功！" isPopVC:nil];
            }else{
                //返回数据不正确
            }
        }
    }];
}

#pragma mark - requestToCancelCollect
//网络请求函数，包含网络等待弹窗控件，数据解析回调函数
-(void)requestToCancelCollect
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:self.model.strGoodId forKey:@"itemId"];
    //    [dict setValue:self.model.shopInfo.strShopId forKey:@"vShopId"];
    
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/cancelCollectionGoods",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            //网络请求错误
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"]) {
                //返回正确数据，并进行解析
                NSLog(@"取消收藏成功");
                btnCollect.selected=NO;
                [btnCollect setTitle:@"收藏" forState:UIControlStateNormal];
                [Utils showMessgeWithTitle:nil message:@"取消收藏成功！" isPopVC:nil];
            }else{
            }
        }
    }];
}

-(void)setBtn
{
    NSInteger z = 1;
    for (ArrModel *arrModel in detailmodel.arrPropList) {
        CGFloat x = 0;
        CGFloat y = 0;
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 200)];
        
        NSInteger s = 0;
        for (ArrSubsModel *subsModel in arrModel.arrSubs) {
            GYSelBtn *btn = [GYSelBtn buttonWithType:UIButtonTypeCustom];
            
            btn.dic = [[NSMutableDictionary alloc] init];
            
            btn.frame = CGRectMake(15 + x, 10 + y, 21 + subsModel.vName.length * 10, 21);
            
            if (x != 0 && btn.frame.origin.x + btn.frame.size.width > [UIScreen mainScreen].bounds.size.width) {
                x = 0;
                y = btn.frame.origin.y + btn.frame.size.height;
                btn.frame = CGRectMake(15 + x, 10 + y, 21 + subsModel.vName.length * 10, 21);
            }
            x = btn.frame.origin.x + btn.frame.size.width;
            [btn setTitle:subsModel.vName forState:UIControlStateNormal];
            [btn setTitle:subsModel.vName forState:UIControlStateHighlighted];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor whiteColor];
            
            btn.tag = z * 10000 + s;
            s++;
            
            btn.row = z -1;
            [btn.dic setValue:arrModel.propId forKey:@"pId"];
            [btn.dic setValue:arrModel.propName forKey:@"pName"];
            [btn.dic setValue:subsModel.vid forKey:@"pVId"];
            [btn.dic setValue:subsModel.vName forKey:@"pVName"];
            
            [mArrBtn addObject:btn];
            
            btnView.frame = CGRectMake(0, 34, [UIScreen mainScreen].bounds.size.width, btn.frame.origin.y + btn.frame.size.height);
            [btnView addSubview:btn];
            
            if (btn.row == mArrjson.count) {
                [mArrjson addObject:btn];
            }
            
        }
        z++;
        
        [mArrBtnView addObject:btnView];
    }
}


//按钮点击逻辑
-(void)btnClick:(GYSelBtn*)sender
{
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
        for (GYSelBtn *btn in mArrBtn) {
            //判断按钮是否是同一行
            if ((btn.tag > sender.tag && (btn.tag - sender.tag) < 100) ||(btn.tag < sender.tag && (sender.tag - btn.tag)< 100)) {
                btn.selected = NO;
                if (btn.selected == NO)
                {
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
//                break;
            }
        }
        //设置按钮选择颜色为红色
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    //取消按钮选择颜色
    for (GYSelBtn *btn in mArrBtn) {
        //判断按钮是否是同一行
        if ((btn.tag > sender.tag && (btn.tag - sender.tag) < 100) ||(btn.tag < sender.tag && (sender.tag - btn.tag)< 100)) {
            btn.selected = NO;
            if (btn.selected == NO)
            {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            break;
        }
    }
    
    //选择后更改json数组 选择按钮数据
    NSMutableArray *mArrTemp = [[NSMutableArray alloc] initWithArray:mArrjson];
    for (GYSelBtn *btnJson in mArrjson) {
        NSInteger i = 0;
        if (sender.row == btnJson.row) {
            [mArrTemp replaceObjectAtIndex:sender.row withObject:sender];
        }
        i++;
    }
    mArrjson = mArrTemp;
    
    for (GYSelBtn *btn in mArrjson) {
        if (btn.selected == NO) {
            
            break;
        }
        
        if (btn == mArrjson[mArrjson.count - 1]) {
            if (btn.selected == YES) {
               
             
                [self getSKUNetData];
            }
        }
    }
}


//获取tbvSel高度
-(void)getTbvHeight
{
    tbvSelHeight = 44;
    for (UIView* view in mArrBtnView) {
        tbvSelHeight = view.frame.size.height + tbvSelHeight + 44;
    }
}


//获取到SKU 重新设置view
-(void)setViewValue
{
    //大图
    // songjk
    lbGoodsTitle.text = detailmodel.title;
    lbPrice.text = detailmodel.lowPrice;
    lbPV.text = detailmodel.pv;
    lbPV.textColor = kCorlorFromRGBA(0, 143, 215, 1);
//    lbSales.text = [NSString stringWithFormat:@"月销%@笔",detailmodel.monthlySales];
    //小图
    
    lbTitle.text = detailmodel.title;
    lbPriceSel.text =detailmodel.lowPrice;
    lbCity.text=detailmodel.strCity;
    lbCompanyName.text=detailmodel.vShopName;
    lbMonthlySale.text=[NSString stringWithFormat:@"总销量%@",detailmodel.saleCount];
    // add by songjk
    self.lbExpressFee.text = [NSString stringWithFormat:@"%.02f",[detailmodel.postage floatValue]] ;
    self.lbExpressInfo.text = detailmodel.postageMsg;
    if ([detailmodel.postage integerValue] == 0)
    {
        self.lbExpressTitle.hidden = YES;
        self.mvExpressCoin.hidden = YES;
        self.lbExpressFee.hidden = YES;
        self.lbExpressInfo.text = @"包邮";
        self.lbExpressInfo.frame = CGRectMake(self.lbExpressTitle.frame.origin.x, self.lbExpressInfo.frame.origin.y, self.lbExpressInfo.frame.size.width, self.lbExpressInfo.frame.size.height);
    }
}


-(void)resetViewPrice
{
    
    lbPriceSel.text =[NSString stringWithFormat:@"%.2f",detailmodel.strPrice.floatValue];
    
}

#pragma mark - GYSelShopDelegate

-(void)returnSelShopModel:(SelShopModel *)selShopModel :(NSInteger)index
{
   
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
    GYGoodsDetaiCell * cell =(GYGoodsDetaiCell *)[tbv  cellForRowAtIndexPath:indexPath];
    
    cell.lbTitle2.text=selShopModel.shopName;
    
    strRetShopName = selShopModel.shopName;

    strRetShopId =selShopModel.shopId;
}

#pragma mark - GYSetNumCellDelegate

-(void)retNum:(NSInteger)Num{
    _goodsNum = Num;
    detailmodel.goodsNum = [NSString stringWithFormat:@"%ld",(long)Num];
}


//弹出SKU界面
-(void)showSKUView
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         isShow=YES;
                         [scv addSubview:touchView];
                         
                         if ([GlobalData shareInstance].currentDeviceScreenInch==kDeviceScreenInch_3_5) {
                             vSel.frame = CGRectMake(0, 20, 320, 460);
                         }else{
                             
                             vSel.frame = CGRectMake(0, 568-480, 320, 480);
                         }
                         // add by songjk 系统6以下 因为坐标原点是在statusbar下面 所以起点y要向上拉20
                         if (kSystemVersionLessThan(@"6.9")) {
                             vSel.frame = CGRectMake(vSel.frame.origin.x, vSel.frame.origin.y-20, vSel.frame.size.width, vSel.frame.size.height);
                         }
                         [self.tabBarController.view.window addSubview:vSel];
                         
                         self.navigationController.navigationBarHidden = YES;
                     }
                     completion:NULL];
}

-(void)hideSKUView
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                            isShow=NO;
                         [touchView removeFromSuperview];
                         self.navigationController.navigationBarHidden = NO;
                         vSel.frame = CGRectMake(0, 568, 320, 0);
                         [self.tabBarController.view.window addSubview:vSel];
                     }
                     completion:NULL
     ];
}

-(NSMutableArray *)buildPayoffJson
{
    NSMutableArray *mArrShop = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *mDicShop = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *mArrGoodsList = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *mDicGoodsList = [[NSMutableDictionary alloc] init];
    
    float subTotal = [detailmodel.strPrice floatValue] * [detailmodel.goodsNum floatValue];
    float subPoints = [detailmodel.strPv floatValue] * [detailmodel.goodsNum floatValue];
    
    //－－－－－－－－－－－－－－－－－－－－goodsList－－－－－－－－－－－－－－－－－－－－－－－－－－
    [mDicGoodsList setObject:detailmodel.categoryId forKey:@"categoryId"];
    [mDicGoodsList setObject:detailmodel.goodsID forKey:@"itemId"];
    [mDicGoodsList setObject:detailmodel.title forKey:@"itemName"];
    [mDicGoodsList setObject:detailmodel.strPv forKey:@"point"];
    [mDicGoodsList setObject:detailmodel.strPrice forKey:@"price"];
    [mDicGoodsList setObject:detailmodel.goodsNum forKey:@"quantity"];
    [mDicGoodsList setObject:detailmodel.strSkuId forKey:@"skuId"];
    [mDicGoodsList setObject:strRetParameterVl forKey:@"parameter"];
    [mDicGoodsList setObject:[marrSelectStandard componentsJoinedByString:@","] forKey:@"skus"];
    [mDicGoodsList setObject:[NSString stringWithFormat:@"%.2f",subPoints] forKey:@"subPoints"];
    [mDicGoodsList setObject:[NSString stringWithFormat:@"%.2f",subTotal] forKey:@"subTotal"];
    [mDicGoodsList setObject:detailmodel.vShopId forKey:@"vShopId"];
    // add by songjk ruleid 抵扣券
    [mDicGoodsList setObject:detailmodel.strRuleID forKey:@"ruleId"];
    // add by songjk 申请互生卡
    [mDicGoodsList setObject:detailmodel.isApplyCard forKey:@"isApplyCard"];
    [mArrGoodsList addObject:mDicGoodsList];
    
    [mDicShop setValue:[NSString stringWithFormat:@"%.2f",subTotal] forKey:@"actuallyAmount"];
    [mDicShop setValue:@"2" forKey:@"channelType"];
    [mDicShop setValue:detailmodel.companyResourceNo forKey:@"companyResourceNo"];
    [mDicShop setValue:mArrGoodsList forKey:@"orderDetailList"];
    
    [mDicShop setValue:detailmodel.serviceResourceNo forKey:@"serviceResourceNo"];
    [mDicShop setValue:strRetShopId forKey:@"shopId"];
    [mDicShop setValue:strRetShopName forKey:@"shopName"];
    
    [mDicShop setValue:[NSString stringWithFormat:@"%.2f",subTotal] forKey:@"totalAmount"];
    [mDicShop setValue:[NSString stringWithFormat:@"%.2f",subPoints] forKey:@"totalPoints"];
    [mDicShop setValue:detailmodel.vShopId forKey:@"vShopId"];
    [mDicShop setValue:detailmodel.vShopName forKey:@"vShopName"];
    
    [mArrShop addObject:mDicShop];
    
    return mArrShop;
}


- (IBAction)btnEnterShopAction:(id)sender {
    NSLog(@"enter");
    // 屏蔽 进入新界面
//    GYShopDetailViewController * vcShopDetail = [[GYShopDetailViewController alloc]initWithNibName:@"GYShopDetailViewController" bundle:nil];
//    vcShopDetail.ShopID=detailmodel.defaultShopId ;
//    vcShopDetail.fromEasyBuy=1;
//    [self.navigationController pushViewController:vcShopDetail animated:YES];
    
    
    GYStoreDetailViewController * vc = [[GYStoreDetailViewController alloc] init];
//    vc.currentMp1 = mp1;
    ShopModel * model = [[ShopModel alloc] init];
    model.strVshopId = detailmodel.vShopId;
    vc.shopModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
@end
