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
/** 第一条消息用UILabel来实现，这样为了实现循环滚动的假象 */
@property (nonatomic, weak)UILabel *firstNewsLbl;
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
        UITableView *newsTable = [[UITableView alloc]initWithFrame:CGRectMake(tableX, CGRectGetHeight(self.frame), ScreenW - tableX, self.height) style:UITableViewStylePlain];
        newsTable.delegate = self;
        newsTable.dataSource = self;
        newsTable.rowHeight = self.height;
        newsTable.scrollEnabled = NO;
        newsTable.bounces = NO;
        newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:newsTable];
        self.newsTable = newsTable;
        
        UILabel *firstNewsLbl = [[UILabel alloc]init];
        firstNewsLbl.frame = CGRectMake(tableX + 8, 0, ScreenW - tableX, self.height);
        firstNewsLbl.textColor = CustomColor(102, 102, 102);
        firstNewsLbl.font = [UIFont systemFontOfSize:12];
        [self addSubview:firstNewsLbl];
        self.firstNewsLbl = firstNewsLbl;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kHeadTimerINterval target:self selector:@selector(scroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}


#pragma mark --- NSTimerAction ---
/**
 * 实现循环滚动
 */
- (void)scroll {

    if (self.firstNewsLbl.y != 0) {
        
        CGPoint newOffset = self.newsTable.contentOffset;
        newOffset.y += self.height;
        if (newOffset.y > (self.newsTable.contentSize.height - self.height)) {
            
            newOffset.y = 0.0f;
            [UIView animateWithDuration:0.25 animations:^{
                
                self.firstNewsLbl.y = 0;
                self.newsTable.y = - self.height;
                
            } completion:^(BOOL finished) {
                
                self.newsTable.y = self.height;
                self.newsTable.contentOffset = newOffset;
            }];
            
        }else {
        
            [self.newsTable setContentOffset:newOffset animated:YES];
        }
        
        
    }else {
    
        [UIView animateWithDuration:0.25 animations:^{
            
            self.firstNewsLbl.y = - self.height;
            self.newsTable.y = 0;
            
        } completion:^(BOOL finished) {
            
            self.firstNewsLbl.y = self.height;
        }];

    }
    
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

#pragma mark --- setter ---
- (void)setNewsArr:(NSMutableArray *)newsArr {

    _newsArr = newsArr;
    self.firstNewsLbl.text = [newsArr firstObject];
    [newsArr removeObjectAtIndex:0];
    [self.newsTable reloadData];
    
}

#pragma mark --- dealloc ---
- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
}
@end