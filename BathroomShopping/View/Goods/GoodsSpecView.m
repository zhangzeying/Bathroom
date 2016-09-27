

//
//  GoodsSpecView.m
//  BathroomShopping
//
//  Created by zzy on 8/22/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsSpecView.h"
#import "GoodsSpecModel.h"
// ----标签间垂直的距离----
#define distanceV 9
// ----标签水平间距----
#define distanceH 13


@interface GoodsSpecView()
@property (nonatomic, weak)UIView *bgView;
@property (nonatomic, weak)UIImageView *goodsImg;
@property (nonatomic, weak)UILabel *priceLbl;
@property (nonatomic, weak)UIButton *closeBtn;
@property (nonatomic, weak)UILabel *line;
/** <##> */
@property (nonatomic, weak)UIScrollView *scroll;
/** <##> */
@property (nonatomic, weak)UILabel *titleLbl;
/** 记录上一次选中的button */
@property(nonatomic,strong)UIButton *selectedBtn;
/** <##> */
@property (nonatomic, weak)UILabel *countLbl;
/** <##> */
@property (nonatomic, weak)UIButton *decreaseBtn;
/** <##> */
@property (nonatomic, weak)UIButton *increaseBtn;
/** <##> */
@property (nonatomic, weak)UITextField *countTxt;
/** <##> */
@property (nonatomic, weak)UIView *specBgView;

@end

@implementation GoodsSpecView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initView {

    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    
    UIImageView *goodsImg = [[UIImageView alloc]init];
    goodsImg.backgroundColor = [UIColor redColor];
    goodsImg.layer.cornerRadius = 5;
    goodsImg.layer.masksToBounds = YES;
    goodsImg.layer.borderColor = CustomColor(235, 235, 235).CGColor;
    goodsImg.layer.borderWidth = 0.5;
    [self addSubview:goodsImg];
    self.goodsImg = goodsImg;
    
    UILabel *priceLbl = [[UILabel alloc]init];
    priceLbl.textColor = [UIColor redColor];
    [bgView addSubview:priceLbl];
    self.priceLbl = priceLbl;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    self.closeBtn = closeBtn;
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = CustomColor(235, 235, 235);
    [bgView addSubview:line];
    self.line = line;
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [bgView addSubview:scroll];
    self.scroll = scroll;
    
    UIView *specBgView = [[UIView alloc]init];
    [scroll addSubview:specBgView];
    self.specBgView = specBgView;
    
    UILabel *titleLbl = [[UILabel alloc]init];
    titleLbl.text = @"选择规格";
    titleLbl.font = [UIFont systemFontOfSize:16];
    titleLbl.textColor = [UIColor darkGrayColor];
    [specBgView addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    for (int i = 0; i < self.specModelArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = CustomColor(193, 193, 193).CGColor;
        btn.layer.cornerRadius = 3;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        if (i == self.currentIndex) {
            
            [self btnClick:btn];
        }
        [specBgView addSubview:btn];
        
    }
    
    UILabel *countLbl = [[UILabel alloc]init];
    countLbl.text = @"数量";
    countLbl.font = [UIFont systemFontOfSize:16];
    countLbl.textColor = [UIColor darkGrayColor];
    [scroll addSubview:countLbl];
    self.countLbl = countLbl;

    UIButton *decreaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [decreaseBtn setBackgroundImage:[UIImage imageNamed:@"decrease_icon"] forState:UIControlStateNormal];
    [decreaseBtn addTarget:self action:@selector(decreaseClick) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:decreaseBtn];
    self.decreaseBtn = decreaseBtn;

    self.buyNumber = 1;
    UITextField *countTxt = [[UITextField alloc]init];
    countTxt.userInteractionEnabled = NO;
    countTxt.layer.borderColor = CustomColor(193, 193, 193).CGColor;
    countTxt.layer.borderWidth = 0.5;
    countTxt.textAlignment = NSTextAlignmentCenter;
    countTxt.text = @"1";
    countTxt.font = [UIFont systemFontOfSize:14];
    [scroll addSubview:countTxt];
    self.countTxt = countTxt;
    
    UIButton *increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [increaseBtn setBackgroundImage:[UIImage imageNamed:@"increase_icon"] forState:UIControlStateNormal];
    [increaseBtn addTarget:self action:@selector(increaseClick) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:increaseBtn];
    self.increaseBtn = increaseBtn;
}

- (void)layoutSubviews {

    self.bgView.frame = CGRectMake(0, 20, ScreenW, self.height - 20);
    self.goodsImg.frame = CGRectMake(15, 0, 80, 80);
    GoodsSpecModel *model = self.specModelArr[self.currentIndex];
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f",model.specPrice];
    [self.priceLbl sizeToFit];
    self.priceLbl.frame = CGRectMake(CGRectGetMaxX(self.goodsImg.frame) + 10, 20, self.priceLbl.width, self.priceLbl.height);
    self.closeBtn.frame = CGRectMake(self.width - 10 - 19, 10, 19, 19);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.goodsImg.frame) + 15 - 20, ScreenW, 0.5);
    CGFloat scrollY = CGRectGetMaxY(self.line.frame) + 15;
    self.scroll.frame = CGRectMake(0, scrollY, ScreenW, self.height - scrollY);
    [self.titleLbl sizeToFit];
    self.titleLbl.frame = CGRectMake(10, 0, self.titleLbl.width, self.titleLbl.height);
    NSInteger row = 0; //记录行数
    for (int i = 1; i < self.specBgView.subviews.count; i++) {
        
        UIButton *btn = self.specBgView.subviews[i];
        btn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        GoodsSpecModel *model = self.specModelArr[i - 1];
        NSString *str = [NSString stringWithFormat:@"%@%@",model.specColor,model.specSize];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn sizeToFit];
        CGFloat btnW = MAX(btn.frame.size.width + 15, 60);
        CGFloat btnH = btn.frame.size.height;
        CGFloat btnX;
        if (i > 1) {
            
            UIButton *lastBtn = self.specBgView.subviews[i - 1];
            btnX = CGRectGetMaxX(lastBtn.frame) + distanceH;
            
        }else {
            
            btnX = 10;
        
        }
        
        CGFloat btnY;
        //换行
        if (btnX + btnW > self.frame.size.width) {
            
            row++; //行数加一
            btnX = 10;
        }
        
        btnY = row * (distanceV + btnH) + CGRectGetMaxY(self.titleLbl.frame) + 12;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
 
    self.specBgView.frame = CGRectMake(0, 0, ScreenW, CGRectGetMaxY([self.specBgView.subviews lastObject].frame) + 3);
    
    [self.countLbl sizeToFit];
    
    self.countLbl.frame = CGRectMake(self.titleLbl.x, CGRectGetMaxY(self.specBgView.frame) + 25, self.countLbl.width, self.countLbl.height);
    
    self.increaseBtn.frame = CGRectMake(ScreenW - 10 - 30, self.countLbl.y, 30, 30);
    
    self.countTxt.frame = CGRectMake(CGRectGetMinX(self.increaseBtn.frame) - 2 - 50, self.increaseBtn.y, 50, 30);
    
    self.decreaseBtn.frame = CGRectMake(CGRectGetMinX(self.countTxt.frame) - 2 - 30, self.increaseBtn.y, 30, 30);
    
    self.scroll.contentSize = CGSizeMake(0, CGRectGetMaxY(self.countLbl.frame) + 5);
}

