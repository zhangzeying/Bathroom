//
//  ShoppingCartFooterView.m
//  BathroomShopping
//
//  Created by zzy on 7/15/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "ShoppingCartFooterView.h"
#import "ShoppingCartModel.h"
#import "ShoppingCartDetailModel.h"
@interface ShoppingCartFooterView()

@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UIButton *calculateBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;

@end

@implementation ShoppingCartFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.line.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
    [self.checkBox setBackgroundImage:[UIImage imageNamed:@"select_icon"] forState:UIControlStateSelected];
    [self.checkBox setBackgroundImage:[UIImage imageNamed:@"not_select_icon"] forState:UIControlStateNormal];
}

+ (ShoppingCartFooterView *)instanceFooterView {
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}

- (IBAction)calculateClick:(id)sender {
   
    if (self.calculateBlock) {
        
        self.calculateBlock();
    }
}

/**
 * 全选or全不选
 */
- (IBAction)checkBoxClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (self.checkBlock) {
        
        self.checkBlock(sender.selected);
    }
}

- (void)setModel:(ShoppingCartModel *)model {

    _model = model;
}

- (void)setIsEditing:(BOOL)isEditing {

    self.totalPrice.hidden = isEditing;
    self.totalLbl.hidden = isEditing;
    if (!isEditing) {
        
        [self.calculateBtn setTitle:@"结算" forState:UIControlStateNormal];
        
    }else {
    
        [self.calculateBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
}

- (void)setTotalMoney:(double)totalMoney {

    self.totalPrice.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
}
@end
