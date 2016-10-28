//
//  ShoppingCartInfoDB.m
//  BathroomShopping
//
//  Created by zzy on 8/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "ShoppingCartInfoDB.h"
#import "FileNameDefine.h"
#import "ShoppingCartDetailModel.h"
#import "GoodsSpecModel.h"
@implementation ShoppingCartInfoDB
/**
 * 拿到数据库实例
 */
+ (ShoppingCartInfoDB *)sharedInstance
{
    static ShoppingCartInfoDB *db = nil;
    
    if(db == nil){
        db = [[ShoppingCartInfoDB alloc] init];
        [db setDb:[FMDatabase databaseWithPath:dbPath]];
        BSLog(@"%@",dbPath);
        [db createTable];
    }
    return db;
}

/**
 * 创建表
 */
- (BOOL)createTable {
    if (!_db) {
        
        return NO;
    }
    @try {
        [_db open];
        return [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_shoppingcart (id INTEGER PRIMARY KEY AUTOINCREMENT, goodsId TEXT, specId TEXT,buyNumber INTEGER, cartinfo BLOB,packageId TEXT, ispackage TEXT)"];
    }
    @catch (NSException *exception) {
        BSLog(@"CREATE TABLE tb_shoppingcart %@",[exception reason]);
    }
    @finally {
        [_db close];
    }
}

/**
 * 新增
 */
- (BOOL)saveShoppingcartData:(ShoppingCartDetailModel *)model {
    
    if (!_db) {
        
        return FALSE;
    }
    @try {
        [_db open];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        NSString * sql = [NSString stringWithFormat:@"insert into tb_shoppingcart(goodsId,specId,buyNumber,cartinfo,packageId,ispackage) values (?,?,?,?,?,?)"];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:model.id];
        if (model.isPackage) {
            
            [params addObject:model.specIds];
            
        }else {
        
            [params addObject:model.buySpecInfo.id];
        }
        
        [params addObject:@(model.buyCount)];
        [params addObject:data];
        [params addObject:model.packageId?:@""];
        [params addObject:@(model.isPackage)];
        return [_db executeUpdate:sql withArgumentsInArray:params];
    }
    @catch (NSException *exception) {
        
        BSLog(@"insert into tb_shoppingcart %@",[exception reason]);
    }
    @finally {
        
        [_db close];
    }
}

/**
 * 更新
 */
- (BOOL)updateCartById:(ShoppingCartDetailModel *)model {
    
    if (!_db) {
        
        return FALSE;
    }
    @try {
        [_db open];
        NSString * sql = [NSString stringWithFormat:@"update tb_shoppingcart set cartinfo = ?,buyNumber = ? where goodsId = ? and specId = ? and packageId = ? and ispackage = ?"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:data];
        [params addObject:@(model.buyCount)];
        [params addObject:model.id];
        if (model.isPackage) {
            
            [params addObject:model.specIds];
            
        }else {
        
            [params addObject:model.buySpecInfo.id];
        }
        
        [params addObject:model.packageId?:@""];
        [params addObject:@(model.isPackage)];
        return [_db executeUpdate:sql withArgumentsInArray:params];
    }
    @catch (NSException *exception) {
        
        BSLog(@"update tb_shoppingcart  %@",[exception reason]);
    }
    @finally {
        
        [_db close];
    }
}

/**
 * 查询所有数据(ispackage区分是单品还是套餐)
 */
- (NSMutableArray *)getAllCartInfo:(BOOL)isPackage {
    
    NSMutableArray *dataArr = [NSMutableArray array];
    if (!_db) {
        
        return FALSE;
    }
    @try {
        [_db open];
        NSString *sql = [NSString stringWithFormat:@"select cartinfo,id from tb_shoppingcart where ispackage = ?"];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:@(isPackage)];
        FMResultSet *set = [_db executeQuery:sql withArgumentsInArray:params];
        while ([set next]) {
            
            NSData *data = [set objectForColumnName:@"cartinfo"];
            ShoppingCartDetailModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            model.cartId = [set objectForColumnName:@"id"];
            [dataArr addObject:model];
        }
    }
    @catch (NSException *exception) {
        
        BSLog(@"select cartinfo from tb_shoppingcart %@",[exception reason]);
    }
    @finally {
        
        [_db close];
        return dataArr;
    }
}

