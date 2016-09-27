//
//  LoginAndRegisterService.h
//  BathroomShopping
//
//  Created by zzy on 7/30/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginAndRegisterService : NSObject
/**
 * 登录网络请求
 */
- (void)login:(NSString *)account password:(NSString *)password completion :(void(^)())completion;
- (void)registerUser:(NSString *)account password:(NSString *)password vcode:(NSString *)vcode completion:(void(^)())completion;
/**
 * 获取验证码
 */
- (void)getVerifyCode:(NSString *)phoneNo completion:(void(^)())completion;
@end
