
//
//  OrderDetailHeaderView.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderDetailHeaderView.h"
#import "OrderModel.h"
#import "MyLabel.h"
@interface OrderDetailHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *reveiverLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;

@property (weak, nonatomic) IBOutlet MyLabel *addressLbl;
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

- (void)setModel:(OrderModel *)model {

    self.phoneLbl.text = model.ordership[@"tel"];
    self.orderNum.text = [NSString stringWithFormat:@"订单号:%@",model.id];
    self.addressLbl.text = [NSString stringWithFormat:@"%@%@",model.ordership[@"shipaddress"],model.ordership[@"shipname"]];
}
@end
