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
/** <##> */
@property(nonatomic,copy)NSString *specDesc;
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
+ (NSMutableArray *)getCartList;
/**
 * 获取某条记录
 */
+ (ShoppingCartDetailModel *)getCartModelById:(NSString *)goodsId specId:(NSString *)specId;
/**
 * 根据id删除购物车某条数据
 */
+ (BOOL)deleteCartById:(NSString *)goodsId specId:(NSString *)specId;
/**
 * 移除数据库
 */
+ (BOOL)deleteAllCart;
@end
