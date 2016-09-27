//
//  OrderDetailFooterView.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderDetailFooterView.h"

@interface OrderDetailFooterView()
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UITextField *remarkTxt;
@end

@implementation OrderDetailFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

+ (OrderDetailFooterView *)instanceFooterView {
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}

- (IBAction)editClick:(id)sender {
 
    
}

@end
