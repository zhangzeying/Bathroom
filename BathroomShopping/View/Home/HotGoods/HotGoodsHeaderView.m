//
//  HotGoodsHeaderView.m
//  BathroomShopping
//
//  Created by zzy on 7/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "HotGoodsHeaderView.h"

@interface HotGoodsHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *splitView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation HotGoodsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitView.backgroundColor = CustomColor(236, 236, 236);
    self.titleLbl.textColor = CustomColor(51, 51, 51);
}

@end
