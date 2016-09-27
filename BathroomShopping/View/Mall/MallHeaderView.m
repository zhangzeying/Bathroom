//
//  MallHeaderView.m
//  BathroomShopping
//
//  Created by zzy on 7/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MallHeaderView.h"

@interface MallHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *leftLine;
@property (weak, nonatomic) IBOutlet UILabel *rightLine;
@end

@implementation MallHeaderView

- (void)awakeFromNib {

    self.titleLbl.textColor = CustomColor(51, 51, 51);
    self.leftLine.backgroundColor = CustomColor(235, 235, 235);
    self.rightLine.backgroundColor = CustomColor(235, 235, 235);
}

+ (MallHeaderView *)instanceHeaderView {
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}

@end
