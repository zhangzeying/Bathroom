//
//  ScrollTitleView.m
//  BathroomShopping
//
//  Created by zzy on 7/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "ScrollTitleView.h"

@interface ScrollTitleView()
/** 横线 */
@property (nonatomic, weak)UIView *indicatorView;
/** 记录选中的title */
@property(nonatomic,strong)UIButton *selectedBtn;
@end

@implementation ScrollTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)initView {

    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = [UIColor whiteColor];
    indicatorView.height = 2;
    indicatorView.y = self.height - 2;
    [self addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    CGFloat btnW = self.width / self.titleArr.count;
    CGFloat btnH = self.height;
    for (int i = 0; i < self.titleArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX = i * btnW;
        btn.frame = CGRectMake(btnX, 0, btnW, btnH);
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        //默认选中第一个
        if (i == 0) {
            
            btn.enabled = NO;
            self.selectedBtn = btn;
            [btn.titleLabel sizeToFit];
            self.indicatorView.width = btn.titleLabel.width + 20;
            self.indicatorView.centerX = btn.centerX;
        }
    }
}

#pragma mark --- UIButtonClick ---
- (void)titleClick:(UIButton *)sender {

    self.selectedBtn.enabled = YES;
    sender.enabled = NO;
    self.selectedBtn = sender;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.width = sender.titleLabel.width + 20;
        self.indicatorView.centerX = sender.centerX;
    }];
    
    if ([self.delegate respondsToSelector:@selector(scroll:)]) {
        
        [self.delegate scroll:sender.tag];
    }
    
}

- (void)setTitleArr:(NSMutableArray *)titleArr {

    _titleArr = titleArr;
    [self initView];
}

- (void)setIndex:(NSInteger)index {

    UIButton *selectBtn = self.subviews[index];
    self.selectedBtn.enabled = YES;
    selectBtn.enabled = NO;
    self.selectedBtn = selectBtn;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.width = selectBtn.titleLabel.width + 20;
        self.indicatorView.centerX = selectBtn.centerX;
    }];
}
@end
