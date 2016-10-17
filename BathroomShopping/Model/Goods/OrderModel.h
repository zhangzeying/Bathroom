//
//  OrderModel.h
//  BathroomShopping
//
//  Created by zzy on 9/22/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
/** 订单id */
@property(nonatomic,copy)NSString *id;
/** 创建日期 */
@property(nonatomic,copy)NSString *createdate;
/**  */
@property(nonatomic,copy)NSString *remark;
/** 总价 */
@property(assign,nonatomic)double amount;
/** 运费 */
@property(assign,nonatomic)double fee;
/** 配送方式 */
@property(nonatomic,copy)NSString *expressName;
/** 订单号 */
@property(nonatomic,copy)NSString *orderpayID;
/** 订单明细商品数组 */
@property(nonatomic,strong)NSMutableArray *orders;
/** 商品总数 */
@property(assign,nonatomic)NSInteger productsNum;
/** n，表示未支付 y 表示已支付 */
@property(nonatomic,copy)NSString *paystatus;
/** init表示已付款，send表示已发货，sign，表示签收 */
@property(nonatomic,copy)NSString *status;
/** <##> */
@property(nonatomic,strong)NSDictionary *ordership;
@end
