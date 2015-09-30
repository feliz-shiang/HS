//
//  GYMakeEvaluationViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYMakeEvaluationViewController.h"
#import "UIView+CustomBorder.h"
#import "GlobalData.h"
#import "UIImageView+WebCache.h"
@interface GYMakeEvaluationViewController ()

@end

@implementation GYMakeEvaluationViewController
{
    
    __weak IBOutlet UILabel *lbTextViewPlaceHolder;
    
    __weak IBOutlet UIScrollView *scrBackgroundView;//背景滚动试图
    
    __weak IBOutlet UIView *vGoodInfo;//店铺的背景view
    
    __weak IBOutlet UIImageView *imgvGoodPicture;//商品的图片
    
    __weak IBOutlet UILabel *lbSkuInfo;//lb 商品属性
    
    __weak IBOutlet UILabel *lbGoodName;//lb 商品名称
    
    __weak IBOutlet UIView *vEvalutationGoodBackground;//评价商品的背景view
    
    __weak IBOutlet UILabel *lbEvalutationGood;//评价商品LB
    
    __weak IBOutlet UIButton *btnEvalutaionStar1;//评价商品的星星
    
    __weak IBOutlet UIButton *btnEvalutationStar2;//评价商品的星星
    
    __weak IBOutlet UIButton *btnEvalutationStar3;//评价商品的星星
    
    __weak IBOutlet UIButton *btnEvalutationStar4;//评价商品的星星
    
    __weak IBOutlet UIButton *btnEvalutationStar5;//评价商品的星星
    
    __weak IBOutlet UITextView *tvInputText;//输入评价TV
    
    __weak IBOutlet UIView *vShopBackground;//给店铺评分背景view
    
    __weak IBOutlet UILabel *lbMakeEvalutaionForShop;//给店铺评分LB
    
    __weak IBOutlet UILabel *lbServiceAttitude;//lb 服务态度
    
    __weak IBOutlet UILabel *lbSendSpeed;//LB 发货速度
    
    __weak IBOutlet UILabel *lbDescribeRightService;//lb 物流服务
    
    __weak IBOutlet UIButton *btnServiceAttitudeStar1;//服务态度星星
    
    __weak IBOutlet UIButton *btnServiceAttitudeStar2;//服务态度星星
    
    __weak IBOutlet UIButton *btnServiceAttitudeStar3;//服务态度星星
    
    __weak IBOutlet UIButton *btnServiceAttitudeStar4;//服务态度星星
    
    __weak IBOutlet UIButton *btnServiceAttitudeStar5;//服务态度星星
    
    __weak IBOutlet UIButton *btnSendSpeedStar1;//发货速度星星
    
    __weak IBOutlet UIButton *btnSendSpeedStar2;//发货速度星星
    
    __weak IBOutlet UIButton *btnSendSpeedStar3;//发货速度星星
    
    __weak IBOutlet UIButton *btnSendSpeedStar4;//发货速度星星
    
    __weak IBOutlet UIButton *btnSendSpeedStar5;//发货速度星星
    
    __weak IBOutlet UIButton *btnSpentTimeServiceStar1;//物流服务星星
    
    __weak IBOutlet UIButton *btnSpentTimeServiceStar2;//物流服务星星
    
    __weak IBOutlet UIButton *btnSpentTimeServiceStar3;//物流服务星星
    
    __weak IBOutlet UIButton *btnSpentTimeServiceStar4;//物流服务星星
    
    __weak IBOutlet UIButton *btnSpentTimeServiceStar5;//物流服务星星
    
    __weak IBOutlet UIButton *btnSubmit;//btn 提交
    
    int  serverScore;
    int  sepeedScroe;
    int  describeScroe;
    int  goodEvaluateScore;
    
    
    UIButton * btnTemp;
}

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
    self.title=kLocalized(@"make_evaluation");
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    serverScore=5;
    sepeedScroe=5;
    describeScroe=5;
    goodEvaluateScore=5;
    
    
    // Do any additional setup after loading the view from its nib.
    [self modifyName];
    [self textColor];
    [self addBackgroundImageForBtn];
    [self setBorderWithView:tvInputText WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    
    [vGoodInfo addAllBorder];
    // add by songjk默认设置为五星
    [self setAllStars];
}
/**默认设置为五星*/
-(void)setAllStars
{
    [self btnEvaluationClicked:btnEvalutationStar5];
    [self btnEvaluationClicked:btnServiceAttitudeStar5];
    [self btnEvaluationClicked:btnSendSpeedStar5];
    [self btnEvaluationClicked:btnSpentTimeServiceStar5];
}
-(void)loadDataFromNetwork
{
    if ([Utils isBlankString:_strComment]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入评论信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }else if (serverScore==0)
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入服务态度！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    
    }else if (sepeedScroe==0)
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入发货速度！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }else if (describeScroe==0)
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入描述信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }else if (goodEvaluateScore==0)
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入好评！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }

    NSMutableDictionary * GoodDict =[NSMutableDictionary dictionary];
    [GoodDict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [GoodDict setValue:self.model.serviceResourceNo forKey:@"serviceResourceId"];
    [GoodDict setValue:self.model.orderDetailId forKey:@"orderDetailId"];
    [GoodDict setValue:self.model.vShopIdString forKey:@"virtualShopId"];
    [GoodDict setValue:self.model.categoryId forKey:@"categoryId"];
    [GoodDict setValue:self.model.goodIdString forKey:@"itemId"];
    [GoodDict setValue:self.model.titleString forKey:@"itemName"];
    [GoodDict setValue:self.model.skuString forKey:@"sku"];
    [GoodDict setValue:self.model.price forKey:@"price"];
    [GoodDict setValue:_strComment forKey:@"content"];
    [GoodDict setValue:@(goodEvaluateScore) forKey:@"score"];
    [GoodDict setValue:self.model.orderId forKey:@"orderId"];
    
    NSString * strPicPath =self.model.urlString;
    strPicPath=[strPicPath lastPathComponent];
    [GoodDict setValue:strPicPath forKey:@"pic"];
    
    NSMutableDictionary * shopDict =[NSMutableDictionary dictionary];
    [shopDict setValue:self.model.orderId forKey:@"orderId"];
    [shopDict setValue:self.model.vShopIdString forKey:@"virtualShopId"];
    [shopDict setValue:self.model.shopId forKey:@"shopId"];
    [shopDict setValue:@(serverScore) forKey:@"serverScore"];
    [shopDict setValue:@(describeScroe)  forKey:@"conformScore"];
    [shopDict setValue:@(sepeedScroe) forKey:@"deliveryScore"];
    
    NSArray * arr =  [NSArray arrayWithObject:GoodDict];
    
    NSData *cartListData = [NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:NULL];
    NSString *cartListString = [[NSString alloc] initWithData:cartListData encoding:NSUTF8StringEncoding];
    cartListString = [self encodeToPercentEscapeString:cartListString];
  
    NSData *shopListData = [NSJSONSerialization dataWithJSONObject:shopDict options:kNilOptions error:NULL];
    NSString *shopListString = [[NSString alloc] initWithData:shopListData encoding:NSUTF8StringEncoding];

    [Utils showMBProgressHud:self.view SuperView:self.view Msg:@"提交..."];
    NSMutableDictionary * dic1 =[NSMutableDictionary dictionary];
    [dic1 setValue:cartListString forKey:@"itemCommentJson"];
    [dic1 setValue:shopListString forKey:@"shopCommentJson"];
    [dic1 setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].ecDomain stringByAppendingString:@"/easybuy/getPublishEvaluation"] parameters:dic1 requetResult:^(NSData *jsonData, NSError *error){
        [Utils hideHudViewWithSuperView:self.view];
        if (!error) {
            NSDictionary * resonpseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error) {
             
                NSString * retCode =[NSString stringWithFormat:@"%@",resonpseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil userInfo:nil];
                    
                    [UIAlertView showWithTitle:nil message:@"恭喜你，评价成功！" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        self.refreshListBlock(self.model);
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                    
                }else if ([retCode isEqualToString:@"206"])
                {
                
                 [Utils showMessgeWithTitle:nil message:@"含有敏感词汇，请重新输入！" isPopVC:nil];
                
                }
                else
                {
                    
                 [Utils showMessgeWithTitle:nil message:@"提交失败！" isPopVC:nil];
               
                }
                
            }
            
        }
        
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

