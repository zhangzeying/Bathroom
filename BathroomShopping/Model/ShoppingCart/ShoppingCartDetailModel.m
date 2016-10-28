
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
#import "NSObject+Extension.h"
@implementation ShoppingCartDetailModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [self encode:aCoder];
//    [aCoder encodeObject:self.id forKey:@"id"];
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.picture forKey:@"picture"];
//    [aCoder encodeObject:[NSNumber numberWithInteger:self.buyCount] forKey:@"buyCount"];
//    [aCoder encodeObject:[NSNumber numberWithDouble:self.nowPrice] forKey:@"nowPrice"];
//    [aCoder encodeObject:self.buySpecInfo forKey:@"buySpecInfo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        [self decode:aDecoder];
//        self.id = [aDecoder decodeObjectForKey:@"id"];
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.picture = [aDecoder decodeObjectForKey:@"picture"];
//        self.buyCount = [[aDecoder decodeObjectForKey:@"buyCount"] integerValue];
//        self.nowPrice = [[aDecoder decodeObjectForKey:@"nowPrice"] doubleValue];
//        self.buySpecInfo = [aDecoder decodeObjectForKey:@"buySpecInfo"];
    }
    
    return self;
}

/**
 * 购物车数据模型存入数据库
 */
+ (BOOL)saveCartModelToDB:(ShoppingCartDetailModel *)model {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    return [db saveShoppingcartData:model];
}

/**
 * 更新购物车数据模型
 */
+ (BOOL)updateCartModel:(ShoppingCartDetailModel *)model {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    return [db updateCartById:model];
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
+ (NSMutableArray *)getCartList:(BOOL)isPackage {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    return [db getAllCartInfo:isPackage];
}

/**
 * 获取某条记录
 */
+ (ShoppingCartDetailModel *)getCartModelById:(NSString *)goodsId specId:(NSString *)specId packageId:(NSString *)packageId isPackage:(BOOL)isPackage {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    NSData *data = [db getCartInfoById:goodsId specId:specId packageId:packageId isPackage:isPackage];
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
+ (BOOL)deleteCartById:(NSString *)cartId {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    return [db deleteCartById:cartId];
}

/**
 * 根据ids删除购物车多条数据
 */
+ (BOOL)deleteCartByIds:(NSMutableArray *)cartIdsArr {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    return [db deleteCartByIds:cartIdsArr];
}

/**
 * 删除所有数据
 */
+ (BOOL)deleteAllCart:(BOOL)isPackage {
    
    ShoppingCartInfoDB *db = [ShoppingCartInfoDB sharedInstance];
    return [db deleteAll:isPackage];
}
@end
