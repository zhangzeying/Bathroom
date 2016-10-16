//
//  OrderDetailGoodsTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderDetailGoodsTableCell.h"

static NSString *ID = @"ID";

@interface OrderDetailGoodsTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UILabel *specLbl;

@end

@implementation OrderDetailGoodsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
@end
