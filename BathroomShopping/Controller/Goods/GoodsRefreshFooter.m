//
//  GoodsRefreshFooter.m
//  BathroomShopping
//
//  Created by zzy on 8/7/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsRefreshFooter.h"

@interface GoodsRefreshFooter()
@property (weak, nonatomic) UIImageView *statusImageV;
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIView *contentView;
@end

@implementation GoodsRefreshFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    //content
    UIView *contentV = [[UIView alloc] init];
    [self addSubview:contentV];
    self.contentView = contentV;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = CustomColor(153, 153, 153);
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [contentV addSubview:label];
    self.label = label;
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"contentcomment_pulldown"];
    [contentV addSubview:imageV];
    self.statusImageV = imageV;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.statusImageV.frame = (CGRect){0,0,25,25};
    [self.label sizeToFit];
    self.label.frame = (CGRect){35,0,self.label.frame.size.width,25};
    self.contentView.frame = (CGRect){(self.frame.size.width - CGRectGetMaxX(self.label.frame))/2,13,CGRectGetMaxX(self.label.frame),25};
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.label.text = @"下拉查看全部评论";
            [UIView animateWithDuration:0.2 animations:^{
                self.statusImageV.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            break;
        }
        case MJRefreshStatePulling:
        {
            self.label.text = @"释放查看商品详情";
            [UIView animateWithDuration:0.2 animations:^{
                self.statusImageV.transform = CGAffineTransformMakeRotation(0);
            }];
            break;
        }
        case MJRefreshStateRefreshing:
            break;
        default:
            break;
    }
}
@end
