//
//  GoodsRecommendView.h
//  BathroomShopping
//
//  Created by zzy on 8/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailModel;

@interface GoodsRecommendView : UIView
+ (GoodsRecommendView *)instanceView;
/** <##> */
@property(nonatomic,strong)GoodsDetailModel *model;
@end
