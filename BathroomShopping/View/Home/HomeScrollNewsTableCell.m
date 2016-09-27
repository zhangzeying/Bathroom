//
//  HomeScrollNewsTableCell.m
//  BathroomShopping
//
//  Created by zzy on 7/20/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "HomeScrollNewsTableCell.h"
@interface HomeScrollNewsTableCell()
@property (weak, nonatomic) IBOutlet UILabel *newsLbl;
@end

@implementation HomeScrollNewsTableCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.newsLbl.textColor = CustomColor(102, 102, 102);
    self.newsLbl.font = [UIFont systemFontOfSize:12];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    static NSString *ID = @"homeScrollNewsCell";
    HomeScrollNewsTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setNews:(NSString *)news {

    self.newsLbl.text = news;
}
@end
