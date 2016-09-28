//
//  BathroomService.m
//  BathroomShopping
//
//  Created by zzy on 7/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BathroomService.h"
#import "RestService.h"
#import "ActivityGoodsDetailModel.h"
#import "GoodsCategoryModel.h"
#import "ActivityGoodsModel.h"
@interface BathroomService()
@property(nonatomic ,strong)RestService *restService;
@end

@implementation BathroomService
- (instancetype)init {
    
    if (self = [super init]) {
        
        self.restService = [RestService sharedService];
    }
    
    return self;
}

/**
 * 卫浴商品类别请求（type传1代表卫浴下的商品分类）
 */
- (void)getGoodsCategory:(void(^)(id))completion {
    
    NSDictionary *param = @{@"type" : @"1"};
    
    [self.restService afnetworkingPost:kAPIGoodsCategory parameters:param completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                NSArray *resultArr = dictData[@"result"];
                NSDictionary *resultDict = [resultArr firstObject];
                NSArray *childrenArr = resultDict[@"children"];
                NSArray *categoryArr = [GoodsCategoryModel mj_objectArrayWithKeyValuesArray:childrenArr];
                completion(categoryArr);
                
            }else {
                
                return;
            }
            
        }
        
    }];
}

/**
 * 热门商品网络请求
 */
- (void)getHotGoodsList:(void(^)(id))completion {
    
    [self.restService afnetworkingPost:kAPIBathroomHotGoods parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
            if ([dictData[@"flag"] isEqualToString:@"0"]) {
                
                NSArray *resultArr = dictData[@"result"];
                NSArray *hotGoodsArr = [ActivityGoodsDetailModel mj_objectArrayWithKeyValuesArray:resultArr];
                completion(hotGoodsArr);
            }
            
        }
        
    }];
}

/**
 * 根据类别code获取商品
 */
- (void)getGoodsByCategory:(NSString *)code completion:(void(^)(id))completion {
    
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIGetProductsByCode(code) parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [SVProgressHUD dismiss];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            [ActivityGoodsModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"list" : @"ActivityGoodsDetailModel"};
            }];
            
            ActivityGoodsModel *model = [ActivityGoodsModel mj_objectWithKeyValues:dictData];
            completion(model);
        }
        
    }];
}

@end
