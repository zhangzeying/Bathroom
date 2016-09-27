//
//  ShoppingCartInfoDB.h
//  BathroomShopping
//
//  Created by zzy on 8/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface ShoppingCartInfoDB : NSObject
@property(nonatomic,strong)FMDatabase *db;

/**拿到数据库实例**/
+ (ShoppingCartInfoDB *)sharedInstance;
/**
 * 新增
 */
- (BOOL)saveShoppingcartData:(NSData *)cartinfo goodsId:(NSString *)goodsId specId:(NSString *)specId buyNumber:(NSInteger)buyNumber;
/**
 * 更新
 */
- (BOOL)updateCartById:(NSData *)cartinfo goodsId:(NSString *)goodsId specId:(NSString *)specId buyNumber:(NSInteger)buyNumber;
/**
 * 根据id查询某个商品是否存在
 */
- (NSData *)getCartInfoById:(NSString *)goodsId specId:(NSString *)specId;
/**
 * 查询所有数据
 */
- (NSMutableArray *)getAllCartInfo;
/**
 * 获取购物车商品总数
 */
- (NSInteger)getCartGoodsNum;
/**
 * 根据id删除数据
 */
- (BOOL)deleteCartGoodsById:(NSString *)goodsId specId:(NSString *)specId;
/**
 * 删除所有数据
 */
- (BOOL)deleteAll;
/**
 * 移除sqlite
 */
- (BOOL)deleteSqlite;

@end
