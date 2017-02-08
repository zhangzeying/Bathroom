//
//  HotGoodsCollectionCell.m
//  BathroomShopping
//
//  Created by zzy on 7/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "HotGoodsCollectionCell.h"
#import "ActivityGoodsDetailModel.h"
#import "MallPackageModel.h"
@interface HotGoodsCollectionCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLbl;

@end

@implementation HotGoodsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderColor = CustomColor(236, 236, 236).CGColor;
    self.bgView.layer.borderWidth = 1;
    self.price.textColor = CustomColor(255, 68, 0);
    self.saleCountLbl.textColor = CustomColor(102, 102, 102);
}

- (void)setModel:(ActivityGoodsDetailModel *)model {
    
    _model = model;
    self.goodsNameLbl.text = model.name;
    
    self.goodsImage.contentMode = UIViewContentModeScaleToFill;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"sys_xiao8"]];

    self.price.text = [NSString stringWithFormat:@"￥%@",model.price];
    self.saleCountLbl.text = [NSString stringWithFormat:@"已售数量%ld",(long)model.sellCount];
}

- (void)setPackageModel:(MallPackageModel *)packageModel {
    
    _packageModel = packageModel;
    self.goodsNameLbl.text = packageModel.name;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, packageModel.picture];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"sys_xiao8"]];
    self.price.text = [NSString stringWithFormat:@"￥%.2f",packageModel.totalPrice];
    self.saleCountLbl.text = [NSString stringWithFormat:@"已售数量%ld",(long)packageModel.sellCount];
}
@end
