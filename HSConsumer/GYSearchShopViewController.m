//
//  GYSearchShopViewController.m
//  ZBG
//
//  Created by 00 on 14-12-24.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import "GYSearchShopViewController.h"
#import "UIView+CustomBorder.h"
#import "GYScGdMoreViewController.h"
#import "GYFindShopViewController.h"
#import "SearchGoodModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface GYSearchShopViewController ()

{
    __weak IBOutlet UIScrollView *scv;//scrollView
    
    __weak IBOutlet UIView *vBG1;//上底图
    
    __weak IBOutlet UIView *vBG2;//下底图
    
//按钮
    __weak IBOutlet UIButton *btn1;//美食
    __weak IBOutlet UIButton *btn2;//休闲娱乐
    __weak IBOutlet UIButton *btn3;//酒店
    __weak IBOutlet UIButton *btn4;//电影
    __weak IBOutlet UIButton *btn5;//生活服务
    __weak IBOutlet UIButton *btn6;//丽人
    __weak IBOutlet UIButton *btn7;//旅游
    __weak IBOutlet UIButton *btn8;//更多
    
    
    __weak IBOutlet UIButton *btn9;//人气最高
    __weak IBOutlet UILabel *lbTitle1;
    __weak IBOutlet UILabel *lbText1;
    
    __weak IBOutlet UIButton *btn10;//积分排行
    __weak IBOutlet UILabel *lbTitle2;
    __weak IBOutlet UILabel *lbText2;
    
    __weak IBOutlet UIButton *btn11;//好评价
    __weak IBOutlet UILabel *lbTitle3;
    __weak IBOutlet UILabel *lbText3;
    
    __weak IBOutlet UIButton *btn12;//综合
    __weak IBOutlet UILabel *lbTitle4;
    __weak IBOutlet UILabel *lbText4;
    
//分隔线
    __weak IBOutlet UILabel *lbLine1;
    __weak IBOutlet UILabel *lbLine2;
    __weak IBOutlet UILabel *lbLine3;
    
    
    NSArray *arrBtn;//按钮数组

    NSMutableArray *mArrProperties;//常用按钮数组
    NSMutableArray *mArrCategories;//类目按钮数组
    CGFloat newViewW;
    UIView *    leftBgview;
    UIView *rightview;
    NSMutableDictionary *keytag;
}

@end

@implementation GYSearchShopViewController


