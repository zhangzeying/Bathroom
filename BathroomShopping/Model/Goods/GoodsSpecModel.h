//
//  GoodsSpecModel.h
//  BathroomShopping
//
//  Created by zzy on 8/21/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsSpecModel : NSObject<NSCoding>
/** 规格ID */
@property(nonatomic,copy)NSString *id;
/** 颜色 */
@property(nonatomic,copy)NSString *specColor;
/** 尺码 */
@property(nonatomic,copy)NSString *specSize;
/** 规格价格 */
@property(nonatomic,assign)double specPrice;
/** 库存 */
@property(assign,nonatomic)NSInteger specStock;

/** <##> */
@property(nonatomic,copy)NSString *specIds;
/** <##> */
@property(nonatomic,copy)NSString *specColors;
@end
