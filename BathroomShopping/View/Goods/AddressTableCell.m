//
//  AddressTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/26/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AddressTableCell.h"
#import "AddressModel.h"
static NSString *ID = @"addressTableCell";
@implementation AddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    AddressTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[AddressTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    return cell;
}

- (void)setModel:(AddressModel *)model {

    self.textLabel.text = model.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.textLabel.textColor = selected ? [UIColor redColor] : [UIColor blackColor];
}

@end
