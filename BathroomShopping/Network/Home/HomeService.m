//
//  HomeService.m
//  BathroomShopping
//
//  Created by zzy on 7/21/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "HomeService.h"
#import "NewsModel.h"
#import "ActivityGoodsModel.h"
#import "ActivityGoodsDetailModel.h"
#import "RestService.h"
#import "GoodsModel.h"
#import "GoodsDetailModel.h"
#import "LotteryUserModel.h"
#import "LimitTimeBuyModel.h"
#import "LimitBuyProductModel.h"
#import "GoodsCategoryModel.h"
@interface HomeService()
@property(nonatomic ,strong)RestService *restService;
@end

@implementation HomeService
- (instancetype)init {
    
    if (self = [super init]) {
        
        self.restService = [RestService sharedService];
    }
    
    return self;
}

+ (HomeService *)sharedInstance {
    
    static HomeService *_sharedService = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedService = [[self alloc] init];
        
    });
    
    return _sharedService;
}

/**
 * 首页滚动消息的网络请求
 */
- (void)getNewsList:(void(^)(id))handler {
    
    [self.restService afnetworkingPost:kAPINewsList parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            NSArray *dictArr = dictData[@"list"];
            NSArray *newsModelArr = [NewsModel mj_objectArrayWithKeyValuesArray:dictArr];
            handler(newsModelArr);
        }
        
    }];
    
}


/**
 * 首页活动商品的网络请求
 */
- (void)getActivityGoodsList:(void(^)(id))handler {

    
    [self.restService afnetworkingPost:kAPIActivityGoods parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            [ActivityGoodsModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"perference" : @"ActivityGoodsDetailModel",
                         @"oneYuan" : @"ActivityGoodsDetailModel",
                         @"buy":@"LimitTimeBuyModel"
                         };
            }];
            
            
            [LimitTimeBuyModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"products" : @"ActivityGoodsDetailModel"
                         };
            }];
            
            ActivityGoodsModel *activityGoodsModel = [ActivityGoodsModel mj_objectWithKeyValues:dictData];
            activityGoodsModel.buyModel = [LimitTimeBuyModel mj_objectWithKeyValues:dictData[@"buy"]];
            handler(activityGoodsModel);
            
        }else {
        
            handler(nil);
        }
        
    }];
}

/**
 * 热门商品网络请求
 */
- (void)getHotGoodsList:(void(^)(id))completion {
    
    [self.restService afnetworkingPost:kAPIHomeHotGoods parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
            if ([dictData[@"flag"] isEqualToString:@"0"]) {
                
                NSArray *resultArr = dictData[@"result"];
                NSArray *hotGoodsArr = [ActivityGoodsDetailModel mj_objectArrayWithKeyValuesArray:resultArr];
                completion(hotGoodsArr);
            }
            
        }else {
        
            completion(nil);
        }
        
    }];
}

/**
 * 一元抢购网络请求
 */
- (void)getOneSaleList:(void(^)(id))completion {
    
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIOneSaleList parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [SVProgressHUD dismiss];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
//            if ([dictData[@"flag"] isEqualToString:@"0"]) {
            
            [GoodsModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"list" : @"GoodsDetailModel"
                         };
            }];
            GoodsModel *model = [GoodsModel mj_objectWithKeyValues:dictData];
            completion(model);
//            }
            
        }
        
    }];
}

/**
 * 一元抢购中奖名单
 */
- (void)getLotteryUserList:(void(^)(id))completion {

    [self.restService afnetworkingPost:kAPILotteryUser parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            LotteryUserModel *model = [LotteryUserModel mj_objectWithKeyValues:dictData[@"list"]];
            completion(model);
        }
        
    }];
}

/**
 * 热门搜索（获取热门商品）
 */
- (void)gethotProductList:(void(^)(id))completion {
    
    [self.restService afnetworkingPost:kAPIHotSearch parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSArray *dataArr = myAfNetBlokResponeDic;
            NSMutableArray *goodsArr = [GoodsDetailModel mj_objectArrayWithKeyValuesArray:dataArr];
            completion(goodsArr);
        }
        
    }];
}

/**
 * 关键词搜索
 */
- (void)searchProductByKeywords:(NSString *)keywords completion:(void(^)(id))completion {
    
    NSDictionary *params = @{@"key":keywords};
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIKeywordSearch parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [SVProgressHUD dismiss];
        if (flag) {
            
            NSDictionary *dict = myAfNetBlokResponeDic;
            NSArray *dataArr = dict[@"list"];
            NSMutableArray *goodsArr = [GoodsDetailModel mj_objectArrayWithKeyValuesArray:dataArr];
            completion(goodsArr);
        }
        
    }];
}

/**
 * 获取限时抢购时间节点
 */
- (void)getLimitTimeBuyPeriod:(void(^)(id))completion {
    
    [self.restService afnetworkingPost:kAPILimitTime parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSArray *dataArr = myAfNetBlokResponeDic;
            NSArray *modelArr = [LimitTimeBuyModel mj_objectArrayWithKeyValuesArray:dataArr];
            completion(modelArr);
        }
        
    }];
}

/**
 * 根据限时抢购时间节点获取商品
 */
- (void)getProductByTime:(NSString *)startDate completion:(void(^)(id))completion {
    
    [SVProgressHUD show];
    NSDictionary *params = @{@"startDate":startDate};
    [self.restService afnetworkingPost:kAPILimitTimeBuyProduct parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [SVProgressHUD dismiss];
        if (flag) {
            
            NSArray *dataArr = myAfNetBlokResponeDic;
            NSArray *modelArr = [LimitBuyProductModel mj_objectArrayWithKeyValuesArray:dataArr];
            completion(modelArr);
        }
        
    }];
}

/**
 * 获取特惠商城分类
 */
- (void)getPerferenceActivity:(void(^)(id))completion {
    
    [self.restService afnetworkingPost:kAPIPerferenceActivity parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSArray *dataArr = myAfNetBlokResponeDic;
            NSArray *modelArr = [GoodsCategoryModel mj_objectArrayWithKeyValuesArray:dataArr];
            completion(modelArr);
        }
        
    }];
}

/**
 * 根据特惠商城分类获取商品
 */
- (void)getPerferenceProductList:(NSDictionary *)params completion:(void(^)(id))completion {
    
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIPerferenceProductList parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
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
