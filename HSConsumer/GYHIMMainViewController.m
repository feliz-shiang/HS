//
//  GYHIMMainViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYHIMMainViewController.h"
#import "MenuTabView.h"
#import "TestViewController.h"
#import "GYMsgViewController.h"
#import "GYPopView.h"
#import "GYQRCIOS7ViewController.h"
//个人资料详情
#import "GYPersonDetailInfoViewController.h"
//好友管理
#import "GYFriendManageViewController.h"

//个人资料信息
#import "GYPersonDetailFileViewController.h"
#import "GYAddFriendViewController.h"
#import "IQKeyboardManager.h"

// 修改登录 GYPopViewDelegate
//#import "GYLoginController.h"
//#import "GYHDRemindLoginView.h"
//#import "GYAppDelegate.h"
#import "GYReLogin.h"
@interface GYHIMMainViewController ()<UIScrollViewDelegate, MenuTabViewDelegate>
{
//    GlobalData *data;   //全局单例
    MenuTabView *menu;      //菜单视图
    NSArray *menuTitles;    //菜单标题数组
    NSMutableArray *arrParentViews;    //parentView array
    IBOutlet UIScrollView *_scrollV; //滚动视图，用于装载各vc view
    
    
    GYMsgViewController * vcIMsg;
    GYMsgViewController * vcShopMsg;
    GYMsgViewController * vcGoodsMsg;
    
    
    
    
    GYPopView * pv;
    
    
}

@property (nonatomic, strong) NSMutableArray *arrResult;

@end

@implementation GYHIMMainViewController

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
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    menuTitles = @[kLocalized(@"im_main_title_person_message"),
                   kLocalized(@"im_main_title_shop_message"),
                   kLocalized(@"im_main_title_goods_message")];
    
    CGRect scrFrame = _scrollV.frame;
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
        scrFrame.size.height -= self.tabBarController.tabBar.frame.size.height;
    [_scrollV setFrame:scrFrame];
    
    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    
    _scrollV.delegate = self;
    //    [_scrollV.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    //    [_scrollV setUserInteractionEnabled:YES];
    [_scrollV setContentSize:CGSizeMake(_scrollV.frame.size.width * menuTitles.count, 0)];
    [_scrollV setBackgroundColor:kDefaultVCBackgroundColor];
    
    //添加 VIEWS
    arrParentViews = [NSMutableArray array];
    CGRect vFrame = _scrollV.bounds;
    
    vcIMsg = kLoadVcFromClassStringName(NSStringFromClass([GYMsgViewController class]));
    vcIMsg.msgType = 1;
    vcIMsg.nc = self.navigationController;
    
    
    vcIMsg.view.frame = vFrame;
//    [vc0 didMoveToParentViewController:self];
    [_scrollV addSubview:vcIMsg.view];

    vFrame.origin.x += vFrame.size.width;
    vcShopMsg = kLoadVcFromClassStringName(NSStringFromClass([GYMsgViewController class]));
    vcShopMsg.msgType = 2;
    vcShopMsg.nc = self.navigationController;
    vcShopMsg.view.frame = vFrame;
    [_scrollV addSubview:vcShopMsg.view];

    vFrame.origin.x += vFrame.size.width;
    vcGoodsMsg = kLoadVcFromClassStringName(NSStringFromClass([GYMsgViewController class]));
    vcGoodsMsg.msgType = 3;
    vcGoodsMsg.nc = self.navigationController;
    vcGoodsMsg.view.frame = vFrame;
    [_scrollV addSubview:vcGoodsMsg.view];
    
    
    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    menu.delegate = self;
//    [menu setDefaultItem:1];//设置默认选项
    [self.view addSubview:menu];
    
    
//navigation右按钮
//    UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector(more:)];
    
    UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithImage:kLoadPng(@"msg_more") style:UIBarButtonItemStylePlain target:self action:@selector(more:)];
    
    self.navigationItem.rightBarButtonItem = rb;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [GYReLogin reLogin];
    // 监测登录
//    if (![GlobalData shareInstance].isHdLogined) {
//        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//        GYHDRemindLoginView * vc = [[GYHDRemindLoginView alloc] initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
//        vc.alpha =0;
//        GYAppDelegate * app  = (GYAppDelegate *)[UIApplication sharedApplication].delegate;
//        [app.window addSubview:vc];
//        [UIView animateWithDuration:0.3 animations:^{
//            vc.alpha = 0.5;
//            vc.alpha = 1;
//            vc.frame = frame;
//        } completion:^(BOOL finished) {
//            if (finished) {
//                
//            }
//        }];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![GlobalData shareInstance].isHdLogined)
    {
        [[GYXMPP sharedInstance] Logout];
        if (![GlobalData shareInstance].isEcLogined)
        {
//            [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:self isStay:NO];
        }else
        {
//            [Utils showMessgeWithTitle:nil message:@"连接消息服务器失败." isPopVC:nil];
            DDLogInfo(@"重新连接消息服务器.");
            [[GYXMPP sharedInstance] login:^(IMLoginState state, id error)
             {
                 switch (state)
                 {
                     case kIMLoginStateAuthenticateSucced:
                         [GlobalData shareInstance].isHdLogined = YES;
                         //用户登录通知 im那边的界面刷新
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeMsgCount" object:nil];
                         break;
                     default:
                         [Utils showMessgeWithTitle:@"提示" message:@"连接消息服务器失败" isPopVC:nil];
                         [GlobalData shareInstance].isHdLogined = NO;
                         [[GYXMPP sharedInstance] Logout];
                         break;
                 }
             }];
        }
    }
}

