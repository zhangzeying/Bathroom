//
//  LimitBuyTableCell.m
//  BathroomShopping
//
//  Created by zzy on 9/21/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "LimitBuyTableCell.h"
#import "LimitBuyProductModel.h"

static NSString *ID = @"LimitBuyTableCell";
@interface LimitBuyTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *stockLbl;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLbl;
@property (strong, nonatomic) UILabel *progressLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyCountLblW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyCountLblH;

@end

@implementation LimitBuyTableCell

- (UILabel *)progressLbl {
    
    if (_progressLbl == nil) {
        
        _progressLbl = [[UILabel alloc]init];
        _progressLbl.backgroundColor = CustomColor(247, 213, 67);
        _progressLbl.layer.cornerRadius = 5;
        _progressLbl.layer.masksToBounds = YES;
        [self.buyCountLbl addSubview:_progressLbl];
        
    }
    return _progressLbl;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buyCountLbl.layer.borderColor = CustomColor(247, 213, 67).CGColor;
    self.buyCountLbl.layer.borderWidth = 0.5;
    self.buyCountLbl.layer.cornerRadius = 5;
    self.goodsImg.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.goodsImg.layer.borderWidth = 0.8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    LimitBuyTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(LimitBuyProductModel *)model {

    _model = model;
    self.progressLbl.frame = CGRectMake(0, 0, 0, self.buyCountLblH.constant);
    self.goodsImg.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"sys_xiao8"]];
    self.nameLbl.text = model.name;
    
    self.nowPriceLbl.text = [NSString stringWithFormat:@"￥%.2f",model.finalPrice];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f",model.price]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.priceLbl.attributedText = newPrice;
    self.buyCountLbl.text = [NSString stringWithFormat:@"已抢购%ld件",(long)model.sellcount];
    self.stockLbl.text = [NSString stringWithFormat:@"仅剩%ld件",(long)model.stock];
    
    CGFloat progress = (double)model.sellcount / (double)(model.stock + model.sellcount);
    
    [UIView animateWithDuration:1 animations:^{
        
        self.progressLbl.frame = CGRectMake(0, 0, self.buyCountLblW.constant * progress, self.buyCountLblH.constant);
    }];
    
}

- (void)setStateType:(StateType)stateType {

    if (stateType == Buying) {
        
        self.buyBtn.userInteractionEnabled = YES;
        self.buyBtn.backgroundColor = [UIColor redColor];
        [self.buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        self.progressLbl.hidden = NO;
        self.buyCountLbl.hidden = NO;
        self.stockLbl.hidden = NO;
        
    }else {
    
        self.buyBtn.userInteractionEnabled = NO;
        self.buyBtn.backgroundColor = [UIColor lightGrayColor];
        [self.buyBtn setTitle:@"即将开抢" forState:UIControlStateNormal];
        self.progressLbl.hidden = YES;
        self.buyCountLbl.hidden = YES;
        self.stockLbl.hidden = YES;
    }
}

- (IBAction)buyClick:(id)sender {
    
    if (self.limitBuyBlock) {
        
        self.limitBuyBlock(self.model.id);
    }
}

@end
