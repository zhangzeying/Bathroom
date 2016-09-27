//
//  GoodsCollectionViewCell.m
//  BathroomShopping
//
//  Created by zzy on 7/17/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsCollectionViewCell.h"

@implementation GoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.goodNameLbl.text = @"11";
}
@end
