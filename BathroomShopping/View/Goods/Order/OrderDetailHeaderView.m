
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
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@end

@implementation OrderDetailHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.bgView1.layer.borderColor = [UIColor colorWithHexString:@"0xcfcfcf"].CGColor;
    self.bgView1.layer.borderWidth = 0.5;
    
    self.bgView2.layer.borderColor = [UIColor colorWithHexString:@"0xcfcfcf"].CGColor;
    self.bgView2.layer.borderWidth = 0.5;
}

+ (OrderDetailHeaderView *)instanceHeaderView {
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}

- (IBAction)editClick:(id)sender {
    
    
}

@end
