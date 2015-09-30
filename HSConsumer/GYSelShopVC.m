//
//  GYSelShopVC.m
//  HSConsumer
//
//  Created by 00 on 15-2-6.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYSelShopVC.h"
#import "GYSelShopCell.h"
#import "UIView+CustomBorder.h"
#import "MMLocationManager.h"
@interface GYSelShopVC ()<UITableViewDataSource,UITableViewDelegate>
{

    __weak IBOutlet UITableView *tbv;
    NSMutableArray *mArrData;
    
    CGRect tbvFrame;
    
    CLLocationCoordinate2D currentLocation;
        BMKMapPoint mp1;
}
@end

@implementation GYSelShopVC

- (void)viewDidLoad {
    [super viewDidLoad];

    mArrData = [[NSMutableArray alloc] init];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];

    
    tbv.delegate = self;
    tbv.dataSource = self;
    
    CGRect tbvFrameF = tbv.frame;
    UIView * vbackground =[[UIView alloc]initWithFrame:tbvFrameF];
    vbackground.backgroundColor=kDefaultVCBackgroundColor;
    tbv.backgroundView=vbackground;
  
    

    [[MMLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        currentLocation=locationCorrrdinate;
         mp1= BMKMapPointForCoordinate(currentLocation);
        [self  getNetData];
    } withError:^(NSError *error) {
        currentLocation.latitude=22.549225;
        currentLocation.longitude=114.077427;
        mp1= BMKMapPointForCoordinate(currentLocation);
          [self  getNetData];
    }];
    
    [tbv registerNib:[UINib nibWithNibName:@"GYSelShopCell" bundle:nil] forCellReuseIdentifier:@"CELL"];

}

#pragma mark - UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat yStart =13;
    int i=0;
    SelShopModel *model = mArrData[indexPath.row];
    CGFloat addressHeight =[Utils heightForString:[NSString stringWithFormat:@"地址：%@",model.addr] fontSize:14.0 andWidth:207];
    
    CGFloat totalHeight = yStart + addressHeight +21+10;
    NSLog(@"%f=======height",totalHeight);
    return totalHeight>76?totalHeight:76;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
    return mArrData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYSelShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    SelShopModel *model = mArrData[indexPath.row];
  
      CGFloat addressHeight =[Utils heightForString:[NSString stringWithFormat:@"%@",model.addr] fontSize:14.0 andWidth:207];
    
    CGRect addressFrame=cell.lbAdd.frame;
    addressFrame.size.height=addressHeight+5;
    cell.lbAdd.frame=addressFrame;
    
    CGRect telFrame =cell.btnCall.frame;
    telFrame.origin.y=cell.lbAdd.frame.origin.y+addressFrame.size.height;
    cell.btnCall.frame=telFrame;
  

    [cell addTopBorder];
    
    UIFont * font = [UIFont systemFontOfSize:12];
    cell.lbAdd.text = [NSString stringWithFormat:@"%@",model.addr];
//    cell.lbTel.text = [NSString stringWithFormat:@"电话：%@",model.tel];
    [cell.btnCall addTarget:self action:@selector(btnCallAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCall setTitle:model.tel forState:UIControlStateNormal];

    cell.btnCall.tag=indexPath.row;
    cell.lbDistance.text=[NSString stringWithFormat:@"%.1fkm",[model.distance doubleValue]];
    cell.lbDistance.font =  font;
    
    
    CGFloat boder = 10;
    CGSize distanctSize = [Utils sizeForString:cell.lbDistance.text font:font width:150];
    cell.lbDistance.frame = CGRectMake(kScreenWidth - distanctSize.width - boder, cell.lbDistance.frame.origin.y, distanctSize.width, cell.lbDistance.frame.size.height);
    cell.imgvLocationIcon.frame = CGRectMake(cell.lbDistance.frame.origin.x - cell.imgvLocationIcon.frame.size.width-5, cell.imgvLocationIcon.frame.origin.y, cell.imgvLocationIcon.frame.size.width, cell.imgvLocationIcon.frame.size.height);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelShopModel *model = mArrData[indexPath.row];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(returnSelShopModel::)]) {
        [_delegate returnSelShopModel:model:self.selIndex];
    }
    
      if (_delegate && [_delegate respondsToSelector:@selector(returnSelShopModel:selectIndex:tag:WithShopid:)]) {
           [self.delegate returnSelShopModel:model selectIndex:self.selIndex tag:self.tag WithShopid:self.shopid];
    }
    
 
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)btnCallAction:(UIButton *)sender
{
    SelShopModel *model = mArrData[sender.tag];
//   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];     GYSelShopCell * cell =(GYSelShopCell *)[tbv  cellForRowAtIndexPath:indexPath];
   [Utils callPhoneWithPhoneNumber:model.tel showInView:self.view];
}

