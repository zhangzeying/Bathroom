//
//  ActivityGoodsHeaderView.m
//  BathroomShopping
//
//  Created by zzy on 7/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "ActivityGoodsHeaderView.h"
#import "ActivityGoodsDetailModel.h"
#import "LimitTimeBuyModel.h"

@interface ActivityGoodsHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *splitView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *leaveTimeBgView;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *minute;
@property (weak, nonatomic) IBOutlet UILabel *seconds;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
/** <##> */
@property(nonatomic,retain)dispatch_source_t timer;
@end

@implementation ActivityGoodsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitView.backgroundColor = CustomColor(236, 236, 236);
    self.activityTitleLbl.textColor = CustomColor(51, 51, 51);
    [self.moreBtn setTitleColor:CustomColor(51, 51, 51) forState:UIControlStateNormal];
    CGSize size = [self.moreBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [self.moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -14, 0, 14)];
    [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, size.width, 0, -size.width)];
}

- (void)setModel:(ActivityGoodsDetailModel *)model {
    
    _model = model;
    if (model.activityType == Perference) {
        
        self.activityTitleLbl.text = @"商城特惠";
    }else if (model.activityType == OneYuan) {
    
        self.activityTitleLbl.text = @"一元抢购";
        
    }else if (model.activityType == Buy) {
        
        self.activityTitleLbl.text = @"限时抢购";
        self.leaveTimeBgView.hidden = NO;
    }
}

- (void)setBuyModel:(LimitTimeBuyModel *)buyModel {

    [self countDownWithStratDateAndEndDate:buyModel.endDate];
}

/**
 * 更多
 */
- (IBAction)moreClick:(id)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(more:)]) {
        
        if (self.model.activityType == Perference) {
            
            [self.delegate more:0];
        }else if (self.model.activityType == OneYuan) {
            
            [self.delegate more:1];
            
        }else if (self.model.activityType == Buy) {
            
            [self.delegate more:2];
        }
    }
    
}

/**
 * 开始时间和结束时间的倒计时
 */
- (void)countDownWithStratDateAndEndDate:(NSString *)endDateStr {
    
    if (self.timer == nil) {
       
        __weak typeof (self)weakSelf = self;
        NSDate *endDate = [[CommUtils sharedInstance] dateFromString:endDateStr];
        NSDate *startDate  = [NSDate date];
        NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:startDate];
        __block int timeout = timeInterval; //倒计时时间
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(self.timer);
                    self.timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        weakSelf.hour.text = hours < 10 ? [NSString stringWithFormat:@"0%d",hours] : [NSString stringWithFormat:@"%zd",hours];
                        weakSelf.minute.text = minute < 10 ? [NSString stringWithFormat:@"0%d",minute] : [NSString stringWithFormat:@"%zd",minute];
                        weakSelf.seconds.text = second < 10 ? [NSString stringWithFormat:@"0%d",second] : [NSString stringWithFormat:@"%zd",second];
                    });
                    timeout--;
                }
            });
            dispatch_resume(self.timer);
        }
    }
}


- (void)dealloc {
    
    if (self.timer) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}
@end
