//
//  OrderDetailGoodsTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderDetailGoodsTableCell.h"
#import "OrderDetailModel.h"
#import "MyLabel.h"
static NSString *ID = @"ID";

@interface OrderDetailGoodsTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet MyLabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLblH;

@end

@implementation OrderDetailGoodsTableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.goodsImg.layer.borderColor = CustomColor(205, 205, 205).CGColor;
    self.goodsImg.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    OrderDetailGoodsTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithHexString:@"0xcfcfcf"].CGColor;
    return cell;
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.y += 10;
    [super setFrame:frame];
}

-(void)setModel:(OrderDetailModel *)model {

    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    self.nameLbl.text = model.productName;
    self.priceLbl.text = [NSString stringWithFormat:@"¥%.2f",model.price];
    self.numLbl.text = [NSString stringWithFormat:@"×%ld",(long)model.quantity];
}
@end
