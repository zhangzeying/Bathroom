//
//  OrderTableCell.m
//  BathroomShopping
//
//  Created by zzy on 9/28/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderTableCell.h"
#import "OrderModel.h"
static NSString *ID = @"orderTableCell";
@interface OrderTableCell()
@property (weak, nonatomic) IBOutlet UILabel *orderStateLbl;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;
@end

@implementation OrderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.operationBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.operationBtn.layer.borderWidth = 0.5;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    OrderTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
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

- (void)setModel:(OrderModel *)model {

    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 29, ScreenW, 90)];
    scroll.backgroundColor = CustomColor(245, 245, 245);
    [self addSubview:scroll];
}

- (IBAction)operationClick:(id)sender {
}
@end
