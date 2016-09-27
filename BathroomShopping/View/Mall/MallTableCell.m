//
//  MallTableCell.m
//  BathroomShopping
//
//  Created by zzy on 7/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MallTableCell.h"
#import "ActivityGoodsDetailModel.h"
static NSString *ID = @"mallCell";

@interface MallTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLbl;
@end

@implementation MallTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    MallTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(ActivityGoodsDetailModel *)model {
    
    _model = model;
    self.goodsNameLbl.text = model.name;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
//    self.goodsImg.contentMode = UIViewContentModeScaleAspectFit;
    self.price.text = [NSString stringWithFormat:@"￥%@",model.price];
    self.saleCountLbl.text = [NSString stringWithFormat:@"已售数量%ld",(long)model.sellCount];
}
@end
