
//
//  OrderDetailHeaderView.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderDetailHeaderView.h"

@interface OrderDetailHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *reveiverLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;

@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *state;

@end

@implementation OrderDetailHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = CustomColor(240, 242, 245);
}

+ (OrderDetailHeaderView *)instanceHeaderView {
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}

@end
