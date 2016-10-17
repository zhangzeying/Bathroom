//
//  OrderDetailHeaderView.h
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface OrderDetailHeaderView : UIView
+ (OrderDetailHeaderView *)instanceHeaderView;
/** <##> */
@property(nonatomic,strong)OrderModel *model;
@end
