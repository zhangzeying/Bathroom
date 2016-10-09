//
//  CustomRefreshHeader.m
//  BathroomShopping
//
//  Created by zzy on 10/8/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "CustomRefreshHeader.h"

@implementation CustomRefreshHeader

- (void)placeSubviews
{
    [super placeSubviews];
    self.gifView.frame = self.bounds;
    //    self.gifView.superview.backgroundColor = [UIColor purpleColor];
    self.gifView.contentMode = UIViewContentModeTop;
    
    CGRect lbRect = self.stateLabel.frame;
    lbRect.origin.y += 20;
    self.stateLabel.frame = lbRect;
    self.stateLabel.font = [UIFont systemFontOfSize:12];
}

- (void)prepare {

    [super prepare];
    self.lastUpdatedTimeLabel.hidden = YES;
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松手开始刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    
    
//    self.stateLabel.textColor = kRGBA(249, 209, 88, 1);
    
    [self setImages:[self animateImages] forState:MJRefreshStateIdle];
    [self setImages:[self animateImages] forState:MJRefreshStatePulling];
}

- (NSArray<UIImage *> *)animateImages{
    
    NSArray *imageNames = @[@"transition_00000", @"transition_00001", @"transition_00002", @"transition_00003", @"transition_00004", @"transition_00005", @"transition_00006", @"transition_00007", @"transition_00008", @"transition_00009", @"transition_00010",@"transition_00011"];
    NSMutableArray *images = [NSMutableArray new];
    [imageNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [images addObject:[UIImage imageNamed:obj]];
    }];
    return images.copy; 
}

@end
