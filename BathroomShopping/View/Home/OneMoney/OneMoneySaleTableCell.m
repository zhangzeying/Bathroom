//
//  OneMoneySaleTableCell.m
//  BathroomShopping
//
//  Created by zzy on 7/25/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OneMoneySaleTableCell.h"
#import "GoodsDetailModel.h"
#import "ShoppingCartDetailModel.h"
static NSString *ID = @"oneMoneySaleTableCell";

@interface OneMoneySaleTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *joinCount;
@property (weak, nonatomic) IBOutlet UILabel *line;
@end

@implementation OneMoneySaleTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.price.textColor = CustomColor(153, 153, 153);
    self.line.backgroundColor = CustomColor(235, 235, 235);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    OneMoneySaleTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(GoodsDetailModel *)model {

    _model = model;
    self.goodsImg.contentMode = UIViewContentModeScaleAspectFit;
    UserInfoModel *userModel = [[CommUtils sharedInstance] fetchUserInfo];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"sys_xiao8"]];
    self.nameLbl.text = model.name;
    self.nowPrice.text = [NSString stringWithFormat:@"￥%@",model.nowPrice];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",model.price]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.price.attributedText = newPrice;
    self.joinCount.text = [NSString stringWithFormat:@"已有%ld人参与",(long)model.partNumber];
}

/**
 * 抽奖
 */
- (IBAction)lotteryClick:(id)sender {
    
    if (self.lotteryBlock) {
        
        ShoppingCartDetailModel *cartModel = [[ShoppingCartDetailModel alloc]init];
        cartModel.name = self.model.name;
        cartModel.picture = self.model.picture;
        cartModel.buyCount = 1;
        cartModel.nowPrice = [self.model.nowPrice doubleValue];
        cartModel.id = self.model.id;
        self.lotteryBlock(cartModel);
    }
}

@end
