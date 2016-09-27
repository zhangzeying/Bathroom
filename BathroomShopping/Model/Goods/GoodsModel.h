//
//  GoodsModel.h
//  BathroomShopping
//
//  Created by zzy on 8/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject
/** 总数 */
@property(assign,nonatomic)NSInteger total;
/** 总页数 */
@property(assign,nonatomic)NSInteger pagerSize;
/** 商品列表 */
@property(nonatomic,strong)NSMutableArray *list;
@end
