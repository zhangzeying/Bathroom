//
//  LimitBuyProductModel.h
//  BathroomShopping
//
//  Created by zzy on 9/22/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LimitBuyProductModel : NSObject
/** <##> */
@property(nonatomic,copy)NSString *id;
/** <##> */
@property(nonatomic,copy)NSString *name;
/**  */
@property(assign,nonatomic)double price;
/** <##> */
@property(nonatomic,copy)NSString *picture;
/** <##> */
@property(assign,nonatomic)NSInteger stock;
/** <##> */
@property(assign,nonatomic)double finalPrice;
/** <##> */
@property(assign,nonatomic)NSInteger buyCount;
/** <##> */
@property(assign,nonatomic)NSInteger sellcount;
@end
