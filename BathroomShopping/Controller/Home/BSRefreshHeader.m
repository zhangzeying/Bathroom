//
//  BSRefreshHeader.m
//  BathroomShopping
//
//  Created by zzy on 9/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BSRefreshHeader.h"

@implementation BSRefreshHeader

- (void)prepare {

    [super prepare];
    self.stateLabel.hidden = NO;
    self.lastUpdatedTimeLabel.hidden = YES;
    [self setImages:nil forState:MJRefreshStateIdle];
    [self setImages:nil forState:MJRefreshStatePulling];
    [self setImages:nil forState:MJRefreshStateRefreshing];
//    setImages([UIImage(named: "v2_pullRefresh1")!], forState: MJRefreshState.Idle)
//    setImages([UIImage(named: "v2_pullRefresh2")!], forState: MJRefreshState.Pulling)
//    setImages([UIImage(named: "v2_pullRefresh1")!, UIImage(named: "v2_pullRefresh2")!], forState: MJRefreshState.Refreshing)
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松手开始刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];

}

@end
