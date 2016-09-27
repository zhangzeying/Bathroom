//
//  LotteryTableCell.m
//  BathroomShopping
//
//  Created by zzy on 9/19/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "LotteryTableCell.h"
#import "MyButton.h"
#import "LotteryUserModel.h"
@implementation LotteryTableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat hspace = 5;
        CGFloat btnW = (self.width - 4 * hspace) / 3;
        CGFloat btnH = self.height;
        for (int i = 0; i < 3; i++) {
            
            CGFloat btnX = (i % 3) * (btnW + hspace);
            if (i == 0) {
                
                MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(btnX, 0, btnW, btnH);
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [self addSubview:btn];
                btn.backgroundColor = [UIColor yellowColor];
                
            }else {
                
                UILabel *lbl = [[UILabel alloc]init];
                lbl.frame = CGRectMake(btnX, 0, btnW, btnH);
                lbl.backgroundColor = [UIColor redColor];
                lbl.tag = i + 10;
                [self addSubview:lbl];
            }
        }
    }
    
    return self;
}

- (void)setModel:(LotteryUserModel *)model {

    for (int i = 0; i < self.subviews.count; i++) {
        
        if ([self.subviews[i] isKindOfClass:[MyButton class]]) {
            
            MyButton *btn = self.subviews[i];
            [btn setImage:[UIImage imageNamed:@"avator_no_login"] forState:UIControlStateNormal];
            [btn setTitle:model.nikeName forState:UIControlStateNormal];
        }
        
        if ([self.subviews[i] isKindOfClass:[UILabel class]]) {
            
            UILabel *productLbl = [self viewWithTag:11];
            productLbl.text = model.productName;
            
            UILabel *timeLbl = [self viewWithTag:11];
            timeLbl.text = model.createTime;
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