#pragma mark --- UIButtonClick ---
- (void)btnClick:(UIButton *)sender {

    self.selectedBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.selectedBtn.enabled = !self.selectedBtn.enabled;
    sender.layer.borderColor = [UIColor redColor].CGColor;
    self.selectedBtn = sender;
    sender.enabled = !sender.enabled;
    self.currentIndex = sender.tag;
    GoodsSpecModel *model = self.specModelArr[self.currentIndex];
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f",model.specPrice];
    
    self.buyNumber = 1;
    self.countTxt.text = @"1";
}

- (void)closeClick {

    if (self.goodsSpecViewBlock) {
        
        self.goodsSpecViewBlock();
    }
}

/**
 * 减少数量
 */
- (void)decreaseClick {

    if (self.buyNumber == 1) {
        
        return;
    }
    self.buyNumber--;
    self.countTxt.text = [NSString stringWithFormat:@"%ld",(long)self.buyNumber];
}

/**
 * 增加数量
 */
- (void)increaseClick {
    
    self.buyNumber++;
    GoodsSpecModel *model = self.specModelArr[self.currentIndex];
    //如果大于库存
    if (self.buyNumber > model.specStock) {
        
        self.buyNumber--;
        [SVProgressHUD showErrorWithStatus:@"当前商品库存不足！" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    self.countTxt.text = [NSString stringWithFormat:@"%ld",(long)self.buyNumber];
}

#pragma mark --- setter ---
- (void)setCurrentIndex:(NSInteger)currentIndex {

    _currentIndex = currentIndex;
}

- (void)setSpecModelArr:(NSMutableArray *)specModelArr {

    _specModelArr = specModelArr;
    [self initView];
    [self setNeedsLayout];
}
@end
