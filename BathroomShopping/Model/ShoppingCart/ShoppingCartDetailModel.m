
//
//  ShoppingCartDetailModel.m
//  BathroomShopping
//
//  Created by zzy on 8/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "ShoppingCartDetailModel.h"
#import "ShoppingCartInfoDB.h"
#import "GoodsSpecModel.h"
@implementation ShoppingCartDetailModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.picture forKey:@"picture"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.buyCount] forKey:@"buyCount"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.nowPrice] forKey:@"nowPrice"];
    [aCoder encodeObject:self.buySpecInfo forKey:@"buySpecInfo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.picture = [aDecoder decodeObjectForKey:@"picture"];
        self.buyCount = [[aDecoder decodeObjectForKey:@"buyCount"] integerValue];
        self.nowPrice = [[aDecoder decodeObjectForKey:@"nowPrice"] doubleValue];
        self.buySpecInfo = [aDecoder decodeObjectForKey:@"buySpecInfo"];
    }
    
    return self;
}

/**
 * 购物车数据模型存入数据库
 */
+ (BOOL)saveCartModelToDB:(ShoppingCartDetailModel *)model {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    return [db saveShoppingcartData:data goodsId:model.id specId:model.buySpecInfo.id buyNumber:model.buyCount];
}

/**
 * 更新购物车数据模型
 */
+ (BOOL)updateCartModel:(ShoppingCartDetailModel *)model {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    return [db updateCartById:data goodsId:model.id specId:model.buySpecInfo.id buyNumber:model.buyCount];
}

/**
 * 获取购物车商品总数
 */
+ (NSInteger)getCartGoodsNumber {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    return [db getCartGoodsNum];
}

/**
 * 获取购物车所有数据
 */
+ (NSMutableArray *)getCartList {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    return [db getAllCartInfo];
}

/**
 * 获取某条记录
 */
+ (ShoppingCartDetailModel *)getCartModelById:(NSString *)goodsId specId:(NSString *)specId {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    NSData *data = [db getCartInfoById:goodsId specId:specId];
    if (data != nil && data != NULL) {
        //从缓存中取出数据
        ShoppingCartDetailModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return model;
        
    }else {
        
        return nil;
    }
}

/**
 * 根据id删除购物车某条数据
 */
+ (BOOL)deleteCartById:(NSString *)goodsId specId:(NSString *)specId {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    return [db deleteCartGoodsById:goodsId specId:specId];
}

/**
 * 删除所有数据
 */
+ (BOOL)deleteAllCart {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    return [db deleteAll];
}
@end
