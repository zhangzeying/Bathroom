//
//  OrderTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderTableCell.h"
#import "OrderModel.h"
#import "OrderDetailModel.h"
static NSString *ID = @"ID";
@interface OrderTableCell()
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@end

@implementation OrderTableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.payBtn.layer.borderWidth = 0.5;
    self.scroll.backgroundColor = CustomColor(248, 248, 248);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 10;
    [super setFrame:frame];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    OrderTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithHexString:@"0xcfcfcf"].CGColor;
    return cell;
}

- (void)setModel:(OrderModel *)model {
    
    self.payMoney.text = [NSString stringWithFormat:@"实付款: ¥%.2f",model.amount];
    self.count.text = [NSString stringWithFormat:@"共%ld件商品",model.productsNum];
}

- (IBAction)payClick:(id)sender {
    
    
}

@end
