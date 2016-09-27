//
//  AppDelegate.h
//  BathroomShopping
//
//  Created by zzy on 7/1/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KeychainItemWrapper;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) KeychainItemWrapper *keychainItemWrapper;
@end

