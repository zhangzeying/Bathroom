
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
@property (weak, nonatomic) IBOutlet UIView *addressBgView;

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

    
    self.orderNum.text = [NSString stringWithFormat:@"订单号:%@",model.id];
    if ([model.paystatus isEqualToString:@"n"]) {
        
        self.state.text = @"等待付款";
        
    }else {
        
        if ([model.status isEqualToString:@"init"]) {
            
            self.state.text = @"已付款";
            
        }else if ([model.status isEqualToString:@"send"]) {
            
            self.state.text = @"已发货";
            
        }else if ([model.status isEqualToString:@"sign"]) {
            
            self.state.text = @"已签收";
        }
    }
    if ([model.remark isEqualToString:@"一元抢购"]) {
        
        self.addressBgView.hidden = YES;
        
    }else {
    
        self.addressBgView.hidden = NO;
        self.phoneLbl.text = model.ordership[@"tel"];
        self.addressLbl.text = [model.ordership[@"shipaddress"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.reveiverLbl.text = model.ordership[@"shipname"];
    }
}
@end
