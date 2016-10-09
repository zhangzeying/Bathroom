//
//  LimitTimeBuyViewController.m
//  BathroomShopping
//
//  Created by zzy on 9/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "LimitTimeBuyViewController.h"
#import "ShoppingSaleDetailViewController.h"
#import "CustomLabel.h"
#import "HomeService.h"
#import "LimitTimeBuyModel.h"
#import "LimitBuyProductViewController.h"

@interface LimitTimeBuyViewController ()<UIScrollViewDelegate>
/** 类别数组 */
@property(nonatomic,strong)NSMutableArray *categoryArr;
/** 类别标题scrollView */
@property (nonatomic, weak)UIScrollView *categoryScrollView;
/** 类别内容scrollView */
@property (nonatomic, weak)UIScrollView *contentScrollView;
/** <##> */
@property(nonatomic,strong)HomeService *service;
/** <##> */
@property(nonatomic,retain)dispatch_source_t timer;
/** <##> */
@property (nonatomic, weak)UIView *countDownView;
/** <##> */
@property (nonatomic, weak)UILabel *line1;
/** <##> */
@property (nonatomic, weak)UILabel *line2;
/** <##> */
@property (nonatomic, weak)UILabel *hourLbl;
/** <##> */
@property (nonatomic, weak)UILabel *minuteLbl;
/** <##> */
@property (nonatomic, weak)UILabel *secondsLbl;
@end

@implementation LimitTimeBuyViewController

- (HomeService *)service {
    
    if (_service == nil) {
        
        _service = [[HomeService alloc]init];
    }
    
    return _service;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"限时抢购";
    [self onLoad];
}

- (void)onLoad {

    __weak typeof (self)weakSelf = self;
    [self.service getLimitTimeBuyPeriod:^(NSMutableArray *timeArr) {
        
        weakSelf.categoryArr = timeArr;
        [weakSelf setupChildVC];
        [weakSelf setupCategory];
        [weakSelf setupCountDownView];
        [weakSelf setupContentView];
        if (self.categoryArr.count > 1) {
            
            LimitTimeBuyModel *model = self.categoryArr[1];
            [weakSelf countDownWithStratDateAndEndDate:model.startDate];
        }
        // 默认显示第0个子控制器
        [weakSelf scrollViewDidEndScrollingAnimation:weakSelf.contentScrollView];
    }];
}

- (void)setupChildVC {
    
    for (int i = 0; i < self.categoryArr.count; i++) {
        
        LimitBuyProductViewController *productVC = [[LimitBuyProductViewController alloc]init];
        [self addChildViewController:productVC];
    }
}

#pragma mark --- CreateUI ---
- (void)setupCategory {
    
    //创建顶部的类别
    UIScrollView *categoryScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, 45)];
    categoryScrollView.backgroundColor = [UIColor whiteColor];
    categoryScrollView.showsVerticalScrollIndicator = NO;
    categoryScrollView.showsHorizontalScrollIndicator = NO;
    categoryScrollView.layer.masksToBounds = NO;
    [self.view addSubview:categoryScrollView];
    CGFloat titleBtnW = 70;
    CGFloat titleBtnH = categoryScrollView.height + 4;
    
    UIImageView *bgImg = [[UIImageView alloc]init];
    bgImg.frame = CGRectMake(0, 0, titleBtnW, titleBtnH);
    bgImg.image = [UIImage imageNamed:@"limit_time_bg"];
    [categoryScrollView addSubview:bgImg];
    
    for (int i = 0; i < self.categoryArr.count; i++) {
        
        LimitTimeBuyModel *model = self.categoryArr[i];
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CustomLabel *timeLbl = [[CustomLabel alloc]init];
        timeLbl.textColor = [UIColor darkGrayColor];
        timeLbl.font = [UIFont systemFontOfSize:12];
        timeLbl.tag = 100;
        timeLbl.text = [NSString stringWithFormat:@"%@",model.startTime];
        UILabel *stateLbl = [[UILabel alloc]init];
        stateLbl.textColor = [UIColor darkGrayColor];
        stateLbl.font = [UIFont systemFontOfSize:10];
        stateLbl.tag = 101;
        stateLbl.text = @"即将开始";
        if (i == 0) {
            
            stateLbl.text = @"抢购中";
            timeLbl.font = [UIFont systemFontOfSize:14];
            timeLbl.textColor = [UIColor whiteColor];
            stateLbl.textColor = [UIColor whiteColor];
        }
        titleBtn.tag = i;
        CGFloat titleBtnX = i * titleBtnW;
        titleBtn.frame = CGRectMake(titleBtnX, 0, titleBtnW, titleBtnH);

        CGSize size = [timeLbl.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        timeLbl.frame = CGRectMake(0, (titleBtn.height - 2 * size.height) / 2, titleBtn.width, size.height);
        timeLbl.centerX = titleBtn.width / 2;
        timeLbl.textAlignment = NSTextAlignmentCenter;
        [titleBtn addSubview:timeLbl];
        
        [stateLbl sizeToFit];
        stateLbl.frame = CGRectMake(0, CGRectGetMaxY(timeLbl.frame) + 2, titleBtn.width, stateLbl.height);
        stateLbl.centerX = titleBtn.width / 2;
        stateLbl.textAlignment = NSTextAlignmentCenter;
        [titleBtn addSubview:stateLbl];
        [categoryScrollView addSubview:titleBtn];
    }
    categoryScrollView.contentSize = CGSizeMake(self.categoryArr.count * titleBtnW, 0);
    self.categoryScrollView = categoryScrollView;
    
    UILabel *line1 = [[UILabel alloc]init];
    line1.frame = CGRectMake(0, CGRectGetMaxY(categoryScrollView.frame), ScreenW, 1);
    line1.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
    [self.view insertSubview:line1 atIndex:0];
    self.line1 = line1;
}

