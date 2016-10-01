//
//  OrderTableCell.m
//  BathroomShopping
//
//  Created by zzy on 9/28/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OrderTableCell.h"
#import "OrderModel.h"
#import "OrderDetailModel.h"
static NSString *ID = @"orderTableCell";
@interface OrderTableCell()
@property (weak, nonatomic) IBOutlet UILabel *orderStateLbl;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;
@property (weak, nonatomic) IBOutlet UILabel *line;
@end

@implementation OrderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.operationBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.operationBtn.layer.borderWidth = 0.5;
    self.line.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
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
    
    if (model.orders.count > 1) {
        
        for (int i = 0; i < model.orders.count; i++) {
            
            OrderDetailModel *detailModel = model.orders[i];
            UIImageView *goodsImg = [[UIImageView alloc]init];
            CGFloat goodsImgW = 60;
            CGFloat goodsImgX = i * (15 + goodsImgW) + 15;
            goodsImg.frame = CGRectMake(goodsImgX, 15, 60, 60);
            [scroll addSubview:goodsImg];
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, detailModel.picture];
            [goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        }
        
        scroll.contentSize = CGSizeMake(CGRectGetMaxX([scroll.subviews lastObject].frame), 0);
    }
    
    self.totalNumLbl.text = [NSString stringWithFormat:@"共%ld件商品",(long)model.orders.count];
    self.totalPriceLbl.text = [NSString stringWithFormat:@"合计:¥ %.2f",model.amount];
}

- (IBAction)operationClick:(id)sender {
}
@end
