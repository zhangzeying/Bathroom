//
//  PageScrollView.m
//  BathroomShopping
//
//  Created by zzy on 7/7/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "PageScrollView.h"
#import "UserInfoModel.h"
#define imageViewMaxCount 3

@interface PageScrollView()<UIScrollViewDelegate>

/** scrollview */
@property (nonatomic, weak)UIScrollView *scrollView;
/** pagecontrol */
@property (nonatomic, weak)UIPageControl *pageControl;
/** 计时器 */
@property(nonatomic,strong)NSTimer *timer;
/** <##> */
@property(assign,nonatomic)BOOL flag;

@end

@implementation PageScrollView

- (instancetype)initWithIsStartTimer:(BOOL)flag {
    self = [super init];
    if (self) {
        
        self.flag = flag;
    }
    return self;
}

- (void)initView {

    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = self.imageUrlArr.count;
    pageControl.userInteractionEnabled = YES;
    pageControl.pageIndicatorTintColor = CustomColor(182, 182, 182);
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.hidesForSinglePage = YES;
    
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired = 1;
    for (int i = 0; i < imageViewMaxCount; i++) {
        
        UIImageView *scrollImage = [[UIImageView alloc]init];
        scrollImage.tag = i;
        [scrollImage addGestureRecognizer:tap];
        scrollImage.userInteractionEnabled = YES;
        [scrollView addSubview:scrollImage];
    }
    
    if (self.flag) {
        
        [self startTimer];
    }
    
}

#pragma mark --- 布局子控件 ---
- (void)layoutSubviews {

    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(imageViewMaxCount * self.scrollView.width, 0);
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
    CGFloat pageControlW = pageControlSize.width;
    CGFloat pageControlH = 20;
    self.pageControl.frame = CGRectMake(self.scrollView.width - pageControlW - 10, self.scrollView.height - pageControlH - 5, pageControlW, pageControlH);
    
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
        
        if (!self.flag) {
            
            UserInfoModel *userModel = [[CommUtils sharedInstance] fetchUserInfo];
            if (userModel.isshow) {
                
                [image sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArr[index]] placeholderImage:nil];
                
            }else {
                
                image.image = [UIImage imageNamed:@"sys_xiao8"];
                image.contentMode = UIViewContentModeScaleAspectFit;
            }
            
        }else {
        
            [image sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArr[index]] placeholderImage:nil];
        }
        
        
        
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

    if (self.flag) {
        
        [self stopTimer];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (self.flag) {
        
       [self startTimer];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self updatePageScrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    [self updatePageScrollView];
}

- (void)tapClick:(UITapGestureRecognizer *)sender {

}

//#pragma mark --- setter ---
- (void)setImageUrlArr:(NSArray *)imageUrlArr {

    _imageUrlArr = imageUrlArr;
    [self initView];
    [self setNeedsLayout];
}
@end
