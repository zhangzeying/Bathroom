//
//  MyAppointTableCell.m
//  BathroomShopping
//
//  Created by zzy on 9/9/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MyAppointTableCell.h"
#import "AppointModel.h"
#import "AppointDetailModel.h"
static NSString *ID = @"myAppointTableCell";
@interface MyAppointTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *specLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *waitDayLbl;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@end

@implementation MyAppointTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.line.backgroundColor = CustomColor(235, 235, 235);
    self.lineH.constant = 0.5;
    self.goodImg.layer.borderColor = CustomColor(235, 235, 235).CGColor;
    self.goodImg.layer.borderWidth = 0.5;
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    MyAppointTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(AppointModel *)model {

    self.goodImg.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.detailModel.picture];
    [self.goodImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"sys_xiao8"]];
    
    self.nameLbl.text = model.detailModel.name;
    self.priceLbl.text = [NSString stringWithFormat:@"¥%.2f",model.detailModel.specPrice];
    self.specLbl.text = [NSString stringWithFormat:@"%@%@",model.detailModel.singleSpecColor,model.detailModel.singleSpecSize];
    self.numLbl.text = [NSString stringWithFormat:@"%ld",(long)model.reserveNum];
    
    NSString *startDateStr = [model.createTime substringToIndex:model.createTime.length - 2 - 1];
    [self countDownWithStratDateAndEndDate:startDateStr];
}

/**
 * 开始时间和结束时间的倒计时
 */
- (void)countDownWithStratDateAndEndDate:(NSString *)startDateStr {
    
    __weak typeof (self)weakSelf = self;
    NSDate *startDate = [[CommUtils sharedInstance] dateFromString:startDateStr];
    NSDate *endDate = [NSDate date];
    NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:startDate];
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minute = (int)(timeInterval-days*24*3600-hours*3600)/60;
    weakSelf.waitDayLbl.text = [NSString stringWithFormat:@"已等待:%d 天 %d 小时 %d 分", days,hours,minute];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
