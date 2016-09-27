//
//  ShoppingCartCellTableViewCell.m
//  BathroomShopping
//
//  Created by zzy on 7/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "ShoppingCartCellTableViewCell.h"
#import "ShoppingCartModel.h"
#import "ShoppingCartDetailModel.h"
#import "GoodsSpecModel.h"
#import "GoodsService.h"
@interface ShoppingCartCellTableViewCell()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *splitLine;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *buyCount;
@property (weak, nonatomic) IBOutlet UILabel *specLbl;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
/** 网络请求对象 */
@property(nonatomic,strong)GoodsService *service;
@end

@implementation ShoppingCartCellTableViewCell

- (GoodsService *)service {
    
    if (_service == nil) {
        
        _service = [[GoodsService alloc]init];
    }
    return _service;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitLine.backgroundColor = CustomColor(235, 235, 235);
    [self.checkBox setBackgroundImage:[UIImage imageNamed:@"select_icon"] forState:UIControlStateSelected];
    [self.checkBox setBackgroundImage:[UIImage imageNamed:@"not_select_icon"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    self.checkBox.selected = self.detailModel.isChecked;
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    static NSString *ID = @"shoppingCartCell";
    ShoppingCartCellTableViewCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 * 删除按钮点击事件
 */
- (IBAction)deleteClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(cartDelete:model:)]) {
        
        [self.delegate cartDelete:self model:self.detailModel];
    }
}

/**
 * 增加按钮点击事件
 */
- (IBAction)increaseClick:(id)sender {

    
    //如果大于库存
    if (self.detailModel.buyCount + 1 > self.detailModel.buySpecInfo.specStock) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"当前商品库存不足，是否需要预约商品？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    if ([[CommUtils sharedInstance] isLogin]) {
        
        NSDictionary *param = @{@"productID":self.detailModel.id,
                                @"buySpecID":self.detailModel.buySpecInfo.id,
                                @"buyCount":@(self.detailModel.buyCount + 1),
                                @"token":[[CommUtils sharedInstance] fetchToken]};
        
        __weak typeof (self)weakSelf = self;
        [self.service updateCartCount:param completion:^{
            
            weakSelf.detailModel.buyCount++;
            weakSelf.buyCount.text = [NSString stringWithFormat:@"%ld",(long)weakSelf.detailModel.buyCount];
            if ([weakSelf.delegate respondsToSelector:@selector(changeBuyCount)]) {
                
                [weakSelf.delegate changeBuyCount];
            }
            
        }];
        
    }else {
    
        self.detailModel.buyCount++;
        self.buyCount.text = [NSString stringWithFormat:@"%ld",(long)self.detailModel.buyCount];
        if ([self.delegate respondsToSelector:@selector(changeBuyCount)]) {
            
            [self.delegate changeBuyCount];
        }
    }
}

/**
 * 减少按钮点击事件
 */
- (IBAction)decreaseClick:(id)sender {
    
    if (self.detailModel.buyCount == 1) {
        
        return;
    }
    
    if ([[CommUtils sharedInstance] isLogin]) {
        
        NSDictionary *param = @{@"productID":self.detailModel.id,
                                @"buySpecID":self.detailModel.buySpecInfo.id,
                                @"buyCount":@(self.detailModel.buyCount - 1),
                                @"token":[[CommUtils sharedInstance] fetchToken]};
        
        __weak typeof (self)weakSelf = self;
        [self.service updateCartCount:param completion:^{
            
            weakSelf.detailModel.buyCount--;
            weakSelf.buyCount.text = [NSString stringWithFormat:@"%ld",(long)weakSelf.detailModel.buyCount];
            if ([weakSelf.delegate respondsToSelector:@selector(changeBuyCount)]) {
                
                [weakSelf.delegate changeBuyCount];
            }
            
        }];
        
    }else {
    
        self.detailModel.buyCount--;
        self.buyCount.text = [NSString stringWithFormat:@"%ld",(long)self.detailModel.buyCount];
        if ([self.delegate respondsToSelector:@selector(changeBuyCount)]) {
            
            [self.delegate changeBuyCount];
        }
    }
    
    
}

/**
 * checkbox点击事件
 */
- (IBAction)checkClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.detailModel.isChecked = !self.detailModel.isChecked;
    if ([self.delegate respondsToSelector:@selector(check:)]) {
        [self.delegate check:self.detailModel];
    }
}

#pragma mark --- UIAlertViewDelegate ---
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        if ([self.delegate respondsToSelector:@selector(appoint:)]) {
            
            [self.delegate appoint:self.detailModel];
        }
    }
}

#pragma mark --- setter ---
- (void)setDetailModel:(ShoppingCartDetailModel *)detailModel {
    
    _detailModel = detailModel;
    self.nameLbl.text = detailModel.name;
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, detailModel.picture];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f",detailModel.nowPrice];
    self.buyCount.text = [NSString stringWithFormat:@"%ld",(long)detailModel.buyCount];
    self.specLbl.text = [NSString stringWithFormat:@"%@%@",detailModel.buySpecInfo.specColor,detailModel.buySpecInfo.specSize];
}
@end
