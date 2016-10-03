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
    
    if ([model.remark isEqualToString:@"一元抢购"]) {
        
        UILabel *nameLbl = [[UILabel alloc]init];
        nameLbl.text = @"一元抢购抽奖";
        [nameLbl sizeToFit];
        nameLbl.frame = CGRectMake(15, 0, nameLbl.width, nameLbl.height);
        nameLbl.centerY = scroll.height / 2;
        nameLbl.font = [UIFont systemFontOfSize:13];
        [scroll addSubview:nameLbl];
        
        self.totalNumLbl.hidden = YES;
        
    }else {
    
        if (model.orders.count > 1) {//如果是多个商品
            
            for (int i = 0; i < model.orders.count; i++) {
                
                OrderDetailModel *detailModel = model.orders[i];
                UIImageView *goodsImg = [[UIImageView alloc]init];
                CGFloat goodsImgW = 60;
                CGFloat goodsImgX = i * (15 + goodsImgW) + 15;
                goodsImg.frame = CGRectMake(goodsImgX, 15, goodsImgW, goodsImgW);
                [scroll addSubview:goodsImg];
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, detailModel.picture];
                [goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
            }
            
            scroll.contentSize = CGSizeMake(CGRectGetMaxX([scroll.subviews lastObject].frame), 0);
            
        }else if (model.orders.count == 1) {//如果是单个商品
            
            OrderDetailModel *detailModel = model.orders[0];
            UIImageView *goodsImg = [[UIImageView alloc]init];
            CGFloat goodsImgW = 70;
            goodsImg.frame = CGRectMake(15, 0, goodsImgW, goodsImgW);
            goodsImg.centerY = scroll.height / 2;
            [scroll addSubview:goodsImg];
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, detailModel.picture];
            [goodsImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
            
            UILabel *nameLbl = [[UILabel alloc]init];
            CGFloat nameLblX = CGRectGetMaxX(goodsImg.frame) + 15;
            nameLbl.numberOfLines = 0;
            nameLbl.frame = CGRectMake(nameLblX, 0, ScreenW - nameLblX - 15, 50);
            nameLbl.font = [UIFont systemFontOfSize:13];
            nameLbl.centerY = goodsImg.centerY;
            nameLbl.text = detailModel.productName;
            [scroll addSubview:nameLbl];
        }
        
        self.totalNumLbl.hidden = NO;
        self.totalNumLbl.text = [NSString stringWithFormat:@"共%ld件商品",(long)model.orders.count];
    }
    
    if ([model.paystatus isEqualToString:@"n"]) {
        
        self.orderStateLbl.text = @"等待付款";
        
    }else {
    
        if ([model.status isEqualToString:@"init"]) {
            
            self.orderStateLbl.text = @"已付款";
            
        }else if ([model.status isEqualToString:@"send"]) {
        
            self.orderStateLbl.text = @"已发货";
            
        }else if ([model.status isEqualToString:@"sign"]) {
        
            self.orderStateLbl.text = @"已签收";
        }
    }
    
    
    self.totalPriceLbl.text = [NSString stringWithFormat:@"合计:¥ %.2f",model.amount];
}

- (IBAction)operationClick:(id)sender {
}
@end
