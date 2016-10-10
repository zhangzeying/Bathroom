//
//  GoodsCollectionViewCell.m
//  BathroomShopping
//
//  Created by zzy on 7/17/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsCollectionViewCell.h"
#import "ActivityGoodsDetailModel.h"
@interface GoodsCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *goodNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@end

@implementation GoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setModel:(ActivityGoodsDetailModel *)model {
    
    _model = model;
    self.goodNameLbl.text = model.name;
    self.goodsImg.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"sys_xiao8"]];
    
}
@end
