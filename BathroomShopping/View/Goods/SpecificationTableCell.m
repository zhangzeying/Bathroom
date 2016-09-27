//
//  SpecificationTableCell.m
//  BathroomShopping
//
//  Created by zzy on 8/15/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "SpecificationTableCell.h"
static NSString *ID = @"specificationTableCell";

@interface SpecificationTableCell()
@property (weak, nonatomic) IBOutlet UILabel *specLbl;
@end

@implementation SpecificationTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSpecValue:) name:@"reloadSpecValue" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    SpecificationTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
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

- (void)reloadSpecValue:(NSNotification *)sender {

    self.specLbl.text = sender.object;
}

- (void)setSpecStr:(NSString *)specStr {

    self.specLbl.text = specStr;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
