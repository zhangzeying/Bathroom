//
//  GoodsCollectionHeaderView.m
//  BathroomShopping
//
//  Created by zzy on 7/18/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsCollectionHeaderView.h"
@interface GoodsCollectionHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@end

@implementation GoodsCollectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = CustomColor(242, 242, 242);
    self.titleLbl.text = @"电视";
}

@end
