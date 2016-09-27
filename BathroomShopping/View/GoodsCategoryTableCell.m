//
//  GoodsCategoryTableCell.m
//  BathroomShopping
//
//  Created by zzy on 7/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsCategoryTableCell.h"
@interface GoodsCategoryTableCell()
@property (weak, nonatomic)IBOutlet UILabel *splitLine;

@end

@implementation GoodsCategoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitLine.backgroundColor = CustomColor(235, 235, 235);
    self.categoryLbl.textColor = CustomColor(119, 119, 119);
    self.categoryLbl.highlightedTextColor = CustomColor(91, 141, 213);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    self.categoryLbl.highlighted = selected;
    self.backgroundColor = selected ? CustomColor(242, 242, 242) : [UIColor whiteColor];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    static NSString *ID = @"goodsCategoryCell";
    GoodsCategoryTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
