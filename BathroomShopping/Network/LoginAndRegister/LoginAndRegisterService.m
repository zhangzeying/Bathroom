//
//  LoginAndRegisterService.m
//  BathroomShopping
//
//  Created by zzy on 7/30/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "LoginAndRegisterService.h"
#import "RestService.h"
#import "UserInfoModel.h"
#import "GoodsService.h"
#import "ShoppingCartDetailModel.h"
#import "GoodsSpecModel.h"
@interface LoginAndRegisterService()
@property(nonatomic ,strong)RestService *restService;
/** <##> */
@property(nonatomic,strong)GoodsService *goodsService;
@end

@implementation LoginAndRegisterService

- (GoodsService *)goodsService {
    
    if (_goodsService == nil) {
        
        _goodsService = [[GoodsService alloc]init];
    }
    
    return _goodsService;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.restService = [RestService sharedService];
    }
    
    return self;
}

/**
 * 登录网络请求
 */
- (void)login:(NSString *)account password:(NSString *)password completion :(void(^)())completion  {
    
    NSDictionary *parameters = @{@"account":account,
                                 @"password":password};
    
    __weak typeof (self)weakSelf = self;
    [self.restService afnetworkingPost:kAPILogin parameters:parameters completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            if ([[dictData objectForKey:@"flag"] isEqualToString:@"0"]) {//登录成功
                
                UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:dictData[@"result"]];
                [[CommUtils sharedInstance] saveUserInfo:model];
                [[CommUtils sharedInstance] saveToken:dictData[@"token"]];
                [[CommUtils sharedInstance] saveOutTime:([dictData[@"outTime"] longLongValue]) / 1000];

                NSMutableArray *cartArr = [ShoppingCartDetailModel getCartList:NO];
                if (cartArr.count > 0) {
                    
                    NSMutableArray *dataArr = @[].mutableCopy;
                    for (ShoppingCartDetailModel *model in cartArr) {
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:model.id forKey:@"productId"];
                        [dict setObject:model.buySpecInfo.id forKey:@"specId"];
                        [dict setObject:[NSNumber numberWithInteger:model.buyCount] forKey:@"buycount"];
                        [dataArr addObject:dict];
                    }
                    
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArr options:NSJSONWritingPrettyPrinted error:&error];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    
                    [weakSelf.goodsService uploadCart:jsonString completion:^{
                        
                        [ShoppingCartDetailModel deleteAllCart:NO];
                    }];
                }
                
                
                
                completion();
                
            }else {
            
                [SVProgressHUD showErrorWithStatus:@"用户名或密码不正确" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            
        }
        
    }];
    
}

/**
 * 注册网络请求
 */
- (void)registerUser:(NSString *)account password:(NSString *)password vcode:(NSString *)vcode completion:(void(^)())completion  {

    NSDictionary *parameters = @{@"tel":account,
                                 @"password":password,
                                 @"vcode":vcode};
    
    [self.restService afnetworkingPost:kAPIRegister parameters:parameters completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            NSString *statusCode = [dictData objectForKey:@"flag"];
            if ([statusCode isEqualToString:@"0"]) {//注册成功
                [SVProgressHUD showSuccessWithStatus:@"注册成功" maskType:SVProgressHUDMaskTypeBlack];
                UserInfoModel *model = [[UserInfoModel alloc]init];
                model.account = account;
                model.nickname = account;
                [[CommUtils sharedInstance] saveUserInfo:model];
                [[CommUtils sharedInstance] saveToken:dictData[@"token"]];
                [[CommUtils sharedInstance] saveOutTime:([dictData[@"outTime"] longLongValue]) / 1000];
                completion();
                
            }else if([statusCode isEqualToString:@"1"]) {
                
                [SVProgressHUD showErrorWithStatus:@"手机号不正确" maskType:SVProgressHUDMaskTypeBlack];
                return;
                
            }else if([statusCode isEqualToString:@"2"]) {
                
                [SVProgressHUD showErrorWithStatus:@"验证码不正确" maskType:SVProgressHUDMaskTypeBlack];
                return;
                
            }else if([statusCode isEqualToString:@"3"]) {
                
                [SVProgressHUD showErrorWithStatus:@"不能指定id" maskType:SVProgressHUDMaskTypeBlack];
                return;
                
            }else if([statusCode isEqualToString:@"4"]) {
                
                [SVProgressHUD showErrorWithStatus:@"密码不合法" maskType:SVProgressHUDMaskTypeBlack];
                return;
                
            }else {
            
                [SVProgressHUD showErrorWithStatus:@"注册失败" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            
            
        }
        
    }];
}

/**
 * 获取验证码
 */
- (void)getVerifyCode:(NSString *)phoneNo completion:(void(^)())completion  {
    
    NSDictionary *parameters = @{@"phoneNo":phoneNo};
    
    [self.restService afnetworkingPost:kAPIGetVerifyCode parameters:parameters completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSDictionary *dictData = myAfNetBlokResponeDic;
            NSString *statusCode = [dictData objectForKey:@"retCode"];
            
            if ([statusCode isEqualToString:@"0"]) {//注册成功
                
                [SVProgressHUD showSuccessWithStatus:[dictData objectForKey:@"retMsg"] maskType:SVProgressHUDMaskTypeBlack];
                completion();
                
            }else {
            
                [SVProgressHUD showErrorWithStatus:[dictData objectForKey:@"retMsg"] maskType:SVProgressHUDMaskTypeBlack];
            }
        }
        
    }];
}
@end
