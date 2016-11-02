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
#import "PackageDetailModel.h"
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

+ (GoodsService *)sharedInstance {
    
    static GoodsService *_sharedService = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedService = [[self alloc] init];
        
    });
    
    return _sharedService;
}

/**
 * 根据商品id获取商品详情
 */
- (void)getGoodsDetailInfo:(NSString *)goodsId completion:(void(^)(id))completion {
    
    NSDictionary *params = @{@"token":[[CommUtils sharedInstance] fetchToken]?:@""};
    [MBProgressHUD showMessage:@"加载中....."];
    [self.restService afnetworkingPost:kAPIGoodsDetailInfo(goodsId) parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [MBProgressHUD hideHUD];
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
 * 根据套餐id获取套餐详情
 */
- (void)getPackageDetailInfo:(NSString *)packageId completion:(void(^)(id))completion {
    
    NSDictionary *params = @{@"id":packageId};
    [MBProgressHUD showMessage:@"加载中....."];
    [self.restService afnetworkingPost:kAPIPackageDetail parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [MBProgressHUD hideHUD];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            [PackageDetailModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"specAllList" : @"PackageSpecModel"
                         };
            }];
            
            
            PackageDetailModel *model = [PackageDetailModel mj_objectWithKeyValues:dictData];

            completion(model);
            
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
                
                [ShoppingCartDetailModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{
                             @"packageId" : @"id",
                             @"productIds" : @"prodIds"
                             };
                }];
                
                ShoppingCartModel *model = [ShoppingCartModel mj_objectWithKeyValues:dictData[@"result"]];
                
                model.pgCartList = [ShoppingCartDetailModel mj_objectArrayWithKeyValuesArray:dictData[@"pgCartList"]];
                
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
- (void)addCart:(NSDictionary *)params goodsType:(NSString *)goodsType completion:(void(^)())completion {
    
    NSString *url = [goodsType isEqualToString:@"0"] ? kAPIAddCart : kAPIAddCartForPackage;
    [self.restService afnetworkingPost:url parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            NSString *flag = [goodsType isEqualToString:@"0"] ? [dictData objectForKey:@"flag"] : [dictData objectForKey:@"retCode"];
            if ([flag isEqualToString:@"0"]) {//操作成功
                
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
- (void)deleteCart:(NSDictionary *)params completion:(void(^)(BOOL))completion {
    
    [self.restService afnetworkingPost:kAPIDeleteCart parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
       
        BOOL isSuccess = NO;
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([dictData[@"flag"] isEqualToString:@"0"]) {
        
                isSuccess = YES;
            }
        }
        
        completion(isSuccess);
        
    }];
}

/**
 * 删除购物车套餐
 */
- (void)deletePackageCart:(NSDictionary *)params completion:(void(^)(BOOL))completion {
    
    [self.restService afnetworkingPost:kAPIDeletePackageCart parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        BOOL isSuccess = NO;
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([dictData[@"retCode"] isEqualToString:@"0"]) {
                
                isSuccess = YES;
            }
        }
        
        completion(isSuccess);
        
    }];
}

/**
 * 更新购物车数量
 */
- (void)updateCartCount:(NSDictionary *)params completion:(void(^)())completion {
    
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIUpdateCartCount parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
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
 * 更新购物车套餐数量
 */
- (void)updatePackageCartCount:(NSDictionary *)params completion:(void(^)())completion {
    
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIUpdatePackageCartCount parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [SVProgressHUD dismiss];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BSLog(@"%@",dictData);
            if ([dictData[@"retCode"] isEqualToString:@"0"]) {
                
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
