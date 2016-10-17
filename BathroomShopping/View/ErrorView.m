//
//  ErrorView.m
//  BathroomShopping
//
//  Created by zzy on 9/11/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "ErrorView.h"

@interface ErrorView()
{
    __weak id _target;
    SEL _action;
}
@property (nonatomic, weak)UILabel *warnLabel;
@property (nonatomic, weak)UIImageView *iconImageView;
@property (nonatomic, weak)UIButton *btn;
@end

@implementation ErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *warnLabel = [[UILabel alloc]init];
        warnLabel.textColor = [UIColor colorWithHexString:@"969696"];
        warnLabel.textAlignment = NSTextAlignmentCenter;
        warnLabel.font = [UIFont systemFontOfSize:16];

        [self addSubview:warnLabel];
        self.warnLabel = warnLabel;
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        btn.backgroundColor = NavgationBarColor;
        btn.layer.cornerRadius = 15;
        [self addSubview:btn];
        self.btn = btn;
    }
    return self;
}

- (void)layoutSubviews {

    CGFloat titleLen = [self.btnTitle boundingRectWithSize:(CGSize){MAXFLOAT,14.f} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.btn.titleLabel.font} context:nil].size.width;
    titleLen = MIN(titleLen, CGRectGetWidth(self.frame));
    CGRect rect = self.btn.frame;
    rect.size.width = titleLen + 30;
    rect.size.height = 34;
    self.btn.frame = rect;
    self.btn.center = CGPointMake(self.width / 2, self.height / 2);
    
    [self.warnLabel sizeToFit];
    self.warnLabel.frame = CGRectMake(0, CGRectGetMinY(self.btn.frame) - 16 - self.warnLabel.height, self.warnLabel.width, self.warnLabel.height);
    self.warnLabel.centerX = self.btn.centerX;
    self.iconImageView.frame = CGRectMake(0, CGRectGetMinY(self.warnLabel.frame) - 20 - self.iconImageView.height, self.iconImageView.width, self.iconImageView.height);
    self.iconImageView.centerX = self.btn.centerX;
}

- (void)setBtnTitle:(NSString *)btnTitle {

    _btnTitle = btnTitle;
    if ([btnTitle isEqualToString:@""] || btnTitle == nil) {
        
        self.btn.hidden = YES;
        
    }else {
    
        self.btn.hidden = NO;
        [self.btn setTitle:btnTitle forState:UIControlStateNormal];
        [self setNeedsLayout];
    }
    
}

- (void)setImgName:(NSString *)imgName {

    _imgName = imgName;
    UIImage *image = [UIImage imageNamed:_imgName];
    self.iconImageView.image = image;
    self.iconImageView.size = image.size;
    [self setNeedsLayout];
}

- (void)setWarnStr:(NSString *)warnStr {
    
    self.warnLabel.text = warnStr;
    [self setNeedsLayout];
}

#pragma mark - action
- (void)actionButtonClick:(UIButton *)actionButton
{
    NSAssert(_target != nil && _action != nil, @"target和action不能为空");
    IMP imp = [_target methodForSelector:_action];
    void (*func)(id, SEL, UIView *) = (void *)imp;
    func(_target, _action, self);
}

#pragma mark - action
- (void)setTarget:(id)target action:(SEL)action
{
    if (target && action) {
        _target = target ,_action = action;
    }
}
@end

