//
//  AppDelegate.m
//  BathroomShopping
//
//  Created by zzy on 7/1/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeTabBarController.h"
#import "KeychainItemWrapper.h"
#import "UserInfoModel.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate+Notification.h"
#import "MineService.h"
#import <Bugly/Bugly.h>
@interface AppDelegate ()<WXApiDelegate>
/** <##> */
@property(nonatomic,strong)MineService *mineService;
@end

@implementation AppDelegate

- (MineService *)mineService {
    
    if (_mineService == nil) {
        
        _mineService = [[MineService alloc]init];
    }
    
    return _mineService;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initApp];
    [self initSDK];
    [self initBPush:application didFinishLaunchingWithOptions:launchOptions];
    [self buildKeyWindow];
    
    if ([[CommUtils sharedInstance] isLogin]) {
        
        [self.mineService getUserRoot];
    }
    
    return YES;
}

- (void)buildKeyWindow {

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    HomeTabBarController *loginVC = [[HomeTabBarController alloc]init];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
}

- (void)initApp {

#ifdef BSDEBUG
    NSString *identifier = @"com.zzy.bathroomshopping.debug";
#else
    NSString *identifier = @"com.zzy.bathroomshopping";
#endif
    self.keychainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attrs forState:UIControlStateNormal];
}

- (void)initSDK {

    [WXApi registerApp:@"wx27dbe9481138283a"];
    [Bugly startWithAppId:@"900054413"];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSInteger resultCode = [[resultDic objectForKey:@"resultStatus"] integerValue];
            switch (resultCode) {
                    //支付成功
                case 9000:
                    
                    break;
                    
                    //支付失败
                case 4000:
                    
                    break;
                    
                    //支付正在处理中
                case 8000:
                    
                    break;
                    
                default:
                    break;
            }
        }];
        return YES;
    }
    
    else {
        
//        ([url.host isEqualToString:@"pay"])

        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSInteger resultCode = [[resultDic objectForKey:@"resultStatus"] integerValue];
            switch (resultCode) {
                    //支付成功
                case 9000:
                    
                    break;
                    
                    //支付失败
                case 4000:
                    
                    break;
                    
                    //支付正在处理中
                case 8000:
                    break;
                    
                default:
                    break;
            }
        }];
        
        return YES;
    }
    
    else {
        
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if ([[CommUtils sharedInstance] fetchToken]) {
        
        long long outTime = [[CommUtils sharedInstance] fetchOutTime];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        long long currentDateSp = [date timeIntervalSince1970];
        if (outTime < currentDateSp) {
            
            [[CommUtils sharedInstance] removeUserInfo];
            [[CommUtils sharedInstance] removeToken];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginStateChange" object:nil];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
