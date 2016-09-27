
//
//  AddressListTableCell.m
//  BathroomShopping
//
//  Created by zzy on 9/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AddressListTableCell.h"
#import "ReceiverAddressModel.h"
static NSString *ID = @"addressListTableCell";
@interface AddressListTableCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UIImageView *gouImg;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@end

@implementation AddressListTableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.line.backgroundColor = CustomColor(235, 235, 235);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    AddressListTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(ReceiverAddressModel *)model {
    
    _model = model;
    self.phoneLbl.text = model.mobile;
    self.nameLbl.text = model.name;
    self.addressLbl.text = [[NSString stringWithFormat:@"%@%@",model.pcadetail,model.address] stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.gouImg.hidden = !model.isSelected;
}
@end
