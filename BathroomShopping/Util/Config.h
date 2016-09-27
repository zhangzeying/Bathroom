//
//  Config.h
//  BathroomShopping
//
//  Created by zzy on 7/2/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define CustomColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha: 1.0]
#define NavgationBarColor CustomColor(93, 143, 211)
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define BSNotificationCenter [NSNotificationCenter defaultCenter]
#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#endif /* Config_h */



