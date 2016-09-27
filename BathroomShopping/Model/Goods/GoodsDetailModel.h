//
//  GoodsDetailModel.h
//  BathroomShopping
//
//  Created by zzy on 8/17/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GoodsSpecModel;

@interface GoodsDetailModel : NSObject
/** 商品id */
@property(nonatomic,copy)NSString *id;
/** 商品名称 */
@property(nonatomic,copy)NSString *name;
/** 商品图片url */
@property(nonatomic,copy)NSString *picture;
/** 已售数量 */
@property(assign,nonatomic)NSInteger sellCount;
/** 是否收藏 */
@property(assign,nonatomic)BOOL favorite;
/** 收藏数量 */
@property(assign,nonatomic)NSInteger favCount;
/** 原价 */
@property(nonatomic,copy)NSString *price;
/** 现价 */
@property(nonatomic,copy)NSString *nowPrice;
/** 活动参与人数 */
@property(assign,nonatomic)NSInteger partNumber;
/** 活动结束时间 */
@property(nonatomic,copy)NSString *activityEndDateTime;
/** 轮播图数组 */
@property(nonatomic,strong)NSMutableArray *productImageList;
/** 规格数组 */
@property(nonatomic,strong)NSMutableArray *specList;
/** 所属类别ID */
@property(nonatomic,copy)NSString *catalogID;
#pragma mark --- 辅助属性 ---
/** cell的高度 */
@property(assign,nonatomic)CGFloat cellHeight;
@end
