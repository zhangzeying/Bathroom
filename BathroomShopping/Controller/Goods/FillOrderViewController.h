//
//  FillOrderViewController.h
//  BathroomShopping
//
//  Created by zzy on 8/29/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, PageType){
    OneSale, //一元抢购
    OneGoods, //只有一个商品
    MoreGoods //多个商品
};

@interface FillOrderViewController : BaseViewController
/** <##> */
@property(assign,nonatomic)PageType pageType;
/** <##> */
@property(nonatomic,strong)NSMutableArray *goodsArr;
/** <##> */
@property(assign,nonatomic)double totalPrice;
/** <##> */
@property(nonatomic,strong)NSDictionary *params;
@end
