//
//  GoodsCategoryModel.h
//  BathroomShopping
//
//  Created by zzy on 8/4/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsCategoryModel : NSObject
/** id */
@property(nonatomic,copy)NSString *id;
/** 类别名称 */
@property(nonatomic,copy)NSString *name;
/** 类别拼音 */
@property(nonatomic,copy)NSString *code;
/** 图标 */
@property(nonatomic,strong)NSString *picture;

#pragma mark --- 辅助属性 ---
/** <##> */
@property(nonatomic,assign)NSInteger index;
@end
