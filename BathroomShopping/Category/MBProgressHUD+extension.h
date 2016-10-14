//
//  MBProgressHUD+extension.h
//  BathroomShopping
//
//  Created by zzy on 9/19/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (extension)
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

+ (void)showNetErrorHUD:(UIView*)view;
@end
