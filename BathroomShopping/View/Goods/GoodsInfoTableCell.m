//
//  GoodsInfoTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsInfoTableCell.h"
#import "GoodsDetailModel.h"

static NSString *ID = @"goodsInfoTableCell";
@interface GoodsInfoTableCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *likedCountLbl;
@end

@implementation GoodsInfoTableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    GoodsInfoTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(GoodsDetailModel *)model {

    _model = model;
    self.nameLbl.text = model.name;
    self.price.text = model.price;
    self.saleCountLbl.text = [NSString stringWithFormat:@"销量:%ld",(long)model.sellCount];
    self.likedCountLbl.text = [NSString stringWithFormat:@"收藏数:%ld",(long)model.favCount];
    [self layoutIfNeeded];
    model.cellHeight = CGRectGetMaxY(self.likedCountLbl.frame) + 20;
    
}

- (void)setFrame:(CGRect)frame {

    frame.size.height -= 10;
    [super setFrame:frame];
}
@end