/**
 * 倒计时view
 */
- (void)setupCountDownView {

    UIView *countDownView = [[UIView alloc]init];
    countDownView.frame = CGRectMake(0, CGRectGetMaxY(self.line1.frame) + 4, ScreenW, 34);
    [self.view addSubview:countDownView];
    self.countDownView = countDownView;
    
    UILabel *endLbl = [[UILabel alloc]init];
    endLbl.text = @"距离本场结束";
    endLbl.textColor = [UIColor darkGrayColor];
    endLbl.font = [UIFont systemFontOfSize:12];
    [endLbl sizeToFit];
    endLbl.frame = CGRectMake(10, 0, endLbl.width, endLbl.height);
    endLbl.centerY = self.countDownView.height / 2;
    [countDownView addSubview:endLbl];
    
    UILabel *hourLbl = [[UILabel alloc]init];
    hourLbl.text = @"00";
    hourLbl.textColor = [UIColor whiteColor];
    hourLbl.font = [UIFont systemFontOfSize:12];
    [hourLbl sizeToFit];
    hourLbl.backgroundColor = [UIColor blackColor];
    hourLbl.frame = CGRectMake(CGRectGetMaxX(endLbl.frame) + 10, endLbl.y, hourLbl.width, endLbl.height);
    [countDownView addSubview:hourLbl];
    self.hourLbl = hourLbl;
    
    UILabel *divisionLbl1 = [[UILabel alloc]init];
    divisionLbl1.text = @":";
    divisionLbl1.font = [UIFont systemFontOfSize:12];
    [divisionLbl1 sizeToFit];
    divisionLbl1.frame = CGRectMake(CGRectGetMaxX(hourLbl.frame) + 4, 0, divisionLbl1.width, divisionLbl1.height);
    divisionLbl1.centerY = hourLbl.centerY;
    [countDownView addSubview:divisionLbl1];
    
    UILabel *minuteLbl = [[UILabel alloc]init];
    minuteLbl.text = @"00";
    minuteLbl.textColor = [UIColor whiteColor];
    minuteLbl.font = [UIFont systemFontOfSize:12];
    [minuteLbl sizeToFit];
    minuteLbl.frame = CGRectMake(CGRectGetMaxX(divisionLbl1.frame) + 4, endLbl.y, minuteLbl.width, minuteLbl.height);
    [countDownView addSubview:minuteLbl];
    minuteLbl.backgroundColor = [UIColor blackColor];
    self.minuteLbl = minuteLbl;
    
    UILabel *divisionLbl2 = [[UILabel alloc]init];
    divisionLbl2.text = @":";
    divisionLbl2.font = [UIFont systemFontOfSize:12];
    [divisionLbl2 sizeToFit];
    divisionLbl2.frame = CGRectMake(CGRectGetMaxX(minuteLbl.frame) + 4, 0, divisionLbl2.width, divisionLbl2.height);
    divisionLbl2.centerY = hourLbl.centerY;
    [countDownView addSubview:divisionLbl2];
    
    UILabel *secondsLbl = [[UILabel alloc]init];
    secondsLbl.text = @"00";
    secondsLbl.textColor = [UIColor whiteColor];
    secondsLbl.font = [UIFont systemFontOfSize:12];
    [secondsLbl sizeToFit];
    secondsLbl.frame = CGRectMake(CGRectGetMaxX(divisionLbl2.frame) + 4, endLbl.y, secondsLbl.width, secondsLbl.height);
    [countDownView addSubview:secondsLbl];
    secondsLbl.backgroundColor = [UIColor blackColor];
    self.secondsLbl = secondsLbl;
    
    UILabel *line2 = [[UILabel alloc]init];
    line2.frame = CGRectMake(0, CGRectGetMaxY(countDownView.frame), ScreenW, 1);
    line2.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
    [self.view addSubview:line2];
    self.line2 = line2;
    
}

