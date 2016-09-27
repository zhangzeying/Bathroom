//
//  GoodsInfoDetailViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/4/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsInfoDetailViewController.h"
#import "GoodsRefreshHeader.h"

@interface GoodsInfoDetailViewController ()
/** <##> */
@property(nonatomic,strong)UIScrollView *scroll;
/** <##> */
@property (nonatomic, weak) UIImageView *image;
@end

@implementation GoodsInfoDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.scroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scroll.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.scroll.contentSize = CGSizeMake(0, 2 * ScreenH);
    [self.view addSubview:self.scroll];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.scroll addSubview:image];
    self.image = image;
    [self setupRefresh];
}

- (void)setupRefresh {

    self.scroll.mj_header = [GoodsRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDown)];
}

- (void)pullDown {

    [self.scroll.mj_header endRefreshing];
    if ([self.delegate respondsToSelector:@selector(pullDown)]) {
        
        [self.delegate pullDown];
    }
}

- (void)setImageUrl:(NSString *)imageUrl {

    [self.image sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
