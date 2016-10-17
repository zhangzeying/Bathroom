//
//  UIView+WarnView.h
//  BathroomShopping
//
//  Created by zzy on 10/17/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ErrorView;
@interface UIView (WarnView)
- (void)addWarnViewWithIcon:(NSString *)iconName positionY:(CGFloat)positionY text:(NSString *)text;
- (void)addWarnViewWithIcon:(NSString *)iconName positionY:(CGFloat)positionY text:(NSString *)text buttonTitle:(NSString *)buttonTitle target:(id)target action:(SEL)action;
- (void)removeWarnView;
- (ErrorView *)warnView;
@end
