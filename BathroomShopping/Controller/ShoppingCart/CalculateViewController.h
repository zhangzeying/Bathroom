//
//  CalculateViewController.h
//  BathroomShopping
//
//  Created by zzy on 8/16/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BaseViewController.h"

@interface CalculateViewController : BaseViewController
/** <##> */
@property(nonatomic,strong)NSDictionary *params;
/** 是否是一元抢购抽奖下订单 */
@property(assign,nonatomic)BOOL isOneMoneyLottery;
@end
