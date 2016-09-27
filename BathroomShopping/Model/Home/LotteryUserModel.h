//
//  LotteryUserModel.h
//  BathroomShopping
//
//  Created by zzy on 8/23/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotteryUserModel : NSObject
/** 中奖账号 */
@property(nonatomic,copy)NSString *account;
/** 昵称 */
@property(nonatomic,copy)NSString *nikeName;
/** 中奖名称 */
@property(nonatomic,copy)NSString *productName;
/** 头像url */
@property(nonatomic,copy)NSString *headPortrait;
/** 中奖时间 */
@property(nonatomic,copy)NSString *createTime;
@end
