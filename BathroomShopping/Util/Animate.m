//
//  Animate.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "Animate.h"

@interface Animate()<CAAnimationDelegate>
/** layer */
@property(nonatomic,strong)CALayer *layer;
@end

@implementation Animate

+ (Animate *)sharedInstance {
    
    static dispatch_once_t pred;
    static Animate *instance = nil;
    dispatch_once(&pred, ^{
        
        instance = [[self alloc] init];
    });
    return instance;
}

// 动画1
+ (CATransform3D)firstStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500.0;
    transform = CATransform3DScale(transform, 0.98, 0.98, 1.0);
    transform = CATransform3DRotate(transform, 5.0 * M_PI / 180.0, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -30.0);
    return transform;
}


// 动画2
+ (CATransform3D)secondStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [self firstStepTransform].m34;
    transform = CATransform3DTranslate(transform, 0, ScreenH * -0.08, 0);
    transform = CATransform3DScale(transform, 0.8, 0.8, 1.0);
    return transform;
}

/**
 * 启动动画
 */
+ (void)startAnimation:(NSTimeInterval)timer {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGSize size = window.bounds.size;
    NSString *viewOrientation = @"Portrait";  //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, size) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame = window.bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    [window addSubview:launchView];
    
    [UIView animateWithDuration:timer
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         launchView.alpha = 0.0f;
                         launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [launchView removeFromSuperview];
                         
                     }];
}

/**
 * 加入购物车动画
 */
- (void)addCartAnimation:(CGPoint)startPoint endPoint:(CGPoint)endPoint goodsImage:(UIImageView *)goodsImage completion:(AnimationFinishBlock)completion {

    self.layer = [[CALayer alloc]init];
    self.layer.frame = CGRectMake(startPoint.x, startPoint.y, 25, 25);
    self.layer.contents = (id)goodsImage.layer.contents;
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.layer.frame.size.width / 2;
    [[[UIApplication sharedApplication] windows].lastObject.layer addSublayer:self.layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
    [path addQuadCurveToPoint:CGPointMake(endPoint.x, endPoint.y) controlPoint:CGPointMake(ScreenW / 2,ScreenH - 180)];
    
    CAKeyframeAnimation *pathAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path.CGPath;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.removedOnCompletion = YES;
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:12];
    rotateAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[pathAnimation,rotateAnimation];
    groups.duration = 1.0f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [self.layer addAnimation:groups forKey:@"group"];
    if (completion) {
        
        self.animationFinisnBlock = completion;
    }
}

#pragma mark --- 动画结束 ---
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (anim == [self.layer animationForKey:@"group"]) {
        
        [self.layer removeFromSuperlayer];
        self.layer = nil;
        if (self.animationFinisnBlock) {
            self.animationFinisnBlock();
        }
    }
    
    
}
@end