-(void)more:(UIBarButtonItem *)rb
{
    if (pv == nil) {
        //设置弹窗tableView
        NSArray *arrData = @[@"个人资料",@"我的好友",@"添加好友"];//,@"扫一扫"
        NSArray *arrImg = @[@"msg_user_info.png",@"msg_friend.png",@"add_friend.png"];//@"msg_tdc.png"
        
        //设置弹窗tableView 放大Frame
        CGRect bigFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 150, 64, 150, 44*arrData.count - 0.5);
        //设置弹窗tableView 缩少Frame
        CGRect smallFrame = CGRectMake([UIScreen mainScreen].bounds.size.width, 64, 0, 0);
        //设置弹窗背景颜色
        UIColor *bgColor = kCorlorFromRGBA(0, 0, 0, 0.3);
        
        //初始化弹窗并传值
        pv = [[GYPopView alloc] initWithCellType:1 WithArray:arrData WithImgArray:arrImg WithBigFrame:bigFrame WithSmallFrame:smallFrame WithBgColor:bgColor];

              //initWithCellType:1 WithArray:arrData WithBigFrame:bigFrame WithSmallFrame:smallFrame WithBgColor:bgColor];
        pv.delegate = self;
    }
    [self.view.window addSubview:pv];
    pv = nil;

    
}

#pragma mark - GYPopViewDelegate


-(void)pushVCWithIndex:(NSIndexPath *)indexPath
{
//    if (![GlobalData shareInstance].isHdLogined)//听说不要在这里提示登录
//    {
//        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
//        return;
//    }
    switch (indexPath.row) {
        case 0:
        {
            GYPersonDetailFileViewController * vcPerson =[[GYPersonDetailFileViewController alloc]initWithNibName:@"GYPersonDetailFileViewController" bundle:nil];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vcPerson animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 1:
        {
            GYFriendManageViewController * vcFriendManage =[[GYFriendManageViewController alloc]initWithNibName:@"GYFriendManageViewController" bundle:nil];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vcFriendManage animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 2:
        {
            GYAddFriendViewController * vcAddFriend =[[GYAddFriendViewController alloc]initWithNibName:@"GYAddFriendViewController" bundle:nil];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vcAddFriend animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;

        case 3://二维码
        {
            if(kSystemVersionGreaterThanOrEqualTo(@"7.0"))
            {
                GYQRCIOS7ViewController * rt = [[GYQRCIOS7ViewController alloc]init];
                [self presentViewController:rt animated:YES completion:^{
                    
                }];
                
            }
            else
            {
                [self scanBtnAction];
                
            }
            
            
            
            
        }
            break;
            
        default:
            break;
    }
    
}

-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self presentViewController:reader animated:YES completion:^{
        NSLog(@"%f",reader.view.frame.origin.y);
    }];
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        
        
        NSLog(@"%@",result);
        
    }];
}



#pragma mark - pushVC

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    
    CGFloat contentOffsetX = _scrollV.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index ) return;
    
    CGFloat _x = _scrollV.frame.size.width * index;
    [_scrollV scrollRectToVisible:CGRectMake(_x,
                                             _scrollV.frame.origin.y,
                                             _scrollV.frame.size.width,
                                             _scrollV.frame.size.height)
                         animated:NO];
    //设置当前导航条标题
//    [self.navigationItem setTitle:menuTitles[index]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollV)//因为tableview 中的scrollView 也使用同一代理，所以要判断，否则取得x值不是预期的
    {
        CGFloat _x = scrollView.contentOffset.x;//滑动的即时位置x坐标值
        NSInteger index = (NSInteger)(_x / self.view.frame.size.width);//所偶数当前视图
        
        //设置滑动过渡位置
        if (index < menu.selectedIndex)
        {
            if (_x < menu.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width)
            {
                [menu updateMenu:index];
//                [self.navigationItem setTitle:menuTitles[index]];
            }
        }else if (index == menu.selectedIndex)
        {
            if (_x > menu.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width)
            {
                [menu updateMenu:index + 1];
//                [self.navigationItem setTitle:menuTitles[index + 1]];
            }
        }else
        {
            [menu updateMenu:index];
//            [self.navigationItem setTitle:menuTitles[index]];
        }
    }
}

#pragma mark - GYLoginViewDelegate
//- (void)loginDidSuccess:(NSDictionary *)response sender:(id)sender
//{
//    if ([GlobalData shareInstance].isHdLogined) return;
//    
//    [[GYXMPP sharedInstance] login:^(IMLoginState state, id error)
//     {
//         switch (state)
//         {
//             case kIMLoginStateAuthenticateSucced:
//                 [GlobalData shareInstance].isHdLogined = YES;
//                 //用户登录通知 im那边的界面刷新
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeMsgCount" object:nil];
//                 break;
//             default:
//                 [Utils showMessgeWithTitle:@"提示" message:@"登录消息服务器失败" isPopVC:nil];
//                 [GlobalData shareInstance].isHdLogined = NO;
//                 [[GYXMPP sharedInstance] Logout];
////                 [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
//                 DDLogInfo(@"登录消息服务器失败(代码%d):%@", state, error);
//                 
//                 //                 [Utils alertViewOKbuttonWithTitle:@"提示" message:[NSString stringWithFormat:@"登录消息服务器失败(代码%d):%@", state, error]];
//                 break;
//         }
//     }];
//}
@end
