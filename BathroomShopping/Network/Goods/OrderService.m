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
            NSLog(@"%@",dictData);
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                completion(dictData[@"result"]);
                
            }else {
                
                return;
            }
            
        }
        
    }];
}

@end
