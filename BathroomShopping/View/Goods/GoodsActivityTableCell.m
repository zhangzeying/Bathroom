//
//  GoodsActivityTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsActivityTableCell.h"

static NSString *ID = @"goodsActivityTableCell";

@interface GoodsActivityTableCell()
@property (weak, nonatomic) IBOutlet UILabel *activityLbl;
@end

@implementation GoodsActivityTableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    GoodsActivityTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.activityLbl.text = @"暂无";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
