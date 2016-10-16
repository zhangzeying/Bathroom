//
//  OrderDetailFooterView.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderDetailFooterView.h"

@interface OrderDetailFooterView()
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

@implementation OrderDetailFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.payBtn.layer.cornerRadius = 3;
    self.payBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.payBtn.layer.borderWidth = 0.5;
    
    self.cancelBtn.layer.cornerRadius = 3;
    self.cancelBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.cancelBtn.layer.borderWidth = 0.5;
    
    self.backgroundColor = CustomColor(248, 248, 248);
}

+ (OrderDetailFooterView *)instanceFooterView {
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}
- (IBAction)payClick:(id)sender {
}

- (IBAction)cancelClick:(id)sender {
 
    
}

@end
