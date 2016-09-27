//
//  OneMoneySaleHeaderView.h
//  BathroomShopping
//
//  Created by zzy on 7/25/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailModel;

@interface OneMoneySaleHeaderView : UIView
+ (OneMoneySaleHeaderView *)instanceHeaderView;
/** 商品数据模型 */
@property(nonatomic,strong)GoodsDetailModel *model;
@end