#pragma mark - getNetData
//网络请求函数，包含网络等待弹窗控件，数据解析回调函数
-(void)getNetData
{
   
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:self.model.vShopId forKey:@"vShopId"];
    [dict setValue:self.model.goodsID forKey:@"itemId"];
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getShopsByItemId",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
            [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            //网络请求错误
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"]) {
               
                //返回正确数据，并进行解析
                
                if ([ResponseDic[@"data"] count]>0) {
                    for (NSDictionary *dic in ResponseDic[@"data"]) {
                        
                        SelShopModel *model = [[SelShopModel alloc] init];
                        model.addr = [NSString stringWithFormat:@"%@",dic[@"addr"]];
                        model.shopId = [NSString stringWithFormat:@"%@",dic[@"shopId"]];
                        model.shopName = [NSString stringWithFormat:@"%@",dic[@"shopName"]];
                        model.tel = [NSString stringWithFormat:@"%@",dic[@"tel"]];
                        model.lat=dic[@"lat"];
                        model.longitude=dic[@"longitude"];
                        
                        CLLocationCoordinate2D shopCoordinate;
                        shopCoordinate.latitude=model.lat.doubleValue;
                        shopCoordinate.longitude=model.longitude.doubleValue;
                        BMKMapPoint mp2= BMKMapPointForCoordinate(shopCoordinate);
                        CLLocationDistance  dis = BMKMetersBetweenMapPoints(mp1 , mp2);
                        model.distance=[NSString stringWithFormat:@"%.2f",dis/1000];
                        [mArrData addObject:model];
                    }
                }else
                {
                    
                  CGRect  Frect  = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                    UIView * background =[[UIView alloc]initWithFrame:Frect];
//                    background.backgroundColor=[UIColor redColor];
                    UILabel * lbTips =[[UILabel alloc]init];
                    lbTips.center=CGPointMake(160, 160);
                    lbTips.textColor=kCellItemTitleColor;
                    lbTips.textAlignment=UITextAlignmentCenter;
                    lbTips.font=[UIFont systemFontOfSize:15.0];
                    lbTips.backgroundColor =[UIColor clearColor];
                    lbTips.bounds=CGRectMake(0, 0, 270, 80);
                    lbTips.text=@"商品在不同营业点销售，请选择单个商品下单!";
                    lbTips.numberOfLines=0;
                    
                    UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                    imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
                    imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                    [background addSubview:imgvNoResult];
                    
                    [background addSubview:lbTips];
              
                    [self.view addSubview:background];

                }
                [self reSetTbv];

                [tbv reloadData];
                
            }else{
                //返回数据不正确
                
            }
        }
    }];
}



-(void)reSetTbv
{
   [tbv removeAllBorder];
//    tbv.scrollEnabled = NO;
//    CGFloat tbvHeight = mArrData.count * 75 + 0.5;
//    if (tbvHeight + 16 > [UIScreen mainScreen].bounds.size.height) {
//        tbvHeight = [UIScreen mainScreen].bounds.size.height - 16.0f;
//        tbv.scrollEnabled = YES;
//    }
//    tbvFrame = CGRectMake(tbv.frame.origin.x, tbv.frame.origin.y, [UIScreen mainScreen].bounds.size.width, tbvHeight);
//    tbv.frame = tbvFrame;
    [tbv addAllBorder];
}



@end
