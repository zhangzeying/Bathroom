//
//  HomeHeaderView.m
//  BathroomShopping
//
//  Created by zzy on 9/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "HomeHeaderCell.h"
#import "HomeScrollNewsView.h"
#import "PageScrollView.h"
#import "HomeService.h"
#import "RestService.h"
#import "NewsModel.h"

@interface HomeHeaderCell()
/** <##> */
@property(nonatomic,strong)HomeService *homeService;
/** <##> */
@property(nonatomic,strong)RestService *restService;

@end

@implementation HomeHeaderCell

- (HomeService *)homeService {
    
    if (_homeService == nil) {
        
        _homeService = [[HomeService alloc]init];
    }
    
    return _homeService;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if ([super initWithFrame:frame]) {
        
        //轮播图
        PageScrollView *pageScrollView = [[PageScrollView alloc]initWithIsStartTimer:YES];
        pageScrollView.height = 150;
        pageScrollView.width = ScreenW;
        self.restService = [RestService sharedService];
        [self.restService afnetworkingPost:kAPIPageScrollList parameters:nil completion:^(id myAfNetBlokResponeDic, BOOL flag) {
            
            if (flag) {
                
                NSMutableArray *imageArr = @[].mutableCopy;
                NSArray *arr = myAfNetBlokResponeDic;
                for (NSDictionary *dict in arr) {
                    
                    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, dict[@"picture"]];
                    [imageArr addObject:imageUrl];
                }
                
                pageScrollView.imageUrlArr = imageArr;
                
            }
        }];
        
        [self addSubview:pageScrollView];
        
        //滚动消息视图
        HomeScrollNewsView *homeScrollNewsview = [[HomeScrollNewsView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(pageScrollView.frame), ScreenW, 35)];
        
        [self addSubview:homeScrollNewsview];
        
        __block NSMutableArray *newsArr = @[].mutableCopy;
        [self.homeService getNewsList:^(NSArray *newsModelArr) {
            
            for (NewsModel *newsModel in newsModelArr) {
                
                [newsArr addObject:newsModel.title];
            }
            
            homeScrollNewsview.newsArr = newsArr;
        }];
    }
    
    return self;
}

@end
