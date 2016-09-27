//
//  MineTableViewCell.m
//  BathroomShopping
//
//  Created by zzy on 7/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    static NSString *ID = @"mineTableViewCell";
    
    MineTableViewCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = CustomColor(102, 102, 102);
    cell.layer.borderColor = CustomColor(235, 235, 235).CGColor;
    cell.layer.borderWidth = 0.8;
    return cell;
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 10;
    [super setFrame:frame];
    
}
@end
