//
//  AddReceiverTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AddReceiverTableCell.h"

@interface AddReceiverTableCell()
@property (weak, nonatomic) IBOutlet UILabel *line;
@end

@implementation AddReceiverTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.line.backgroundColor = CustomColor(235, 235, 235);
    self.contentTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    AddReceiverTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