-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
}


-(void)addBackgroundImageForBtn
{
    [self setButtonInfo:btnEvalutaionStar1 buttonTag:100];
    [self setButtonInfo:btnEvalutationStar2 buttonTag:101];
    [self setButtonInfo:btnEvalutationStar3 buttonTag:102];
    [self setButtonInfo:btnEvalutationStar4 buttonTag:103];
    [self setButtonInfo:btnEvalutationStar5 buttonTag:104];
    [self setButtonInfo:btnServiceAttitudeStar1 buttonTag:200];
    [self setButtonInfo:btnServiceAttitudeStar2 buttonTag:201];
    [self setButtonInfo:btnServiceAttitudeStar3 buttonTag:202];
    [self setButtonInfo:btnServiceAttitudeStar4 buttonTag:203];
    [self setButtonInfo:btnServiceAttitudeStar5 buttonTag:204];
    [self setButtonInfo:btnSendSpeedStar1 buttonTag:300];
    [self setButtonInfo:btnSendSpeedStar2 buttonTag:301];
    [self setButtonInfo:btnSendSpeedStar3 buttonTag:302];
    [self setButtonInfo:btnSendSpeedStar4 buttonTag:303];
    [self setButtonInfo:btnSendSpeedStar5 buttonTag:304];
    [self setButtonInfo:btnSpentTimeServiceStar1 buttonTag:400];
    [self setButtonInfo:btnSpentTimeServiceStar2 buttonTag:401];
    [self setButtonInfo:btnSpentTimeServiceStar3 buttonTag:402];
    [self setButtonInfo:btnSpentTimeServiceStar4 buttonTag:403];
    [self setButtonInfo:btnSpentTimeServiceStar5 buttonTag:404];
    
    
}