//点击事件
- (IBAction)btnClick:(UIButton *)sender {
    NSLog(@"%d",sender.tag);
   NSString * strSortType;
    SearchGoodModel *model = [[SearchGoodModel alloc] init];
    if (sender.tag -100 < mArrCategories.count) {
        model = mArrCategories[sender.tag - 100];
        strSortType=@"1";
    }else
    {
//        model = mArrCategories[sender.tag - 100 - mArrCategories.count - 1];
    }
    
    if (sender.tag == 107) {
        GYScGdMoreViewController *vc =[[GYScGdMoreViewController alloc] init];
        vc.title = @"更多";
        UIViewController *topVc = [self.nc topViewController];
        [topVc setHidesBottomBarWhenPushed:YES];
        [self.nc pushViewController:vc animated:YES];
        [topVc setHidesBottomBarWhenPushed:NO];
   
    }else{
        GYFindShopViewController *vc =[[GYFindShopViewController alloc] init];
        vc.title = model.name;
   
        NSUserDefaults * userDefault =[NSUserDefaults standardUserDefaults];
        [userDefault setObject:model.name forKey:@"surroundingTitle"];
        [userDefault synchronize];
        vc.modelID = model.uid;
        vc.FromBottomType=NO;
        vc.strSortType=strSortType;
        vc.modelTitle = model.name;
        
        UIViewController *topVc = [self.nc topViewController];
        [topVc setHidesBottomBarWhenPushed:YES];
        [self.nc pushViewController:vc animated:YES];
        [topVc setHidesBottomBarWhenPushed:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    keytag =[NSMutableDictionary dictionary];
    newViewW=kScreenWidth/2;
    CGRect frame = vBG2.frame;
    frame.size.height=140*2;
    vBG2.frame=frame;
    mArrProperties = [[NSMutableArray alloc] init];
    mArrCategories = [[NSMutableArray alloc] init];
    [self getNetData];
    [lbLine1 addTopBorder];
    [lbLine2 addRightBorder];
    [lbLine3 addTopBorder];
    [vBG1 addAllBorder];
    [vBG2 addAllBorder];
    

//按钮
    arrBtn = [NSArray arrayWithObjects:
              btn1,
              btn2,
              btn3,
              btn4,
              btn5,
              btn6,
              btn7,
              btn8,
              btn9,////
              btn10,////这些都是没用的了
              btn11,////
              btn12,////
              nil];
    
//设置标题&图片
    for (int i = 0 ; i < arrBtn.count; i++) {
        UIButton *btn = arrBtn[i];
        if( i<8 ){
            btn.titleEdgeInsets = UIEdgeInsetsMake(0,-40,-70, -40);
        }
        btn.tag = 100+i;
        if (i == 7) {
            [btn setTitle:@"更多" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"sp_more.png"] forState:UIControlStateNormal];
        }
    }
    scv.contentSize = CGSizeMake(0, CGRectGetMaxY(vBG2.frame) );
}
-(void)removSubviews:(UIView *)subView{
    if (subView.subviews.count>0) {
        for (UIView *subViews in subView.subviews)
        {
    [self removSubviews:subViews];
        }
    }  else
    {
        NSLog(@"%i",subView.subviews.count);
        [subView removeFromSuperview];
    }
}
/////左边的大View
-(UIView *)leftBgview:(SearchGoodModel*)model andFrame:(CGRect )frame andcolor:(UIColor *)color andI:(int)i{
    CGFloat X = frame.origin.x;
    CGFloat Y = frame.origin.y;
    CGFloat W = frame.size.width;
    CGFloat H = frame.size.height;
    leftBgview = [[UIView alloc]initWithFrame:CGRectMake(X, Y, W, H)];
    
    UIButton *btnbg=[UIButton buttonWithType:UIButtonTypeCustom];
    btnbg.backgroundColor = [UIColor clearColor];
    [btnbg setTintColor:[UIColor clearColor]];
    [btnbg addTarget:self action:@selector(newClictbtn:) forControlEvents:UIControlEventTouchUpInside];
    btnbg.tag=model.shopId.longLongValue;
    btnbg.frame =CGRectMake(0, 0, W, H);
    btnbg.titleLabel.text = model.property;
    
    UILabel * topLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 13, W, 20)];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font=[UIFont systemFontOfSize:16];
    topLabel.text=model.property;
    topLabel.textColor=color;
    UILabel *labeldeatil=[[UILabel alloc]initWithFrame:CGRectMake(0, 38, W, 20)];
    labeldeatil.font = [UIFont systemFontOfSize:12];
    labeldeatil.textColor = [UIColor colorWithRed:169.0/255.0f green:172.0/255.0f blue:172/255.0 alpha:1.f];
    labeldeatil.textAlignment=NSTextAlignmentCenter;
    labeldeatil.text = model.name;
    
    CGFloat imgW=55;
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((W-imgW)/2, 66, imgW, imgW)];
    
    NSURL *url=[[NSURL alloc]initWithString:kSaftToNSString(model.picAddr)];
    UIImage *imge=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]];
    imageView.image =imge;
    
    UILabel *baseline = [[UILabel alloc]initWithFrame:CGRectMake(0, H-1, W*2, 0.5f )];
    baseline.backgroundColor = kDefaultViewBorderColor;
    UILabel *rightline = [[UILabel alloc]initWithFrame:CGRectMake(W,5, 0.5f, H-10 )];
    rightline.backgroundColor = kDefaultViewBorderColor;
    
    [leftBgview addSubview:topLabel];
    [leftBgview addSubview:labeldeatil];
    [leftBgview addSubview:imageView];
  
    [leftBgview addSubview:baseline];
    [leftBgview addSubview:rightline];
    [leftBgview addSubview:btnbg];
    for (int i =0 ; i<model.arrModel.count; i++) {
        NSDictionary *dic = model.arrModel[i];
        SearchGoodModel *newmodel =[[SearchGoodModel alloc]init];
        newmodel.shopId=dic[@"id"];
        newmodel.property = dic[@"property"];
        newmodel.picAddr=dic[@"picAddr"];
        newmodel.desc=dic[@"desc"];
        NSString * strKey = [NSString stringWithFormat:@"%zi",[newmodel.shopId longLongValue]] ;
        [keytag setObject:newmodel.shopId forKey:strKey];
        [vBG2 addSubview:[self rightview:newmodel andFrame:CGRectMake(W, Y+(H/2)*i, W, H/2)]];
    }
    return leftBgview;
}
/////右边的小view
-(UIView *)rightview:(SearchGoodModel*)model1 andFrame:(CGRect )frame{
    CGFloat X=frame.origin.x;
    CGFloat Y = frame.origin.y;
    CGFloat W = frame.size.width;
    CGFloat H = frame.size.height;
    rightview=[[UIView alloc]initWithFrame:CGRectMake(X, Y, W, H)];
    
    UIButton *btnbg=[UIButton buttonWithType:UIButtonTypeCustom];
    btnbg.backgroundColor = [UIColor clearColor];
    [btnbg addTarget:self action:@selector(newClictbtn:) forControlEvents:UIControlEventTouchUpInside];
    btnbg.tag =[NSString stringWithFormat:@"%@", model1.shopId].longLongValue;
    btnbg.frame =CGRectMake(0, 0, W, H);
    btnbg.titleLabel.text=model1.property;
 
    UILabel *leftlabel1=[[UILabel alloc]initWithFrame:CGRectMake(10, 14 , W/2+5, 20)];
    leftlabel1.textAlignment= NSTextAlignmentLeft;
    leftlabel1.font= [UIFont systemFontOfSize:15];
    leftlabel1.text=model1.property;
    leftlabel1.textColor =kCellItemTextColor;
    [rightview addSubview:leftlabel1];
        
    UILabel *leftlabeldeatil1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 14+20, W/2+10, 20)];
    leftlabeldeatil1.font=[UIFont systemFontOfSize:12];
    leftlabeldeatil1.textAlignment=NSTextAlignmentLeft;
    leftlabeldeatil1.textColor = [UIColor colorWithRed:191.0/255.0f green:194.0/255.0f blue:194.0/255.0f alpha:1.0f];
    leftlabeldeatil1.text =model1.desc;
    [rightview addSubview:leftlabeldeatil1];
    ////右边图片http://192.168.229.31:9099/v1/tfs/T1TyVTBXbT1R4cSCrK.png
