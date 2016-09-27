//
//  LimitTimeBuyModel.h
//  BathroomShopping
//
//  Created by zzy on 9/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark --- 限时抢购数据模型 ---
@interface LimitTimeBuyModel : NSObject
/** <##> */
@property(nonatomic,copy)NSString *startDate;
/** <##> */
@property(nonatomic,copy)NSString *endDate;
/** <##> */
@property(nonatomic,copy)NSString *startTime;
/** <##> */
@property(nonatomic,strong)NSMutableArray *products;
@end