-(void)setButtonInfo:(UIButton *)sender buttonTag:(int)tag
{
    [sender setBackgroundImage:[UIImage imageNamed:@"ep_appraise_star_gray.png"] forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:@"ep_appraise_star_yellow.png"] forState:UIControlStateSelected];
    sender.tag=tag;
    [sender addTarget:self action:@selector(btnEvaluationClicked:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)btnEvaluationClicked:(UIButton *)sender
{
    
    int tag=sender.tag;
  
    if (100<=tag&&tag<200) {
        goodEvaluateScore=sender.tag-100+1;
        for (UIButton * v in vEvalutationGoodBackground.subviews) {
            
            if ([v isKindOfClass:[UIButton class]]) {
                if (100<=v.tag&&v.tag<=sender.tag) {
                    v.selected=YES;
                }else{
                    v.selected=NO;
                }
                
                
            }
        }
    }else if
        (tag>=300&&tag<400) {
            sepeedScroe=sender.tag-100+1;
            for (UIButton * v in vShopBackground.subviews) {
                
                if ([v isKindOfClass:[UIButton class]]) {
                    if (300<=v.tag&&v.tag<=sender.tag) {
                        v.selected=YES;
                    }else{
                        if (v.tag>=sender.tag&&v.tag<400) {
                            v.selected=NO;
                        }
                        
                    }
                    
                    
                }
            }
        }
    else if (tag>=200&&tag<300){
        serverScore=sender.tag-100+1;
        for (UIButton * v in vShopBackground.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                if (200<=v.tag&&v.tag<=sender.tag) {
                    v.selected=YES;
                }else{
                    if (v.tag>=sender.tag&&v.tag<300) {
                        v.selected=NO;
                    }
                }
            }
        }
        
    }
    else if (tag>=400&&tag<500) {
        describeScroe=sender.tag-100+1;
        for (UIButton * v in vShopBackground.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                if (400<=v.tag&&v.tag<=sender.tag) {
                    v.selected=YES;
                }else{
                    if (v.tag>=sender.tag&&v.tag<500) {
                        v.selected=NO;
                    }
                    
                }
                
            }
        }
    }
    
    
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    scrBackgroundView.contentSize=CGSizeMake(320, 568);
    
}


-(void)modifyName
{
    lbTextViewPlaceHolder.text=kLocalized(@"ep_leave_word_for_others");
    lbMakeEvalutaionForShop.text=kLocalized(@"ep_evalutation_for_shop");
    lbGoodName.text=self.model.titleString;
    lbSkuInfo.text=self.model.skuString;
    [imgvGoodPicture sd_setImageWithURL:[NSURL URLWithString:self.model.urlString] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
    lbSendSpeed.text=kLocalized(@"ep_send_speed");
    lbEvalutationGood.text=kLocalized(@"ep_evalutation_good");
    lbDescribeRightService.text=kLocalized(@"ep_describe_right_service");
    lbServiceAttitude.text=kLocalized(@"ep_service_attitude");
    [btnSubmit setTitle:kLocalized(@"submit") forState:UIControlStateNormal];

    [self btnEvaluationClicked:btnEvalutationStar5];
    [self btnEvaluationClicked:btnSendSpeedStar5];
    [self btnEvaluationClicked:btnServiceAttitudeStar5];
    [self btnEvaluationClicked:btnSpentTimeServiceStar5];
    
    
}


-(void)textColor
{
    lbTextViewPlaceHolder.textColor=kCellItemTextColor;
    lbSkuInfo.textColor=kCellItemTextColor;
    lbGoodName.textColor=kCellItemTitleColor;
    lbEvalutationGood.textColor=kCellItemTitleColor;
    lbMakeEvalutaionForShop.textColor=kCellItemTitleColor;
    lbServiceAttitude.textColor=kCellItemTitleColor;
    lbDescribeRightService.textColor=kCellItemTitleColor;
    lbSendSpeed.textColor=kCellItemTitleColor;
    vShopBackground.backgroundColor=[UIColor whiteColor];
    vEvalutationGoodBackground.backgroundColor=[UIColor whiteColor];
    [Utils setBorderWithView:vShopBackground WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [Utils setBorderWithView:vEvalutationGoodBackground WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"alert_btn_confirm_bg.png"] forState:UIControlStateNormal];
}


#pragma mark textviewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    lbTextViewPlaceHolder.text=@"";
    [lbTextViewPlaceHolder removeFromSuperview];
    
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    _strComment=textView.text;
    
    
}


- (IBAction)btnSubmit:(id)sender {
    
    [self loadDataFromNetwork];
    
}



@end