//     NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.229.31:9099/v1/tfs/T1TyVTBXbT1R4cSCrK.png"]];
    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model1.picAddr]];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url1]];
    
    UIImageView *imageview1=[[UIImageView alloc]initWithFrame:CGRectMake((X-image.size.width/3.5)/2+35, (H-image.size.height/3.5)/2, image.size.width/3.5, image.size.height/3.5)];
    imageview1.image=image;
    
    /////底部添加一个根线
    UILabel *baseline = [[UILabel alloc]initWithFrame:CGRectMake(10, H-1,W-20, 0.5f )];
    baseline.backgroundColor = kDefaultViewBorderColor;
    [rightview addSubview:imageview1];
    [rightview addSubview:btnbg];
    [rightview addSubview:baseline];
    return rightview;
}


-(void)newClictbtn:(UIButton *)sender
{
    NSString * strSortType;
    GYFindShopViewController *vc =[[GYFindShopViewController alloc] init];
    vc.title = sender.titleLabel.text;
    vc.modelID = keytag[[NSString stringWithFormat:@"%zi",sender.tag]];

    vc.FromBottomType=YES;
    vc.modelTitle = sender.titleLabel.text;
    // modify by songjk 统一距离最近 1
    strSortType = @"1";
//    if ([vc.modelID isEqualToString:@"0901"]) {
//         strSortType= @"4";
//    } else if([vc.modelID isEqualToString:@"0902"]) {
//        strSortType= @"5";
//    }else if([vc.modelID isEqualToString:@"0901"]) {
//        strSortType= @"1";
//    }
    
    vc.strSortType=strSortType;
    NSUserDefaults * userDefault =[NSUserDefaults standardUserDefaults];
    [userDefault setObject:sender.titleLabel.text forKey:@"surroundingTitle"];
    [userDefault synchronize];
    UIViewController *topVc = [self.nc topViewController];
    [topVc setHidesBottomBarWhenPushed:YES];
    [self.nc pushViewController:vc animated:YES];
    [topVc setHidesBottomBarWhenPushed:NO];
    
}
//滑动
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [vBG2 removeFromSuperview];
//    [self getNetData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated ];
    [vBG2 removeFromSuperview];
}

