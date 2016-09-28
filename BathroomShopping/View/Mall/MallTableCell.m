//
//  MallTableCell.m
//  BathroomShopping
//
//  Created by zzy on 7/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MallTableCell.h"
#import "MallPackageModel.h"
static NSString *ID = @"mallCell";

@interface MallTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *price;
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

- (void)setModel:(MallPackageModel *)model {
    
    _model = model;
    self.goodsNameLbl.text = model.name;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    self.price.text = [NSString stringWithFormat:@"￥%.2f",model.totalPrice];
}
@end
