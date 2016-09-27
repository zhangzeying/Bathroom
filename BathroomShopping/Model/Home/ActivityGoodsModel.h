//
//  ActivityGoodsModel.h
//  BathroomShopping
//
//  Created by zzy on 7/21/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LimitTimeBuyModel;

@interface ActivityGoodsModel : NSObject
/** 商城特惠 */
@property(nonatomic,strong)NSMutableArray *perference;
/** 一元抢购 */
@property(nonatomic,strong)NSMutableArray *oneYuan;
/** 限时抢购数据模型 */
@property(nonatomic,strong)LimitTimeBuyModel *buyModel;
/** 总数 */
@property(assign,nonatomic)NSInteger total;
/** 总页数 */
@property(assign,nonatomic)NSInteger pagerSize;
/** 商品列表 */
@property(nonatomic,strong)NSMutableArray *list;
@end