#pragma mark - getNetData
//网络请求函数，包含网络等待弹窗控件，数据解析回调函数
-(void)getNetData
{
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];
    //测试get
    NSString * urlString =[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getMainInterface"];
    [Network  HttpGetForRequetURL:urlString parameters:nil requetResult:^(NSData *jsonData, NSError *error){
        [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            self.view.hidden = YES;
            NSLog(@"错误");
            NSLog(@"%@",error);
            [Utils hideHudViewWithSuperView:self.view];
        }else{ 
            self.view.hidden = NO;
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString *retCode = ResponseDic[@"retCode"];
            if ([retCode integerValue] == 200) {
                mArrProperties = [[NSMutableArray alloc] init];
                mArrCategories = [[NSMutableArray alloc] init];
//                for (NSDictionary *dic in ResponseDic[@"data"][@"properties"]) {
//                    
//                    SearchGoodModel *modelProperties = [[SearchGoodModel alloc] init];
//                    modelProperties.name = dic[@"desc"];
//                    modelProperties.uid = dic[@"id"];
//                    modelProperties.picAddr = dic[@"picAddr"];
//                    modelProperties.property = dic[@"property"];
//                    modelProperties.arrModel = dic[@"porperty"];
//                    NSLog( @"%@",modelProperties.arrModel);
//                    [mArrProperties addObject:modelProperties];
//                }
//             //////去除重复加载页面
                [self removSubviews:vBG2];
                
                NSArray *arr=ResponseDic[@"data"][@"properties"];
                for (int i= 0 ; i<2; i++) {
                    NSDictionary *dic = arr[i];
                    SearchGoodModel *model=[[SearchGoodModel alloc]init];
                    model.shopId =dic[@"id"];
                    model.picAddr = dic[@"picAddr"];
                    model.name = dic[@"desc"];
                    model.property = dic[@"property"];
                    model.arrModel = dic[@"paramMap"];
                    [mArrProperties addObject:model];
                    NSString * strKey = [NSString stringWithFormat:@"%zi",[ model.shopId longLongValue]] ;
                    [keytag setObject: model.shopId forKey:strKey];
                    
                }
                for (NSDictionary *dic1 in ResponseDic[@"data"][@"categories"]) {
                    SearchGoodModel *modelCategories = [[SearchGoodModel alloc] init];
                    modelCategories.name = dic1[@"categoryName"];
                    modelCategories.uid = dic1[@"id"];
                    modelCategories.picAddr = dic1[@"picAddr"];
                    [mArrCategories addObject:modelCategories];
                    NSLog(@"%@",modelCategories.uid);
                }
                //网络请求回调后弹窗
                [self reloadBtn];
                [scv addSubview:vBG2];
            }
            [Utils hideHudViewWithSuperView:self.view];
        }
    }];
}


-(void)reloadBtn
{
    for (UIButton *btn in arrBtn) {
        if (btn == arrBtn[7]) {
            btn.userInteractionEnabled = YES;
        }else{
            btn.userInteractionEnabled = NO;
        }
    }
    for (int i=0; i<mArrProperties.count; i++) {
        SearchGoodModel *model = mArrProperties[i];
        UIColor *color=[[UIColor alloc]init];
        if (i==0) {
           color= [UIColor colorWithRed:87.0/255.0f green:181.0/255.0f blue:225.0/255.0f alpha:1.f];
        }
        else{
            color =[UIColor redColor];
        }
        [vBG2 addSubview:[self leftBgview:model andFrame:CGRectMake(0, 140*i, newViewW, 140) andcolor: color andI:i] ];
    }
    
    for (int i = 0 ; i < mArrCategories.count; i++) {
        SearchGoodModel *modle = mArrCategories[i];
        
        UIButton *btn = arrBtn[i];
        btn.userInteractionEnabled = YES;
        [btn setTitle:modle.name forState:UIControlStateNormal];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:modle.picAddr] forState:UIControlStateNormal placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0,-72,-70, -70);
        
    }

//    for (int i = 0 ; i < mArrProperties.count; i++) {
//        SearchGoodModel *modle = mArrProperties[i];
//        UIButton *btn = arrBtn[8 + i];
//        btn.userInteractionEnabled = YES;
//        switch (i) {
//            case 0:
//            {
//                lbTitle1.text = modle.property;
//           
//                lbText1.text = modle.name;
//                [btn9 sd_setImageWithURL:[NSURL URLWithString:modle.picAddr] forState:UIControlStateNormal placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
//            }
//                break;
//            case 1:
//            {
//                
//                lbTitle2.text = modle.property;
//                lbText2.text = modle.name;
//                [btn10 sd_setImageWithURL:[NSURL URLWithString:modle.picAddr] forState:UIControlStateNormal placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
//            }
//                break;
//            case 2:
//            {
//                
//                lbTitle3.text = modle.property;
//                lbText3.text = modle.name;
//                [btn11 sd_setImageWithURL:[NSURL URLWithString:modle.picAddr] forState:UIControlStateNormal placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
//            }
//                break;
//            case 3:
//            {
//                
//                lbTitle4.text = modle.property;
//                lbText4.text = modle.name;
//                [btn12 sd_setImageWithURL:[NSURL URLWithString:modle.picAddr] forState:UIControlStateNormal placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }
}

@end
