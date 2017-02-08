//
//  LoginButton.m
//  BathroomShopping
//
//  Created by zzy on 12/22/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "LoginButton.h"

@interface LoginButton()
/** <##> */
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
@end

@implementation LoginButton

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.bounds;
    
    CGFloat radius = self.bounds.size.height / 2 - 3;
    CGPoint leftArcCenter = CGPointMake(self.bounds.size.height / 2, self.bounds.size.height / 2);
    CGPoint rightArcCenter = CGPointMake(self.bounds.size.width - self.bounds.size.height / 2, self.bounds.size.height / 2);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:leftArcCenter radius:radius startAngle:M_PI / 2 endAngle:-M_PI / 2 clockwise:YES];
    [bezierPath addArcWithCenter:rightArcCenter radius:radius startAngle:-M_PI / 2 endAngle:M_PI / 2 clockwise:YES];
    [bezierPath closePath];
    
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.shapeLayer.lineWidth = 2;
    [self.layer addSublayer:_shapeLayer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

@end
