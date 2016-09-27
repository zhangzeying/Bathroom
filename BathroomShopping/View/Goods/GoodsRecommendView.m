//
//  GoodsRecommendView.m
//  BathroomShopping
//
//  Created by zzy on 8/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsRecommendView.h"
#import "GoodsDetailModel.h"

@interface GoodsRecommendView()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end

@implementation GoodsRecommendView

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

+ (GoodsRecommendView *)instanceView {
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}

- (void)setModel:(GoodsDetailModel *)model {
    
    _model = model;
    self.nameLbl.text = model.name;
    __weak typeof (self)weakSelf = self;
    __block NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        weakSelf.goodsImg.contentMode = UIViewContentModeScaleAspectFit;
    });
    self.price.text = [NSString stringWithFormat:@"￥%@",model.price];
}
@end
