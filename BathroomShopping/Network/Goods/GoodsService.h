//
//  GoodsService.h
//  BathroomShopping
//
//  Created by zzy on 8/10/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsService : NSObject
/**
 * 根据商品id获取商品详情
 */
- (void)getGoodsDetailInfo:(NSString *)goodsId completion:(void(^)(id))completion;
/**
 * 根据套餐id获取套餐详情
 */
- (void)getPackageDetailInfo:(NSString *)packageId completion:(void(^)(id))completion;
/**
 * 获取购物车清单
 */
- (void)getCartList:(void(^)(id))completion;
/**
 * 收藏商品
 */
- (void)likedGoods:(NSString *)goodsId completion:(void(^)())completion;
/**
 * 取消收藏商品
 */
- (void)unLikedGoods:(NSString *)goodsId completion:(void(^)())completion;
/**
 * 预约商品
 */
- (void)appointGoods:(NSDictionary *)params completion:(void(^)())completion;
/**
 * 加入购物车
 */
- (void)addCart:(NSString *)productID buyCount:(NSInteger)buyCount buySpecID:(NSString *)buySpecID completion:(void(^)())completion;
/**
 * 上传未登录时的购物车
 */
- (void)uploadCart:(NSString *)jsonStr completion:(void(^)())completion;
/**
 * 删除购物车商品
 */
- (void)deleteCart:(NSDictionary *)params completion:(void(^)())completion;
/**
 * 更新购物车数量
 */
- (void)updateCartCount:(NSDictionary *)params completion:(void(^)())completion;
/**
 * 推荐商品网络请求
 */
- (void)getRecommendGoodsList:(NSString *)code completion:(void(^)(id))completion;
/**
 * 获取省份
 */
- (void)getProvice:(void(^)(id))completion;
/**
 * 获取省份对应的城市
 */
- (void)getCityByProvinceCode:(NSString *)provinceCode completion:(void(^)(id))completion;
/**
 * 获取省份和城市对应的区
 */
- (void)getDistrictByCityCode:(NSString *)provinceCode cityCode:(NSString *)cityCode completion:(void(^)(id))completion;
/**
 * 获取配送方式
 */
- (void)getDelivery:(void(^)(id))completion;
@end
