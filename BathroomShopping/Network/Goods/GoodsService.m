//
//  GoodsService.m
//  BathroomShopping
//
//  Created by zzy on 8/10/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsService.h"
#import "RestService.h"
#import "GoodsDetailModel.h"
#import "ShoppingCartModel.h"
#import "AddressModel.h"
#import "DeliveryModel.h"
#import "ShoppingCartDetailModel.h"
#import "GoodsSpecModel.h"
@interface GoodsService()
@property(nonatomic ,strong)RestService *restService;
/** <##> */
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicator;
@end

@implementation GoodsService
- (instancetype)init {
    
    if (self = [super init]) {
        
        self.restService = [RestService sharedService];
    }
    
    return self;
}

/**
 * 根据商品id获取商品详情
 */
- (void)getGoodsDetailInfo:(NSString *)goodsId completion:(void(^)(id))completion {
    
    NSDictionary *params = @{@"token":[[CommUtils sharedInstance] fetchToken]?:@""};
    
    [self.restService afnetworkingPost:kAPIGoodsDetailInfo(goodsId) parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
            
                [GoodsDetailModel mj_setupObjectClassInArray:^NSDictionary *{
                    return @{
                             @"specList" : @"GoodsSpecModel"
                             };
                }];
                
                GoodsDetailModel *model = [GoodsDetailModel mj_objectWithKeyValues:dictData[@"result"]];
                
                completion(model);
                
            }else {
                
                return;
            }
            
        }
        
    }];
}

/**
 * 获取购物车清单
 */
- (void)getCartList:(void(^)(id))completion {

    NSDictionary *params = @{@"token":[[CommUtils sharedInstance] fetchToken]?:@""};
    
    [self.restService afnetworkingPost:kAPICartList parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                
                [ShoppingCartModel mj_setupObjectClassInArray:^NSDictionary *{
                    return @{
                             @"productList" : @"ShoppingCartDetailModel"
                             };
                }];
                
                ShoppingCartModel *model = [ShoppingCartModel mj_objectWithKeyValues:dictData[@"result"]];
                
                completion(model);
                
            }else {
                
                return;
            }
            
        }
        
    }];
}

/**
 * 收藏商品
 */
- (void)likedGoods:(NSString *)goodsId completion:(void(^)())completion {
    
    NSDictionary *params = @{@"productID":goodsId,
                             @"token":[[CommUtils sharedInstance] fetchToken]};
    [self.restService afnetworkingPost:kAPILikedGoods parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                [SVProgressHUD showSuccessWithStatus:@"收藏成功！" maskType:SVProgressHUDMaskTypeBlack];
                completion();
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"收藏失败！" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }

        }
        
    }];
}

/**
 * 取消收藏商品
 */
- (void)unLikedGoods:(NSString *)goodsId completion:(void(^)())completion {
    
    NSDictionary *params = @{@"productID":goodsId,
                             @"token":[[CommUtils sharedInstance] fetchToken]};
    [self.restService afnetworkingPost:kAPIUnlikedGoods parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                [SVProgressHUD showSuccessWithStatus:@"取消收藏成功！" maskType:SVProgressHUDMaskTypeBlack];
                completion();
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"取消收藏失败！" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            
        }
        
    }];
}


/**
 * 加入购物车
 */
- (void)addCart:(NSString *)productID buyCount:(NSInteger)buyCount buySpecID:(NSString *)buySpecID completion:(void(^)())completion {
    
    NSDictionary *params = @{@"productID":productID,
                             @"buyCount":@(buyCount),
                             @"buySpecID":buySpecID,
                             @"token":[[CommUtils sharedInstance] fetchToken]};
    
    [self.restService afnetworkingPost:kAPIAddCart parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                completion();
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"加入购物车失败！" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            
        }
        
    }];
}

/**
 * 上传未登录时的购物车
 */
- (void)uploadCart:(NSString *)jsonStr completion:(void(^)())completion {
    
    NSDictionary *params = @{@"jsonArr":jsonStr,
                             @"token":[[CommUtils sharedInstance] fetchToken]};
    
    [self.restService afnetworkingPost:kAPIUploadCart parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                completion();
                
            }else {
                
//                [SVProgressHUD showErrorWithStatus:@"加入购物车失败！" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            
        }
        
    }];
}

/**
 * 删除购物车商品
 */
- (void)deleteCart:(NSDictionary *)params completion:(void(^)())completion {
    
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIDeleteCart parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [SVProgressHUD dismiss];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
            if ([dictData[@"flag"] isEqualToString:@"0"]) {
                
                completion();
                
            }
            
        }
        
    }];
}

/**
 * 更新购物车数量
 */
- (void)updateCartCount:(NSDictionary *)params completion:(void(^)())completion {
    
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIupdateCartCount parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [SVProgressHUD dismiss];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
            if ([dictData[@"flag"] isEqualToString:@"0"]) {
                
                completion();
                
            }
            
        }
        
    }];
}


/**
 * 推荐商品网络请求
 */