- (void)setupContentView {

    CGFloat contentScrollViewY = CGRectGetMaxY(self.line2.frame);
    UIScrollView *contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, contentScrollViewY, ScreenW, ScreenH - contentScrollViewY)];
    contentScrollView.backgroundColor = [UIColor clearColor];
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    [self.view addSubview:contentScrollView];
    contentScrollView.contentSize = CGSizeMake(self.categoryArr.count * ScreenW, 0);
    self.contentScrollView = contentScrollView;
}

/**
 * 监听顶部label点击
 */
- (void)titleClick:(UIButton *)sender {
    // 让底部的内容scrollView滚动到对应位置
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = sender.tag * self.contentScrollView.frame.size.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
}

#pragma mark --- UIScrollViewDelegate ---
/**
 * scrollView结束了滚动动画以后就会调用这个方法（比如- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;方法执行的动画完毕后）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // 一些临时变量
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    
    // 让对应的顶部标题居中显示
    UIButton *titleBtn = self.categoryScrollView.subviews[index + 1];
    
    CustomLabel *timeLbl = [titleBtn viewWithTag:100];
    timeLbl.font = [UIFont systemFontOfSize:12];
    timeLbl.textColor = [UIColor whiteColor];
    
    UILabel *stateLbl = [titleBtn viewWithTag:101];
    stateLbl.textColor = [UIColor whiteColor];
    
    CGPoint titleOffset = self.categoryScrollView.contentOffset;
    titleOffset.x = titleBtn.center.x - width * 0.5;
    // 左边超出处理
    if (titleOffset.x < 0) titleOffset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.categoryScrollView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
    
    [self.categoryScrollView setContentOffset:titleOffset animated:YES];
    
    // 让其他label回到最初的状态
    for (UIButton *otherBtn in self.categoryScrollView.subviews) {
        if (otherBtn != titleBtn) {
            
            CustomLabel *timeLbl = [otherBtn viewWithTag:100];
            timeLbl.font = [UIFont systemFontOfSize:10];
            timeLbl.textColor = [UIColor darkGrayColor];
            
            UILabel *stateLbl = [otherBtn viewWithTag:101];
            stateLbl.textColor = [UIColor darkGrayColor];
        }
    }
    
    
    LimitTimeBuyModel *model = self.categoryArr[index];
    
    __block NSInteger currentIndex = index;
    // 取出需要显示的控制器
    LimitBuyProductViewController *willShowVc = self.childViewControllers[index];
    
    // 如果当前位置的位置已经显示过了，就直接返回
    if ([willShowVc isViewLoaded]) return;
    
    __block LimitBuyProductViewController *productVC = willShowVc;
    [self.service getProductByTime:model.startDate completion:^(NSMutableArray *dataArr) {
        
        productVC.index = currentIndex;
        productVC.dataArr = dataArr;
    }];
    
    
    
    // 添加控制器的view到contentScrollView中;
    willShowVc.view.frame = CGRectMake(offsetX, 0, width, height);
    [scrollView addSubview:willShowVc.view];
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 * 只要scrollView在滚动，就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIImageView *bgImg = self.categoryScrollView.subviews[0];
    bgImg.frame = CGRectMake(scale * 70, 0, 70, self.categoryScrollView.height + 4);
}

/**
 * 开始时间和结束时间的倒计时
 */
- (void)countDownWithStratDateAndEndDate:(NSString *)endDateStr {
    
    if (self.timer == nil) {
        
        __weak typeof (self)weakSelf = self;
        NSDate *startDate = [NSDate date];
        NSDate *endDate = [[CommUtils sharedInstance] dateFromString:endDateStr];
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
                        
                        [weakSelf onLoad];
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        weakSelf.hourLbl.text = hours < 10 ? [NSString stringWithFormat:@"0%d",hours] : [NSString stringWithFormat:@"%zd",hours];
                        weakSelf.minuteLbl.text = minute < 10 ? [NSString stringWithFormat:@"0%d",minute] : [NSString stringWithFormat:@"%zd",minute];
                        weakSelf.secondsLbl.text = second < 10 ? [NSString stringWithFormat:@"0%d",second] : [NSString stringWithFormat:@"%zd",second];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
