//
//  AddressManageTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/20/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AddressManageTableCell.h"
#import "ReceiverAddressModel.h"

static NSString *ID = @"addressManageTableCell";
@interface AddressManageTableCell()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;

@end

@implementation AddressManageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.line.backgroundColor = CustomColor(235, 235, 235);
    self.editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    
    AddressManageTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
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

- (void)setModel:(ReceiverAddressModel *)model {

    _model = model;
    self.phoneLbl.text = model.mobile;
    self.nameLbl.text = model.name;
    self.addressLbl.text = [[NSString stringWithFormat:@"%@%@",model.pcadetail,model.address] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (IBAction)checkClick:(id)sender {
    
    
}

/**
 * 编辑地址
 */
- (IBAction)editClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(editAddress:)]) {
        
        [self.delegate editAddress:self.model];
    }
}

/**
 * 删除地址
 */
- (IBAction)deleteClick:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否确定删除该地址？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        if ([self.delegate respondsToSelector:@selector(deleteAddress:)]) {
            
            [self.delegate deleteAddress:self.model];
        }
    }
}
@end
