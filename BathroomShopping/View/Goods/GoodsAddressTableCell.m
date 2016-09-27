//
//  GoodsAddressTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsAddressTableCell.h"
static NSString *ID = @"goodsAddressTableCell";

@interface GoodsAddressTableCell()

@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@end

@implementation GoodsAddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    GoodsAddressTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 10;
    [super setFrame:frame];
}


@end
