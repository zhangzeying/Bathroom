//
//  CommUtils.m
//  BathroomShopping
//
//  Created by zzy on 7/30/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "CommUtils.h"
#import "KeychainItemWrapper.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"

@interface CommUtils()
@property(nonatomic,retain)dispatch_source_t timer;
@end

@implementation CommUtils
+ (CommUtils *)sharedInstance {
    static dispatch_once_t pred;
    static CommUtils *instance = nil;
    dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    return instance;
}

/**
 * 用户是否登录
 */
- (BOOL)isLogin {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    if ([self fetchToken].length > 0) {
        
        return YES;
        
    } else {
        
        [setting removeObjectForKey:@"token"];
        [setting synchronize];
        return NO;
    }
}

/**
 * 获取token
 */
- (NSString *)fetchToken {

    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:@"token"];
}

/**
 * 保存token
 */
- (void)saveToken:(NSString *)token {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:token forKey:@"token"];
}

/**
 * 移除token
 */
- (void)removeToken {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"token"];
    [setting synchronize];
}

/**
 * 获取token失效日期
 */
- (long long)fetchOutTime {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [[setting objectForKey:@"outTime"] longLongValue];
}

/**
 * 保存token失效日期
 */
- (void)saveOutTime:(long long)outTime {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:[NSNumber numberWithLongLong:outTime] forKey:@"outTime"];
}

/**
 * 获取购物车token
 */
- (NSString *)fetchCartToken {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:@"cartToken"];
}

/**
 * 保存购物车token
 */
- (void)saveCartToken:(NSString *)token {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:token forKey:@"cartToken"];
}

/**
 * 获取用户信息
 */
- (UserInfoModel *)fetchUserInfo {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    UserInfoModel *model = [[UserInfoModel alloc]init];
    model.account = [setting objectForKey:@"account"];
    model.nickname = [setting objectForKey:@"nickname"];
    model.tel = [setting objectForKey:@"tel"];
    model.headPortrait = [setting objectForKey:@"avatorUrl"];
    model.isshow = [[setting objectForKey:@"isshow"] boolValue];
    return model;
}

/**
 * 保存用户信息
 */
- (void)saveUserInfo:(UserInfoModel *)model {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    
    [setting setObject:model.account forKey:@"account"];
    
    [setting setObject:model.nickname forKey:@"nickname"];
    
    [setting setObject:model.tel forKey:@"tel"];
    
    [setting setObject:model.headPortrait forKey:@"avatorUrl"];
    
    [setting setObject:[NSNumber numberWithBool:model.isshow] forKey:@"isshow"];
    
    [setting synchronize];
}

/**
 * 移除保存的登录用户信息
 */
- (void)removeUserInfo {

    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"nickname"];
    [setting removeObjectForKey:@"tel"];
    [setting removeObjectForKey:@"avatorUrl"];
    [setting removeObjectForKey:@"outTime"];
    [setting removeObjectForKey:@"isshow"];
    [setting synchronize];
}

#pragma mark --- 保存到keychain中 ---
- (void)saveAutoInfo:(NSString *)autoToken autoName:(NSString *)autoName autoPassword:(NSString *)autoPassword {
    
    AppDelegate *appDelegate = kAppDelegate;
    [appDelegate.keychainItemWrapper setObject:autoName forKey:(id)kSecAttrAccount];
    [appDelegate.keychainItemWrapper setObject:autoPassword forKey:(id)kSecValueData];
}

- (NSString *)fetchAutoName {
    
    AppDelegate *appDelegate = kAppDelegate;
    NSString *name = [appDelegate.keychainItemWrapper objectForKey:(id)kSecAttrAccount];
    return name ? : @"";
}

- (NSString *)fetchAutoPassword {
    
    AppDelegate *appDelegate = kAppDelegate;
    NSString *password = [appDelegate.keychainItemWrapper objectForKey:(id)kSecValueData];
    return password ? : @"";
}

#pragma mark 判断手机号
- (BOOL)checkPhoneNum:(NSString *)phoneNum {
    //手机号以13， 15，14 18开头，八个 \d 数字字符
    NSString *regex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|([1][7][8])|(18[0,0-9]))\\d{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileTest evaluateWithObject:phoneNum];
}

/**
 * 计时器
 */
- (void)countDownWithPER_SECBlock:(void (^)())PER_SECBlock{
    
    if (_timer == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                PER_SECBlock();
            });
        });
        dispatch_resume(_timer);
    }
}

/**
 * nsstring转nsdate
 */
- (NSDate *)dateFromString:(NSString *)dateString {
    
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date = [formatter dateFromString:dateString];
    return date;
    
}

/**
 * 销毁定时器
 */
- (void)destoryTimer{
    
    if (_timer) {
        
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

/**
 * 获取当前屏幕显示的viewcontroller
 */
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

/*
 ** 获取当前最顶层的ViewController
 */
- (UIViewController *)topViewController {
    
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end
