//
//  OrderService.h
//  BathroomShopping
//
//  Created by zzy on 9/1/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderService : NSObject
/**
 * 生成订单
 */
- (void)order:(NSDictionary *)params url:(NSString *)url completion:(void(^)(id))completion;
/**
 * 获取订单
 */
- (void)getOrder:(NSString *)type completion:(void(^)(id))completion;
/**
 * 生成一元抢购抽奖订单
 */
- (void)oneMoneyOrder:(NSDictionary *)params completion:(void(^)(id))completion;
@end
