
//
//  UIView+WarnView.m
//  BathroomShopping
//
//  Created by zzy on 10/17/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "UIView+WarnView.h"
#import "ErrorView.h"

#define ErrorViewFlag 11032

@implementation UIView (WarnView)
- (void)addWarnViewWithIcon:(NSString *)iconName positionY:(CGFloat)positionY text:(NSString *)text
{
    [self addWarnViewWithIcon:iconName positionY:positionY text:text  buttonTitle:nil target:nil action:nil];
}

- (void)addWarnViewWithIcon:(NSString *)iconName positionY:(CGFloat)positionY text:(NSString *)text buttonTitle:(NSString *)buttonTitle target:(id)target action:(SEL)action
{
    [self removeWarnView];
    ErrorView *errorV = [[ErrorView alloc]initWithFrame:CGRectMake(0, positionY, ScreenW, self.height - positionY)];
    errorV.warnStr = text;
    errorV.imgName = iconName;
    errorV.btnTitle = buttonTitle;
    [errorV setTarget:target action:action];
    errorV.tag = ErrorViewFlag;
    [self addSubview:errorV];
}

- (void)removeWarnView
{
    UIView *v = [self warnView];
    [v removeFromSuperview];
}

- (ErrorView *)warnView
{
    ErrorView *v = [self viewWithTag:ErrorViewFlag];
    return v;
}
@end
