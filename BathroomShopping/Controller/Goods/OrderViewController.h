//
//  OrderViewController.h
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderViewController : BaseViewController
typedef NS_ENUM(NSInteger, OrderType){
    
    NoPayOrder, //待付款订单
    NoReceiveOrder, //待收货订单
    MyOrder, //我的订单
    NoSendOrder //待发货订单
};
/** <##> */
@property(assign,nonatomic)OrderType orderType;
@end
