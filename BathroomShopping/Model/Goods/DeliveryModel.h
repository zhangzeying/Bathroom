//
//  DeliveryModel.h
//  BathroomShopping
//
//  Created by zzy on 8/30/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryModel : NSObject
/** 配送方式id */
@property(nonatomic,copy)NSString *id;
/** 配送方式code */
@property(nonatomic,copy)NSString *code;
/** 配送方式名称 */
@property(nonatomic,copy)NSString *name;
/** 运费 */
@property(assign,nonatomic)double fee;
@end
