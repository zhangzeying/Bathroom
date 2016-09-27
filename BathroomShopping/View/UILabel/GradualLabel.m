//
//  GradualLabel.m
//  BathroomShopping
//
//  Created by zzy on 9/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GradualLabel.h"

@implementation GradualLabel

- (void)drawRect:(CGRect)rect {
    // 1.绘制文字
    [super drawRect:rect];
    
    rect.size.width *= self.colorRatio;
    // 2.设置颜色
    [self.blendColor set];
    
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

- (void)setColorRatio:(CGFloat)colorRatio {
    
    _colorRatio = colorRatio;
    
    [self setNeedsDisplay];
}
@end
