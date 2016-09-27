//
//  ActivityGoodsHeaderView.h
//  BathroomShopping
//
//  Created by zzy on 7/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityGoodsDetailModel;
@class LimitTimeBuyModel;
@protocol ActivityGoodsHeaderDelegate <NSObject>

- (void)more:(NSInteger)activityType;

@end

@interface ActivityGoodsHeaderView : UICollectionReusableView
/** 模型 */
@property(nonatomic,strong)ActivityGoodsDetailModel *model;
/** delegate */
@property (nonatomic, weak)id <ActivityGoodsHeaderDelegate>delegate;
/** <##> */
@property(nonatomic,strong)LimitTimeBuyModel *buyModel;
@end
