//
//  HomeScrollNewsView.m
//  BathroomShopping
//
//  Created by zzy on 7/19/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "HomeScrollNewsView.h"
#import "HomeScrollNewsTableCell.h"

static NSString *ID = @"newsCell";

#define kHeadTimerINterval 4

@interface HomeScrollNewsView()<UITableViewDelegate, UITableViewDataSource>
/** UITableView */
@property (nonatomic, weak)UITableView *newsTable;
/** 计时器 */
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation HomeScrollNewsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        UIImageView *voiceIcon = [[UIImageView alloc]init];
        UIImage *voiceImg = [UIImage imageNamed:@"volume-icon-loud"];
        voiceIcon.image = [UIImage imageNamed:@"volume-icon-loud"];
        voiceIcon.frame = CGRectMake(10, 0, voiceImg.size.width, voiceImg.size.height);
        voiceIcon.centerY = self.height / 2;
        [self addSubview:voiceIcon];
        
        CGFloat tableX = CGRectGetMaxX(voiceIcon.frame) + 10;
        UITableView *newsTable = [[UITableView alloc]initWithFrame:CGRectMake(tableX, 0, ScreenW - tableX, self.height) style:UITableViewStylePlain];
        newsTable.delegate = self;
        newsTable.dataSource = self;
        newsTable.rowHeight = self.height;
        newsTable.scrollEnabled = NO;
        newsTable.bounces = NO;
        newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:newsTable];
        self.newsTable = newsTable;
    
        [self addTimer];
    }
    return self;
}


#pragma mark --- NSTimerAction ---
/**
 * 实现循环滚动
 */
- (void)scroll {

    CGPoint oldPoint = self.newsTable.contentOffset;
    oldPoint.y += self.newsTable.frame.size.height;
    [self.newsTable setContentOffset:oldPoint animated:YES];
}

#pragma mark --- UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.newsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HomeScrollNewsTableCell *cell = [HomeScrollNewsTableCell cellWithTableView:tableView];
    cell.news = self.newsArr[indexPath.row];
    return cell;
}

//当图片滚动时调用scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.newsTable.contentOffset.y == self.newsTable.frame.size.height * (self.newsArr.count )) {
        
        [self.newsTable setContentOffset:CGPointMake(0, 0) animated:NO];
        
    }
}

#pragma mark --- setter ---
- (void)setNewsArr:(NSMutableArray *)newsArr {

    _newsArr = newsArr;
    
    if (newsArr == nil || newsArr.count == 1) {
        
        [self removeTimer];
        return;
    }

    [self.newsTable reloadData];
    
}

- (void)addTimer {

    self.timer = [NSTimer scheduledTimerWithTimeInterval:kHeadTimerINterval target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark --- dealloc ---
- (void)dealloc {
    
    [self removeTimer];
}
@end
