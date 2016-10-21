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
        return [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_shoppingcart (id INTEGER PRIMARY KEY AUTOINCREMENT, goodsId TEXT, specId TEXT,buyNumber INTEGER, cartinfo BLOB, ispackage TEXT)"];
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
- (BOOL)saveShoppingcartData:(NSData *)cartinfo goodsId:(NSString *)goodsId specId:(NSString *)specId buyNumber:(NSInteger)buyNumber isPackage:(BOOL)isPackage{
    
    if (!_db) {
        
        return FALSE;
    }
    @try {
        [_db open];
        NSString * sql = [NSString stringWithFormat:@"insert into tb_shoppingcart(goodsId,specId,buyNumber,cartinfo,ispackage) values (?,?,?,?,?)"];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:goodsId];
        [params addObject:specId];
        [params addObject:@(buyNumber)];
        [params addObject:cartinfo];
        [params addObject:@(isPackage)];
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
- (BOOL)updateCartById:(NSData *)cartinfo goodsId:(NSString *)goodsId specId:(NSString *)specId buyNumber:(NSInteger)buyNumber {
    
    if (!_db) {
        
        return FALSE;
    }
    @try {
        [_db open];
        NSString * sql = [NSString stringWithFormat:@"update tb_shoppingcart set cartinfo = ?,buyNumber = ? where goodsId = ? and specId = ?"];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:cartinfo];
        [params addObject:@(buyNumber)];
        [params addObject:goodsId];
        [params addObject:specId];
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
 * 查询所有数据
 */
- (NSMutableArray *)getAllCartInfo {
    
    NSMutableArray *dataArr = [NSMutableArray array];
    if (!_db) {
        
        return FALSE;
    }
    @try {
        [_db open];
        NSString *sql = [NSString stringWithFormat:@"select cartinfo from tb_shoppingcart"];
        FMResultSet *set = [_db executeQuery:sql withArgumentsInArray:nil];
        while ([set next]) {
            
            NSData *data = [set objectForColumnName:@"cartinfo"];
            ShoppingCartDetailModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
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
- (NSData *)getCartInfoById:(NSString *)goodsId specId:(NSString *)specId {
    
    NSData *data = nil;
    if (!_db) {
        
        return FALSE;
    }
    @try {
        [_db open];
        NSString *sql = [NSString stringWithFormat:@"select cartinfo from tb_shoppingcart where goodsId = ? and specId = ?"];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:goodsId];
        [params addObject:specId];
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
- (BOOL)deleteCartGoodsById:(NSString *)goodsId specId:(NSString *)specId {
    
    if (!_db) {
        
        return FALSE;
    }
    @try {
        
        [_db open];
        NSString *sql = [NSString stringWithFormat:@"delete from tb_shoppingcart where goodsId = ? and specId = ?"];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:goodsId];
        [params addObject:specId];
        return [_db executeUpdate:sql withArgumentsInArray:params];
    }
    @catch (NSException *exception) {
        
        BSLog(@"delete from tb_shoppingcart where goodsId = ? and specId = ? %@",[exception reason]);
    }
    @finally {
        
        [_db close];
    }
}

/**
 * 删除所有数据
 */
- (BOOL)deleteAll {
    
    if (!_db) {
        
        return FALSE;
    }
    @try {
        
        [_db open];
        NSString *sql = [NSString stringWithFormat:@"delete from tb_shoppingcart"];
        return [_db executeUpdate:sql withArgumentsInArray:nil];
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