/**
 * 根据id查询某个商品是否存在
 */
- (NSData *)getCartInfoById:(NSString *)goodsId specId:(NSString *)specId packageId:(NSString *)packageId isPackage:(BOOL)isPackage {
    
    NSData *data = nil;
    if (!_db) {
        
        return FALSE;
    }
    @try {
        [_db open];
        NSString *sql = [NSString stringWithFormat:@"select cartinfo from tb_shoppingcart where goodsId = ? and specId = ? and packageId = ? and ispackage = ?"];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:goodsId];
        [params addObject:specId];
        [params addObject:packageId?:@""];
        [params addObject:@(isPackage)];
        FMResultSet *set = [_db executeQuery:sql withArgumentsInArray:params];
        if ([set next]) {
            
            data = [set objectForColumnName:@"cartinfo"];
        }
    }
    @catch (NSException *exception) {
        
        BSLog(@"select cartinfo from tb_shoppingcart %@",[exception reason]);
    }
    @finally {
        
        [_db close];
        return data;
    }
}

/**
 * 获取购物车商品总数
 */
- (NSInteger)getCartGoodsNum {

    NSInteger number = 0;
    if (!_db) {
        
        return FALSE;
    }
    @try {
        
        [_db open];
        NSString *sql = [NSString stringWithFormat:@"select sum(buyNumber) as total, count(*) from tb_shoppingcart"];
        FMResultSet *set = [_db executeQuery:sql withArgumentsInArray:nil];
        if ([set next]) {
            
            number = [[set objectForColumnName:@"total"] integerValue];
        }
    }
    @catch (NSException *exception) {
        
        BSLog(@"select sum(buyNumber) as total, count(*) from tb_shoppingcart %@",[exception reason]);
    }
    @finally {
        
        [_db close];
        return number;
    }
}

/**
 * 根据id删除数据
 */
- (BOOL)deleteCartById:(NSString *)cartId {
    
    if (!_db) {
        
        return FALSE;
    }
    @try {
        
        [_db open];
        NSString *sql = [NSString stringWithFormat:@"delete from tb_shoppingcart where id = ?"];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:cartId];
        return [_db executeUpdate:sql withArgumentsInArray:params];
    }
    @catch (NSException *exception) {
        
        BSLog(@"delete from tb_shoppingcart where id = ? %@",[exception reason]);
    }
    @finally {
        
        [_db close];
    }
}

/**
 * 根据ids删除多条数据
 */
- (BOOL)deleteCartByIds:(NSMutableArray *)cartModelArr {
    
    if (!_db) {
        
        return FALSE;
    }
    BOOL isRollBack = NO; //是否回滚
    BOOL flag = YES;
    @try {
        
        [_db open];
        [_db beginTransaction];//开始事务
        
        
        for (ShoppingCartDetailModel *model in cartModelArr) {
            
            NSString *sql = [NSString stringWithFormat:@"delete from tb_shoppingcart where id = ?"];
            NSMutableArray *params = [NSMutableArray array];
            [params addObject:model.cartId];
            if (![_db executeUpdate:sql withArgumentsInArray:params]) {
                
                flag = NO;
                break;
            }
        }
        
    }
    @catch (NSException *exception) {
        
        BSLog(@"delete from tb_shoppingcart where id = ? %@",[exception reason]);
        isRollBack = YES;
        [_db rollback];
    }
    @finally {
        
        if (!isRollBack) {
            
            [_db commit];
            [_db close];
        }
        
        return flag;
    }
}

/**
 * 删除所有数据
 */
- (BOOL)deleteAll:(BOOL)isPackage {
    
    if (!_db) {
        
        return FALSE;
    }
    @try {
        
        [_db open];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:@(isPackage)];
        NSString *sql = [NSString stringWithFormat:@"delete from tb_shoppingcart where ispackage = ?"];
        return [_db executeUpdate:sql withArgumentsInArray:params];
    }
    @catch (NSException *exception) {
        
        BSLog(@"delete from tb_shoppingcart %@",[exception reason]);
    }
    @finally {
        
        [_db close];
    }
}

/**
 * 移除sqlite
 */
- (BOOL)deleteSqlite {
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager removeItemAtPath:dbPath error:nil];
}

@end
