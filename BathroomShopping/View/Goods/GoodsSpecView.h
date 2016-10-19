//
//  GoodsSpecView.h
//  BathroomShopping
//
//  Created by zzy on 8/22/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,GoodsType){
    
    SingleGood, //单品
    Package, //套餐
};

typedef void(^GoodsSpecViewBlock)();



@interface GoodsSpecView : UIView
/** 规格模型数组 */
@property(nonatomic,strong)NSMutableArray *specModelArr;
/** <##> */
@property(nonatomic,copy)GoodsSpecViewBlock goodsSpecViewBlock;
/** 当前选择的规格 */
@property(assign,nonatomic)NSInteger currentIndex;
/** 购买数量 */
@property(assign,nonatomic)NSInteger buyNumber;
/** <##> */
@property(assign,nonatomic)GoodsType goodsType;
/** <##> */
@property(assign,nonatomic)double price;
/** <##> */
@property(nonatomic,copy)NSString *imageUrl;
@end
