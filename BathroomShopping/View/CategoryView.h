//
//  CategoryView.h
//  BathroomShopping
//
//  Created by zzy on 7/28/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsCategoryModel;
typedef NS_ENUM(NSInteger ,CategoryType){
    Bath, //卫浴
    Mall, //商城
};

typedef void(^CategoryViewBlock)(GoodsCategoryModel *model);
@interface CategoryView : UIView
/** 商品类别数组模型 */
@property(nonatomic,strong)NSMutableArray *categoryArr;
/** 类别的类型（商城or卫浴） */
@property(assign,nonatomic)CategoryType categoryType;
/** <##> */
@property(nonatomic,copy)CategoryViewBlock categoryViewBlock;
@end
