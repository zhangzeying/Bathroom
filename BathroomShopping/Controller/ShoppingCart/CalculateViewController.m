//
//  CalculateViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/16/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "CalculateViewController.h"
#import "OrderService.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
@interface CalculateViewController()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property(nonatomic,strong)NSArray *dataArr;
/** <##> */
@property(nonatomic,strong)OrderService *service;

@end

@implementation CalculateViewController

- (OrderService *)service {
    
    if (_service == nil) {
        
        _service = [[OrderService alloc]init];
    }
    
    return _service;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"商品支付";
    self.dataArr = @[@{@"image":@"alipay_icon",@"name":@"支付宝支付",@"subtitle":@"(推荐安装支付宝用户使用)"},@{@"image":@"wechat_icon",@"name":@"微信支付",@"subtitle":@"(推荐安装微信用户使用)"}];
    [self setupTableView];
}

- (void)setupTableView {

    UITableView *table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [UIView new];
    table.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    table.backgroundColor = CustomColor(240, 243, 246);
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
    cell.textLabel.text = dict[@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = dict[@"subtitle"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof (self)weakSelf = self;
    if (indexPath.row == 0) {//支付宝支付
        
        if (self.isOneMoneyLottery) {//如果是一元抢购抽奖
            
            NSDictionary *params = @{@"amount":@"1",
                                     @"payType":@"alipay",
                                     @"token":[[CommUtils sharedInstance] fetchToken]
                                     };
            [self.service oneMoneyOrder:params completion:^(NSDictionary *dict) {
                
                [weakSelf pay:dict payType:@"alipay"];
            }];
            
        }else {
            
            [self.service order:self.params url:kAPIAlipay completion:^(NSDictionary *dict) {
                
                [weakSelf pay:dict payType:@"alipay"];
            }];
        }
        
        
    }else {//微信支付
        
        
        if (self.isOneMoneyLottery) {//如果是一元抢购抽奖
            
            NSDictionary *params = @{@"amount":@"1",
                                     @"payType":@"weixin",
                                     @"token":[[CommUtils sharedInstance] fetchToken]
                                     };
            [self.service oneMoneyOrder:params completion:^(NSDictionary *dict) {
                
                [weakSelf pay:dict payType:@"weixin"];
            }];
            
        }else {
            
            [self.service order:self.params url:kAPIWXPay completion:^(NSDictionary *dict) {
                
                [weakSelf pay:dict payType:@"weixin"];
            }];
        }
    }
}

/**
 * 调起支付
 */
- (void)pay:(NSDictionary *)dict payType:(NSString *)payType {

    if ([payType isEqualToString:@"alipay"]) {//支付宝支付
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callBackAlipay:) name:@"payAlipayCallBack" object:nil];
        NSString *orderSpec = [dict objectForKey:@"reqStr"];
        [[AlipaySDK defaultService] payOrder:orderSpec fromScheme:@"bathroomalisdk" callback:^(NSDictionary *resultDic) {
            
            NSInteger resultCode = [[resultDic objectForKey:@"resultStatus"] integerValue];
            switch (resultCode) {
                    //支付成功
                case 9000:
                    
                    break;
                    
                    //支付失败
                case 4000:
                    break;
                    //支付正在处理中
                case 8000:
                    break;
                    
                default:
                    break;
            }
        }];
        
    }else {//微信支付
    
        //如果用户没有安装微信
        if (![WXApi isWXAppInstalled]) {
            
            [SVProgressHUD showErrorWithStatus:@"微信版本过低或者没有安装，需要升级或安装微信才能使用"];
            return;
        }
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callBackWXpay:) name:@"payWXCallBack" object:nil];
        PayReq *req = [[PayReq alloc] init];
        req.openID = [dict objectForKey:@"appid"];
        req.partnerId = [dict objectForKey:@"partnerid"];
        req.prepayId = [dict objectForKey:@"prepayid"];
        req.nonceStr = [dict objectForKey:@"noncestr"];
        req.timeStamp = (UInt32)[[dict objectForKey:@"timestamp"] integerValue];
        req.package = [dict objectForKey:@"package"];;
        req.sign = [dict objectForKey:@"sign"];
        NSLog(@"%@",req);
        [WXApi sendReq:req];
    }
    
}

/**
 * 支付宝支付回调处理
 */
- (void)callBackAlipay:(NSNotification *)sender {

    NSString *state = sender.object;
    //如果支付成功跳转成功的页面
    if ([state isEqualToString:@"1"]) {
        
    }
    
    //如果支付失败跳转失败的页面
    else {
       
        
    }
}

/**
 *微信支付回调处理
 */
- (void)callBackWXpay:(NSNotification *)sender {
    
    NSString *state = sender.object;
    //如果支付成功跳转成功的页面
    if ([state isEqualToString:@"1"]) {
        
        
    }
    
    //如果支付失败跳转失败的页面
    else {
        
        
    }
    
}

- (void)setParams:(NSDictionary *)params {

    _params = params;
}

- (void)setIsOneMoneyLottery:(BOOL)isOneMoneyLottery {

    _isOneMoneyLottery = isOneMoneyLottery;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
@end
