//
//  GoodsListTableCell.m
//  BathroomShopping
//
//  Created by zzy on 9/8/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsListTableCell.h"
#import "ShoppingCartDetailModel.h"
#import "GoodsSpecModel.h"
static NSString *ID = @"goodsListTableCell";
@interface GoodsListTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *specLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@end

@implementation GoodsListTableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.line.backgroundColor = CustomColor(235, 235, 235);
    self.lineH.constant = 0.5;
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    GoodsListTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(ShoppingCartDetailModel *)model {

    self.nameLbl.text = model.name;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f",model.nowPrice];
    self.numberLbl.text = [NSString stringWithFormat:@"×%ld",(long)model.buyCount];
    self.specLbl.text = [NSString stringWithFormat:@"%@%@",model.buySpecInfo.specColor,model.buySpecInfo.specSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
