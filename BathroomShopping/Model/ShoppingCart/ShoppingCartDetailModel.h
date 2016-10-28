//
//  ShoppingCartDetailModel.h
//  BathroomShopping
//
//  Created by zzy on 8/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GoodsSpecModel;

@interface ShoppingCartDetailModel : NSObject<NSCoding>
/** 购物车id */
@property(nonatomic,copy)NSString *cartId;
/** 商品id */
@property(nonatomic,copy)NSString *id;
/** 名称 */
@property(nonatomic,copy)NSString *name;
/** 图片 */
@property(nonatomic,copy)NSString *picture;
/** 购买数量 */
@property(assign,nonatomic)NSInteger buyCount;
/** 单价格 */
@property(assign,nonatomic)double nowPrice;
/** <##> */
@property(nonatomic,strong)GoodsSpecModel *buySpecInfo;
/** 套餐id */
@property(nonatomic,copy)NSString *packageId;
/** 套餐下的商品id */
@property(nonatomic,copy)NSString *productIds;
/** 套餐的规格 */
@property(nonatomic,copy)NSString *specDesc;
/** 套餐的规格id */
@property(nonatomic,copy)NSString *specIds;
/** 套餐的库存 */
@property(nonatomic,assign)NSInteger packageStock;
/** 单价格 */
@property(assign,nonatomic)double price;
/** 套餐价格 */
@property(assign,nonatomic)double packagePice;

#pragma mark --- 辅助属性 ---
/** 购物车里是否被选中 */
@property(assign,nonatomic)BOOL isChecked;
/** 是否是套餐 */
@property(assign,nonatomic)BOOL isPackage;


/**
 * 购物车数据模型存入数据库
 */
+ (BOOL)saveCartModelToDB:(ShoppingCartDetailModel *)model;
/**
 * 更新购物车数据模型
 */
+ (BOOL)updateCartModel:(ShoppingCartDetailModel *)model;
/**
 * 获取购物车商品总数
 */
+ (NSInteger)getCartGoodsNumber;
/**
 * 获取购物车所有数据
 */
+ (NSMutableArray *)getCartList:(BOOL)isPackage;
/**
 * 获取某条记录
 */
+ (ShoppingCartDetailModel *)getCartModelById:(NSString *)goodsId specId:(NSString *)specId packageId:(NSString *)packageId isPackage:(BOOL)isPackage;
/**
 * 根据id删除购物车某条数据
 */
+ (BOOL)deleteCartById:(NSString *)cartId;
/**
 * 根据ids删除购物车多条数据
 */
+ (BOOL)deleteCartByIds:(NSMutableArray *)cartModelArr;
/**
 * 移除数据库
 */
+ (BOOL)deleteAllCart:(BOOL)isPackage;
@end
