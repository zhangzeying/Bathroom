//
//  ShoppingCartInfoDB.h
//  BathroomShopping
//
//  Created by zzy on 8/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class ShoppingCartDetailModel;
@interface ShoppingCartInfoDB : NSObject
@property(nonatomic,strong)FMDatabase *db;

/**拿到数据库实例**/
+ (ShoppingCartInfoDB *)sharedInstance;
/**
 * 新增
 */
- (BOOL)saveShoppingcartData:(ShoppingCartDetailModel *)model;
/**
 * 更新
 */
- (BOOL)updateCartById:(ShoppingCartDetailModel *)model;
/**
 * 根据id查询某个商品是否存在
 */
- (NSData *)getCartInfoById:(NSString *)goodsId specId:(NSString *)specId packageId:(NSString *)packageId isPackage:(BOOL)isPackage;
/**
 * 查询所有数据
 */
- (NSMutableArray *)getAllCartInfo:(BOOL)isPackage;
/**
 * 获取购物车商品总数
 */
- (NSInteger)getCartGoodsNum;
/**
 * 根据id删除数据
 */
- (BOOL)deleteCartById:(NSString *)cartId;
/**
 * 根据ids删除多条数据
 */
- (BOOL)deleteCartByIds:(NSMutableArray *)cartIdArr;
/**
 * 删除所有数据
 */
- (BOOL)deleteAll:(BOOL)isPackage;
/**
 * 移除sqlite
 */
- (BOOL)deleteSqlite;

@end
