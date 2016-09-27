//
//  OneMoneySaleHeaderView.m
//  BathroomShopping
//
//  Created by zzy on 7/25/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OneMoneySaleHeaderView.h"

@interface OneMoneySaleHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *rmb;

@end

@implementation OneMoneySaleHeaderView

- (void)awakeFromNib {

    self.goodsName.textColor = CustomColor(91, 53, 30);
    self.rmb.textColor = CustomColor(91, 53, 30);
    self.buyBtn.layer.cornerRadius = 10;
    CGSize size = [self.buyBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self.buyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
    [self.buyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, size.width, 0, -size.width)];
//    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",self.price.text]];
//    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
//    self.price.attributedText = newPrice;
}

+ (OneMoneySaleHeaderView *)instanceHeaderView {
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}

@end
