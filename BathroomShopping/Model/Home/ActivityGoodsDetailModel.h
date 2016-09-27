//
//  ActivityGoodsDetailModel.h
//  BathroomShopping
//
//  Created by zzy on 7/22/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ActivityType) {
    
    Perference,
    OneYuan,
    Buy
};

@interface ActivityGoodsDetailModel : NSObject
/** id */
@property(nonatomic,copy)NSString *id;
/** 商品名称 */
@property(nonatomic,copy)NSString *name;
/** 商品介绍 */
@property(nonatomic,copy)NSString *introduce;
/** 原价 */
@property(nonatomic,copy)NSString *price;
/** 现价 */
@property(nonatomic,assign)NSString *nowPrice;
/** 图片 */
@property(nonatomic,copy)NSString *picture;
/** 活动价格 */
@property(nonatomic,copy)NSString *finalPrice;
/** 活动截止日期 */
@property(nonatomic,copy)NSString *activityEndDateTime;
/** 已售数量 */
@property(assign,nonatomic)NSInteger sellCount;


// ----- 辅助属性 -----
/** 活动类型(用来区分是什么活动) */
@property(assign,nonatomic)ActivityType activityType;
@end
