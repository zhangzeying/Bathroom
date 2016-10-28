//
//  HomeService.h
//  BathroomShopping
//
//  Created by zzy on 7/21/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeService : NSObject
+ (HomeService *)sharedInstance;
- (void)getNewsList:(void(^)(id))handler;
- (void)getActivityGoodsList:(void(^)(id))handler;
- (void)getHotGoodsList:(void(^)(id))completion;
/**
 * 一元抢购网络请求
 */
- (void)getOneSaleList:(void(^)(id))completion;
/**
 * 一元抢购中奖名单
 */
- (void)getLotteryUserList:(void(^)(id))completion;
/**
 * 热门搜索（获取热门商品）
 */
- (void)gethotProductList:(void(^)(id))completion;
/**
 * 关键词搜索
 */
- (void)searchProductByKeywords:(NSString *)keywords completion:(void(^)(id))completion;
/**
 * 获取限时抢购时间节点
 */
- (void)getLimitTimeBuyPeriod:(void(^)(id))completion;
/**
 * 根据限时抢购时间节点获取商品
 */
- (void)getProductByTime:(NSString *)startDate completion:(void(^)(id))completion;
/**
 * 获取特惠商城分类
 */
- (void)getPerferenceActivity:(void(^)(id))completion;
/**
 * 根据特惠商城分类获取商品
 */
- (void)getPerferenceProductList:(NSDictionary *)params completion:(void(^)(id))completion;
@end
