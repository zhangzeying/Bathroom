//
//  BathroomService.h
//  BathroomShopping
//
//  Created by zzy on 7/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BathroomService : NSObject
/**
 * 卫浴商品类别请求
 */
- (void)getGoodsCategory:(void(^)(id))completion;
/**
 * 热门商品网络请求
 */
- (void)getHotGoodsList:(void(^)(id))completion;
/**
 * 根据类别code获取商品
 */
- (void)getGoodsByCategory:(NSString *)code completion:(void(^)(id))completion;
@end
