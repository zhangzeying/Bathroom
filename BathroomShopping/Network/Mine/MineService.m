//
//  MineService.m
//  BathroomShopping
//
//  Created by zzy on 8/19/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MineService.h"
#import "RestService.h"
#import "ReceiverAddressModel.h"
#import "GoodsDetailModel.h"
#import "AppointModel.h"
#import "UserInfoModel.h"
#import "AppointDetailModel.h"
@interface MineService()
@property(nonatomic ,strong)RestService *restService;
@end

@implementation MineService
- (instancetype)init {
    
    if (self = [super init]) {
        
        self.restService = [RestService sharedService];
    }
    
    return self;
}

/**
 * 上传头像
 */
- (void)uploadAvator:(UIImage *)headPortrait completion :(void(^)(id))completion {
    
    
    NSDictionary *parameters = @{@"token":[[CommUtils sharedInstance] fetchToken]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:kAPIUploadAvator parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(headPortrait,0.1);
        [formData appendPartWithFileData:imageData name:@"image" fileName:[NSString stringWithFormat:@"image.jpg"] mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        BSLog(@"%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"上传成功" maskType:SVProgressHUDMaskTypeBlack];
        NSDictionary *dictData = responseObject;
        BSLog(@"%@",dictData);
        if ([[dictData objectForKey:@"error"] integerValue] == 0) {//成功
            
            NSString *avatorUrl = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"result"]];
            completion(avatorUrl);
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"上传失败！" maskType:SVProgressHUDMaskTypeBlack];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"上传失败！" maskType:SVProgressHUDMaskTypeBlack];
        BSLog(@"%@",error);
    }];
}

/**
 * 修改个人信息
 */
- (void)updateUserInfo:(NSString *)nickname completion :(void(^)())completion {

    
        NSDictionary *parameters = @{@"nickname":nickname,
                                     @"token":[[CommUtils sharedInstance] fetchToken]};
    
        [self.restService afnetworkingPost:kAPIUpdateUserInfo parameters:parameters completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
            if (flag) {
    
                NSDictionary *dictData = myAfNetBlokResponeDic;
        
                if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//成功
    
                    [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
                    completion();
    
                }else {
    
                    [SVProgressHUD showErrorWithStatus:@"修改失败！" maskType:SVProgressHUDMaskTypeBlack];
                    return;
                }
                
            }
            
        }];
}


/**
 * 获取我的地址
 */
- (void)getAddressList:(void(^)(id))completion {
    
    
    NSDictionary *parameters = @{@"token":[[CommUtils sharedInstance] fetchToken]};
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIAddressList parameters:parameters completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [SVProgressHUD dismiss];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//成功
                
                NSMutableArray *modelArr = [ReceiverAddressModel mj_objectArrayWithKeyValuesArray:dictData[@"result"][@"addressList"]];
                completion(modelArr);
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"获取地址失败！" maskType:SVProgressHUDMaskTypeBlack];
                completion(nil);
                return;
            }
            
        }else {
        
            completion(nil);
        }
        
    }];
}

/**
 * 保存地址
 */
- (void)saveAddress:(NSDictionary *)param completion:(void(^)())completion {
    
    
    [self.restService afnetworkingPost:kAPISaveAddress parameters:param completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//成功
                
                completion();
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"获取地址失败！" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            
            
        }
        
    }];
}

/**
 * 删除地址
 */
- (void)deleteAddress:(NSString *)addressId completion:(void(^)())completion {
    
    NSDictionary *parameters = @{@"id":addressId,
                                 @"token":[[CommUtils sharedInstance] fetchToken]};
    
    [self.restService afnetworkingPost:kAPIDeleteAddress parameters:parameters completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//成功
                
                completion();
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"获取地址失败！" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            
        }
        
    }];
}

/**
 * 修改密码
 */
- (void)updatePassword:(NSDictionary *)params completion:(void(^)())completion {
    
    [self.restService afnetworkingPost:kAPIUpdatePwd parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//成功
                
                [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
                completion();
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"修改失败！" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            
        }
        
    }];
}

/**
 * 获取我的收藏
 */
- (void)getLikedGoodsList:(void(^)(id))completion {
    
    
    NSDictionary *parameters = @{@"token":[[CommUtils sharedInstance] fetchToken]};
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIGetLikedGoodsList parameters:parameters completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [SVProgressHUD dismiss];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//成功
                
                NSMutableArray *modelArr = [NSMutableArray array];
                for (NSDictionary *dict in dictData[@"result"][@"list"]) {
                    
                    
                    GoodsDetailModel *model = [GoodsDetailModel mj_objectWithKeyValues:dict[@"product"]];
                    [modelArr addObject:model];
                }
                completion(modelArr);
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"获取我的收藏失败！" maskType:SVProgressHUDMaskTypeBlack];
                completion(nil);
                return;
            }
            
        }else {
            
            completion(nil);
        }
        
    }];
}

/**
 * 获取商品预约
 */
- (void)getAppointList:(void(^)(id))completion {
    
    
    NSDictionary *parameters = @{@"token":[[CommUtils sharedInstance] fetchToken]};
    [SVProgressHUD show];
    [self.restService afnetworkingPost:kAPIGetAppoint parameters:parameters completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        [SVProgressHUD dismiss];
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//成功
                
                NSArray *dataArr = dictData[@"result"];
                NSMutableArray *modelArr = [AppointModel mj_objectArrayWithKeyValuesArray:dataArr];
                for (AppointModel *model in modelArr) {
                    
                    model.detailModel = [AppointDetailModel mj_objectWithKeyValues:model.product];
                }
                completion(modelArr);
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"获取我的预约失败！" maskType:SVProgressHUDMaskTypeBlack];
                completion(nil);
                return;
            }
            
        }else {
            
            completion(nil);
        }
        
    }];
}

/**
 * 获取用户权限
 */
- (void)getUserRoot {
    
    NSDictionary *parameters = @{@"token":[[CommUtils sharedInstance] fetchToken]};
    [self.restService afnetworkingPost:kAPIGetUserRoot parameters:parameters completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            BOOL isShow = [dictData[@"result"] boolValue];
            UserInfoModel *model = [[CommUtils sharedInstance] fetchUserInfo];
            if (model.isshow != isShow) {//若果权限发生变化
                
                model.isshow = isShow;
                [[CommUtils sharedInstance]saveUserInfo:model];
            }
            
        }
        
    }];
}

/**
 * 获取关于我们公司介绍
 */
- (void)getAboutContent:(void(^)(id))completion {
    
    [self.restService afnetworkingPost:kAPIGetAboutContent parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
             NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([dictData[@"retCode"] isEqualToString:@"0"]) {
                
                NSString *content = dictData[@"aboutOurs"][@"content"];
                completion(content);
            }
        }
        
    }];
}

@end
