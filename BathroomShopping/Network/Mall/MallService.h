//
//  MallService.h
//  BathroomShopping
//
//  Created by zzy on 8/5/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallService : NSObject
/**
 * 商城商品类别请求
 */
- (void)getGoodsCategory:(void(^)(id))completion;
/**
 * 热门商品网络请求
 */
//- (void)getHotGoodsList:(void(^)(id))completion;

/**
 * 套餐商品列表
 */
- (void)getPackageList:(void(^)(id))completion;
@end
