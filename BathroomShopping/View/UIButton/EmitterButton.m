

//
//  EmitterButton.m
//  BathroomShopping
//
//  Created by zzy on 12/9/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "EmitterButton.h"

@interface EmitterButton()
/** weak类型 粒子发射器 */
@property (nonatomic, weak)  CAEmitterLayer *emitterLayer;
@end

@implementation EmitterButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 配置粒子发射器方法
        [self setupEmitter];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    // 开始关键帧动画
    [self animation];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat midX = self.frame.size.width / 2;
    CGFloat midY = self.frame.size.height/ 2 ;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(midX, midY + self.centerOffset);
    self.imageView.center = CGPointMake(midX, midY - 10);
    /// 设置粒子发射器的锚点
    _emitterLayer.position = self.imageView.center;
}

- (void)setCenterOffset:(CGFloat)centerOffset {
    
    _centerOffset = centerOffset;
    [self setNeedsLayout];
}

- (void)setupEmitter {
    // 粒子使用CAEmitterCell初始化
    CAEmitterCell *emitterCell   = [CAEmitterCell emitterCell];
    // 粒子的名字,在设置喷射个数的时候会用到
    emitterCell.name             = @"emitterCell";
    // 粒子的生命周期和生命周期范围
    emitterCell.lifetime         = 0.7;
    emitterCell.lifetimeRange    = 0.3;
    // 粒子的发射速度和速度的范围
    emitterCell.velocity         = 30.00;
    emitterCell.velocityRange    = 4.00;
    // 粒子的缩放比例和缩放比例的范围
    emitterCell.scale            = 0.1;
    emitterCell.scaleRange       = 0.02;
    
    // 粒子透明度改变范围
    emitterCell.alphaRange       = 0.10;
    // 粒子透明度在生命周期中改变的速度
    emitterCell.alphaSpeed       = -1.0;
    // 设置粒子的图片
    emitterCell.contents         = (id)[UIImage imageNamed:@"Sparkle3"].CGImage;
    
    /// 初始化粒子发射器
    CAEmitterLayer *layer        = [CAEmitterLayer layer];
    // 粒子发射器的 名称
    layer.name                   = @"emitterLayer";
    // 粒子发射器的 形状(可以想象成打仗时,你需要的使用的炮的形状)
    layer.emitterShape           = kCAEmitterLayerCircle;
    // 粒子发射器 发射的模式
    layer.emitterMode            = kCAEmitterLayerOutline;
    // 粒子发射器 中的粒子 (炮要使用的炮弹)
    layer.emitterCells           = @[emitterCell];
    // 定义粒子细胞是如何被呈现到layer中的
    layer.renderMode             = kCAEmitterLayerOldestFirst;
    // 不要修剪layer的边界
    layer.masksToBounds          = NO;
    // z 轴的相对坐标 设置为-1 可以让粒子发射器layer在self.layer下面
    layer.zPosition              = -1;
    // 添加layer
    [self.layer addSublayer:layer];
    _emitterLayer = layer;
}

- (void)animation {
    // 创建关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    if (self.selected) {
        animation.values = @[@1.5 ,@0.8, @1.0,@1.2,@1.0];
        animation.duration = 0.5;
        // 粒子发射器 发射
        [self startFire];
    }else
    {
        animation.values = @[@0.8, @1.0];
        animation.duration = 0.4;
    }
    // 动画模式
    animation.calculationMode = kCAAnimationCubic;
    [self.imageView.layer addAnimation:animation forKey:@"transform.scale"];
}

- (void)startFire{
    // 每秒喷射的80个
    [self.emitterLayer setValue:@1000 forKeyPath:@"emitterCells.emitterCell.birthRate"];
    // 开始
    self.emitterLayer.beginTime = CACurrentMediaTime();
    // 执行停止
    [self performSelector:@selector(stopFire) withObject:nil afterDelay:0.1];
    
}

- (void)stopFire {
    //每秒喷射的个数0个 就意味着关闭了
    [self.emitterLayer setValue:@0 forKeyPath:@"emitterCells.emitterCell.birthRate"];
}

@end
