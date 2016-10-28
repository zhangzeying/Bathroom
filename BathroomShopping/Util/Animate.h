//
//  Animate.h
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^AnimationFinishBlock)();
@interface Animate : NSObject

@property (copy , nonatomic)AnimationFinishBlock animationFinisnBlock;
+ (Animate *)sharedInstance;
/**
 * 启动动画
 */
+ (void)startAnimation:(NSTimeInterval)timer;
/**
 * 加入购物车动画
 */
- (void)addCartAnimation:(CGPoint)startPoint endPoint:(CGPoint)endPoint goodsImage:(UIImageView *)goodsImage completion:(AnimationFinishBlock)completion;
// 动画1
+ (CATransform3D)firstStepTransform;
// 动画2
+ (CATransform3D)secondStepTransform;
@end
