//
//  UIButton+Extension.h
//  BathroomShopping
//
//  Created by zzy on 9/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
/** 是否需要检查登录*/
@property(assign,nonatomic)BOOL isCheckLogin;
/** 搜索内容(辅助属性) */
@property(nonatomic,copy)NSString *searchContent;
@end
