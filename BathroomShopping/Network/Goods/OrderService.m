//
//  OrderService.m
//  BathroomShopping
//
//  Created by zzy on 9/1/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderService.h"
#import "RestService.h"
#import "OrderModel.h"
#import "OrderDetailModel.h"
#import "ConfirmOrderModel.h"
#import "ProPackageModel.h"
@interface OrderService()
@property(nonatomic ,strong)RestService *restService;
@end
@implementation OrderService
- (instancetype)init {
    
    if (self = [super init]) {
        
        self.restService = [RestService sharedService];
    }
    
    return self;
}

/**
 * 生成订单
 */
- (void)order:(NSDictionary *)params url:(NSString *)url completion:(void(^)(id))completion {
    
    [MBProgressHUD showMessage:@"加载中....."];
    [self.restService afnetworkingPost:url parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [MBProgressHUD hideHUD];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            NSLog(@"%@",dictData);
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderSuccess" object:nil];
                completion(dictData[@"result"]);
                
            }else {
                
                return;
            }
        }
        
    }];
}

/**
 * 获取订单
 */
- (void)getOrder:(NSString *)type offset:(NSInteger)offset completion:(void(^)(id,NSInteger))completion {
    
    NSDictionary *params = @{@"token":[[CommUtils sharedInstance] fetchToken],
                             @"offset":@(offset)};
    [self.restService afnetworkingPost:kAPIGetOrder(type) parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                NSArray *listArr = dictData[@"result"][@"orders"];
                NSInteger total = [dictData[@"result"][@"totle"] integerValue];
                [OrderModel mj_setupObjectClassInArray:^NSDictionary *{
                    return @{
                             @"orders" : @"OrderDetailModel"
                             };
                }];
                
                NSArray *orderArr = [OrderModel mj_objectArrayWithKeyValuesArray:listArr];
                completion(orderArr,total);
                
            }else {
                
                completion(nil,-1);
            }
            
        }else {
        
            completion(nil,-1);
        }
        
    }];
}

/**
 * 生成一元抢购抽奖订单
 */
- (void)oneMoneyOrder:(NSDictionary *)params completion:(void(^)(id))completion {
    
    [MBProgressHUD showMessage:@"加载中....."];
    [self.restService afnetworkingPost:kAPIPayOneYuan parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [MBProgressHUD hideHUD];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderSuccess" object:nil];
                completion(dictData[@"result"]);
                
            }else {
                
                return;
            }
            
        }
        
    }];
}

/**
 * 取消订单
 */
- (void)cancelOrder:(NSString *)orderId completion:(void(^)())completion {

    NSDictionary *params = @{@"token":[[CommUtils sharedInstance] fetchToken],
                             @"orderId":orderId};
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPICancelOrder parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                [SVProgressHUD showSuccessWithStatus:@"取消订单成功！" maskType:SVProgressHUDMaskTypeBlack];
                completion();
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"取消订单失败！" maskType:SVProgressHUDMaskTypeBlack];
            }
            
        }else {
        
            [SVProgressHUD showErrorWithStatus:@"取消订单失败！" maskType:SVProgressHUDMaskTypeBlack];
        }
        
    }];
}

/**
 * 确认订单
 */
- (void)confirmOrder:(NSDictionary *)params completion:(void(^)(id))completion {
    
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIConfirmOrder parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            [SVProgressHUD dismiss];
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                [ConfirmOrderModel mj_setupObjectClassInArray:^NSDictionary *{
                    return @{
                             @"expressList" : @"DeliveryModel",
                             @"addressList" : @"ReceiverAddressModel",
                             @"productList" : @"ShoppingCartDetailModel",
                             @"proPackageList" : @"ProPackageModel",
                             };
                }];
                
                [ProPackageModel mj_setupObjectClassInArray:^NSDictionary *{
                    return @{
                             @"productList" : @"ShoppingCartDetailModel",
                             };
                }];
                
                ConfirmOrderModel *model = [ConfirmOrderModel mj_objectWithKeyValues:dictData[@"result"]];
                completion(model);
                
            }
        }
        
    }];
}

/**
 * 订单再次支付
 */
- (void)payAgain:(NSDictionary *)params completion:(void(^)(id))completion {

    [MBProgressHUD showMessage:@"加载中....."];
    [self.restService afnetworkingPost:kAPIPayAgain parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            [MBProgressHUD hideHUD];
            NSDictionary *dictData = myAfNetBlokResponeDic;
            completion(dictData[@"result"]);
        }
        
    }];
}
@end
