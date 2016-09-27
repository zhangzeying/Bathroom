//
//  ShoppingCartModel.h
//  BathroomShopping
//
//  Created by zzy on 8/11/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartModel : NSObject
/** 购物车商品列表 */
@property(nonatomic,strong)NSMutableArray *productList;
/** 购物车商品总数 */
@property(assign,nonatomic)NSInteger cartCount;
@end
