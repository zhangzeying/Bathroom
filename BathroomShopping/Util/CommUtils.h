//
//  CommUtils.h
//  BathroomShopping
//
//  Created by zzy on 7/30/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfoModel;

@interface CommUtils : NSObject
+ (CommUtils *)sharedInstance;
/**
 * 用户是否登录
 */
- (BOOL)isLogin;

- (NSString *)fetchAutoName;

- (NSString *)fetchAutoPassword;

/**
 * 获取token
 */
- (NSString *)fetchToken;

/**
 * 获取购物车token
 */
- (NSString *)fetchCartToken;

/**
 * 保存token
 */
- (void)saveToken:(NSString *)token;
/**
 * 移除token
 */
- (void)removeToken;

/**
 * 获取token失效日期
 */
- (long long)fetchOutTime;

/**
 * 保存token失效日期
 */
- (void)saveOutTime:(long long)outTime;

/**
 * 保存购物车token
 */
- (void)saveCartToken:(NSString *)token;

/**
 * 保存用户信息
 */
- (void)saveUserInfo:(UserInfoModel *)model;

/**
 * 获取用户信息
 */
- (UserInfoModel *)fetchUserInfo;

/**
 * 移除保存的登录用户信息
 */
- (void)removeUserInfo;


- (void)saveAutoInfo:(NSString *)autoToken autoName:(NSString *)autoName autoPassword:(NSString *)autoPassword;
/**
 * 检测手机号
 */
- (BOOL)checkPhoneNum:(NSString *)phoneNum;

/**
 * 销毁定时器
 */
- (void)destoryTimer;

/**
 * nsstring转nsdate
 */
- (NSDate *)dateFromString:(NSString *)dateString;

/**
 * 计时器
 */
-(void)countDownWithPER_SECBlock:(void (^)())PER_SECBlock;

/**
 * 获取当前屏幕显示的viewcontroller
 */
- (UIViewController *)getCurrentVC;
@end
