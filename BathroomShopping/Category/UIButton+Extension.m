
//
//  UIButton+Extension.m
//  BathroomShopping
//
//  Created by zzy on 9/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>
#import "LoginViewController.h"
static void *strKey = &strKey;
static void *strKey1 = &strKey1;
@implementation UIButton (Extension)

-(BOOL)isCheckLogin {
    NSNumber *number = objc_getAssociatedObject(self, &strKey);
    return number.boolValue;
}
- (void)setIsCheckLogin:(BOOL)isCheckLogin {
    
    NSNumber *number = [NSNumber numberWithBool:isCheckLogin];
    objc_setAssociatedObject(self, &strKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {

    if (self.isCheckLogin) {//如果需要检查登录,则拦截按钮事件
        
        if ([[CommUtils sharedInstance] fetchToken]) {
            
            [super sendAction:action to:target forEvent:event];
            
        }else {
        
            LoginViewController *loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginView];
            [[[CommUtils sharedInstance]getCurrentVC] presentViewController:loginNav animated:YES completion:nil];
        }
        
    }else {//如果不需要，则不拦截
    
        [super sendAction:action to:target forEvent:event];
    }
}

- (NSString *)searchContent {
    
    return objc_getAssociatedObject(self, strKey);
}

- (void)setSearchContent:(NSString *)searchContent {
    
    objc_setAssociatedObject(self, strKey, searchContent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
