//
//  PageScrollView.m
//  BathroomShopping
//
//  Created by zzy on 7/7/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "PageScrollView.h"

#define imageViewMaxCount 3

@interface PageScrollView()<UIScrollViewDelegate>

/** scrollview */
@property (nonatomic, weak)UIScrollView *scrollView;
/** pagecontrol */
@property (nonatomic, weak)UIPageControl *pageControl;
/** 计时器 */
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation PageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        self.imageUrlArr = [[NSArray alloc]initWithObjects:@"http://heyue.oss-cn-hangzhou.aliyuncs.com/AppData%2Fbigbusiness%2F1.jpg",
                            @"http://heyue.oss-cn-hangzhou.aliyuncs.com/AppData%2Fbigbusiness%2F2.jpg",
                            @"http://heyue.oss-cn-hangzhou.aliyuncs.com/AppData%2Fbigbusiness%2F3.jpg",
                            @"http://heyue.oss-cn-hangzhou.aliyuncs.com/AppData%2Fbigbusiness%2F4.jpg",
                            @"http://heyue.oss-cn-hangzhou.aliyuncs.com/AppData%2Fbigbusiness%2F5.jpg",
                            @"http://heyue.oss-cn-hangzhou.aliyuncs.com/AppData%2Fbigbusiness%2F6.jpg",
                            @"http://heyue.oss-cn-hangzhou.aliyuncs.com/AppData%2Fbigbusiness%2F7.jpg",
                            nil];
        
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.currentPage = 0;
        pageControl.numberOfPages = self.imageUrlArr.count;
        pageControl.userInteractionEnabled = YES;
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.263 green:0.365 blue:0.447 alpha:1.0];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        pageControl.hidesForSinglePage = YES;
        
        [self addSubview:pageControl];
        self.pageControl = pageControl;
       
        for (int i = 0; i < imageViewMaxCount; i++) {
            
            UIImageView *scrollImage = [[UIImageView alloc]init];
            [scrollView addSubview:scrollImage];
        }

        [self startTimer];
       
    }
    return self;
}

#pragma mark --- 布局子控件 ---
- (void)layoutSubviews {

    self.scrollView.frame = self.frame;
    self.scrollView.contentSize = CGSizeMake(imageViewMaxCount * self.scrollView.width, 0);
    CGFloat pageControlW = 80;
    CGFloat pageControlH = 20;
    self.pageControl.frame = CGRectMake(0, self.scrollView.height - pageControlH, pageControlW, pageControlH);
    self.pageControl.centerX = self.scrollView.centerX;
    
    CGFloat scrollImageW = self.scrollView.width;
    CGFloat scrollImageH = self.scrollView.height;
    
    for (int i = 0; i < imageViewMaxCount; i++) {
        
        UIImageView *scrollImage = self.scrollView.subviews[i];
        
        CGFloat scrollImageX = i * scrollImageW;
        scrollImage.frame = CGRectMake(scrollImageX, 0, scrollImageW, scrollImageH);
    }
    
    [self updatePageScrollView];
}

/**
 * 更新内容
 */
- (void)updatePageScrollView {

    CGPoint offset = self.scrollView.contentOffset;
    if (offset.x > self.scrollView.width ) {//如果向右滑动
        
        self.pageControl.currentPage = (self.pageControl.currentPage + 1) % self.pageControl.numberOfPages;
        
    }else if(offset.x < self.scrollView.width){ //向左滑动
        
        self.pageControl.currentPage = (self.pageControl.currentPage - 1) % self.pageControl.numberOfPages;
    }
    
    for (NSInteger i = 0; i <  self.scrollView.subviews.count; i++) {
        
        UIImageView *image = (UIImageView *)self.scrollView.subviews[i];
        NSInteger index = self.pageControl.currentPage;
        
        if (i == 0) {
            index--;
        }else if (i == 2) {
        
            index++;
        }
        
        if (index < 0) {
            
            index = self.pageControl.numberOfPages - 1;
        }else if (self.pageControl.numberOfPages <= index) {
        
            index = 0;
        }
        
        image.tag = index;
        [image sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArr[index]] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageContinueInBackground];
    }
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.width, 0);
}

- (void)startTimer {

    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {

    [self.timer invalidate];
    self.timer = nil;
}

- (void)next {

    [self.scrollView setContentOffset:CGPointMake(2.0 * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark --- UIScrollViewDelegate ---
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        
        UIImageView *imageView = (UIImageView *)self.scrollView.subviews[i];
        CGFloat distance = fabs(imageView.x - self.scrollView.contentOffset.x);
        if (distance < minDistance) {
            
            minDistance = distance;
            page = imageView.tag;
        }
    }
    
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self updatePageScrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    [self updatePageScrollView];
}

//#pragma mark --- setter ---
//- (void)setImageUrlArr:(NSArray *)imageUrlArr {
//
//}
@end