- (void)getRecommendGoodsList:(NSString *)code completion:(void(^)(id))completion {
    
    [self.restService afnetworkingPost:kAPIRecommendGoods(code) parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
            if ([dictData[@"flag"] isEqualToString:@"0"]) {
                
                NSDictionary *resultArr = dictData[@"result"][@"provinces"];
               
//                completion(recommendGoodsArr);
            }
            
        }
        
    }];
}

/**
 * 预约商品
 */
- (void)appointGoods:(NSDictionary *)params completion:(void(^)())completion {

    
    [self.restService afnetworkingPost:kAPIAppointGoods parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([dictData[@"retCode"] isEqualToString:@"0"]) {
                
                [SVProgressHUD showSuccessWithStatus:dictData[@"retMsg"] maskType:SVProgressHUDMaskTypeBlack];
                completion();
                
            }else {
            
                [SVProgressHUD showErrorWithStatus:dictData[@"retMsg"] maskType:SVProgressHUDMaskTypeBlack];
            }
            
        }
        
    }];

}

/**
 * 查询预约
 */
- (void)getAppointGoods:(NSString *)productID buySpecID:(NSString *)buySpecID completion:(void(^)())completion {
    
    NSDictionary *params = @{@"productID":productID,
                             @"buySpecID":buySpecID,
                             @"token":[[CommUtils sharedInstance] fetchToken]};
    [self.restService afnetworkingPost:kAPIGetAppoint parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
            if ([dictData[@"flag"] isEqualToString:@"0"]) {
                
                
            }
            
        }
        
    }];
}

/**
 * 取消预约
 */
- (void)deleteAppointGoods:(NSString *)appointId completion:(void(^)())completion {
    
    NSDictionary *params = @{@"id":appointId,
                             @"token":[[CommUtils sharedInstance] fetchToken]};
    [self.restService afnetworkingPost:kAPICancelAppoint parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
            if ([dictData[@"flag"] isEqualToString:@"0"]) {
                
                
            }
            
        }
        
    }];
    
}

/**
 * 获取省份
 */
- (void)getProvice:(void (^)(id))completion {

    [self.restService afnetworkingPost:kAPIProvince parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//操作成功
                
                NSDictionary *resultDict = dictData[@"result"];
                NSArray *proviceArr = resultDict[@"provinces"];
                NSMutableArray *provincesModelArr = [AddressModel mj_objectArrayWithKeyValuesArray:proviceArr];
                completion(provincesModelArr);
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"加载数据失败" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            
        }
        
    }];
}


/**
 * 获取省份对应的城市
 */
- (void)getCityByProvinceCode:(NSString *)provinceCode completion:(void(^)(id))completion {
    
    NSDictionary *params = @{@"provinceCode":provinceCode};
    __weak typeof (self)weakSelf = self;
    [self.restService afnetworkingPost:kAPICity parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [weakSelf.activityIndicator removeFromSuperview];
        weakSelf.activityIndicator = nil;
        if (flag) {
            
            NSArray *resultArr = myAfNetBlokResponeDic;
            NSMutableArray *cityModelArr = [AddressModel mj_objectArrayWithKeyValuesArray:resultArr];
            completion(cityModelArr);
            
        }
        
    }];
}

/**
 * 获取省份和城市对应的区
 */
- (void)getDistrictByCityCode:(NSString *)provinceCode cityCode:(NSString *)cityCode completion:(void(^)(id))completion {
    
    NSDictionary *params = @{@"provinceCode":provinceCode,
                             @"cityCode":cityCode};
    [self.restService afnetworkingPost:kAPIDistrict parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            NSDictionary *resultArr = myAfNetBlokResponeDic;
            NSMutableArray *districtModelArr = [AddressModel mj_objectArrayWithKeyValuesArray:resultArr];
            completion(districtModelArr);
            
        }
        
    }];
}

/**
 * 下订单
 */
- (void)order:(NSString *)expressCode otherRequirement:(NSString *)otherRequirement selectAddressID:(UITableView *)selectAddressID completion:(void(^)(id))completion {
    
    NSDictionary *params = @{@"expressCode":expressCode,
                             @"otherRequirement":otherRequirement,
                             @"selectAddressID":selectAddressID};
    
    [self.restService afnetworkingPost:kAPIOrder parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *resultDict = myAfNetBlokResponeDic;
            NSMutableArray *deliveryModelArr = [DeliveryModel mj_objectArrayWithKeyValuesArray:resultDict];
            completion(deliveryModelArr);
        }
        
    }];
}

/**
 * 获取配送方式
 */
- (void)getDelivery:(void(^)(id))completion {
    
    [self.restService afnetworkingPost:kAPIDelivery parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {
                
                NSMutableArray *deliveryModelArr = [DeliveryModel mj_objectArrayWithKeyValuesArray:dictData[@"result"]];
                completion(deliveryModelArr);
                
            }else {
            
                completion(nil);
            }
        }else {
        
            completion(nil);
        }
        
    }];
}


@end
