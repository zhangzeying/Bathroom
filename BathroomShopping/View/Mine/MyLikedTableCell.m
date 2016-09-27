//
//  MyLikedTableCell.m
//  BathroomShopping
//
//  Created by zzy on 9/7/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MyLikedTableCell.h"
#import "GoodsDetailModel.h"
static NSString *ID = @"myLikedTableCell";

@interface MyLikedTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *sellCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *line;
@end

@implementation MyLikedTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.line.backgroundColor = CustomColor(235, 235, 235);
    self.goodsImg.layer.borderColor = CustomColor(235, 235, 235).CGColor;
    self.goodsImg.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    
    MyLikedTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(GoodsDetailModel *)model {
    
    _model = model;
    self.goodsImg.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"sys_xiao8"]];

    self.nameLbl.text = model.name;
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@",model.nowPrice];
    self.sellCountLbl.text = [NSString stringWithFormat:@"已售数量：%ld",(long)model.sellCount];
}

@end
