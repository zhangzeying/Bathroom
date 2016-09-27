//
//  MallService.m
//  BathroomShopping
//
//  Created by zzy on 8/5/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MallService.h"
#import "RestService.h"
#import "ActivityGoodsDetailModel.h"
#import "GoodsCategoryModel.h"
#import "ActivityGoodsModel.h"
@interface MallService()
@property(nonatomic ,strong)RestService *restService;
@end

@implementation MallService

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.restService = [RestService sharedService];
    }
    
    return self;
}

/**
 * 卫浴商品类别请求（type传0代表卫浴下的商品分类）
 */
- (void)getGoodsCategory:(void(^)(id))completion {
    
    NSDictionary *param = @{@"type" : @"0"};
    
    [self.restService afnetworkingPost:kAPIGoodsCategory parameters:param completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                NSArray *resultArr = dictData[@"result"];
                NSArray *categoryArr = [GoodsCategoryModel mj_objectArrayWithKeyValuesArray:resultArr];
                completion(categoryArr);
                
            }else {
                
                return;
            }
            
        }
        
    }];
}

///**
// * 热门商品网络请求
// */
//- (void)getHotGoodsList:(void(^)(id))completion {
//    
//    [self.restService afnetworkingPost:kAPIHomeHotGoods parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
//        
//        if (flag) {
//            
//            NSDictionary *dictData = myAfNetBlokResponeDic;
//            BSLog(@"%@",dictData);
//            if ([dictData[@"flag"] isEqualToString:@"0"]) {
//                
//                NSArray *resultArr = dictData[@"result"];
//                NSArray *hotGoodsArr = [ActivityGoodsDetailModel mj_objectArrayWithKeyValuesArray:resultArr];
//                completion(hotGoodsArr);
//            }
//            
//        }
//        
//    }];
//}

/**
 * 套餐商品列表
 */
- (void)getPackageList:(void(^)(id))completion {
    
    [self.restService afnetworkingPost:kAPIPackageList parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            ActivityGoodsModel *model = [ActivityGoodsModel mj_objectWithKeyValues:dictData];
            NSMutableArray *tempArr = @[].mutableCopy;
            for (NSDictionary *dict in model.list) {
                
                NSArray *productArr = dict[@"productList"];
                for (NSDictionary *productDict in productArr) {
                    
                    ActivityGoodsDetailModel *detailModel = [ActivityGoodsDetailModel mj_objectWithKeyValues:productDict];
                    [tempArr addObject:detailModel];
                }
            }
            model.list = tempArr;
            completion(model);
        }
        
        
        
    }];
}

@end
