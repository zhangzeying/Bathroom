//
//  ActivityGoodsCollectionCell.m
//  BathroomShopping
//
//  Created by zzy on 7/23/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "ActivityGoodsCollectionCell.h"
#import "ActivityGoodsDetailModel.h"
@interface ActivityGoodsCollectionCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *oneMoneyLbl;

@end

@implementation ActivityGoodsCollectionCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.nowPrice.textColor = CustomColor(255, 68, 0);
    self.price.textColor = CustomColor(153, 153, 153);
    self.bgView.layer.borderColor = CustomColor(236, 236, 236).CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (void)setModel:(ActivityGoodsDetailModel *)model {

    _model = model;
    if (model.activityType == Perference) {
        
        
    }else if (model.activityType == OneYuan) {
        
        self.oneMoneyLbl.hidden = NO;

    }else if (model.activityType == Buy) {
        
        
    }
    self.goodsNameLbl.text = model.name;
    self.price.text = [NSString stringWithFormat:@"原价¥%@",model.price];
    self.nowPrice.text = [NSString stringWithFormat:@"¥%@",model.nowPrice];

    self.goodsImg.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"sys_xiao8"]];
}
@end
