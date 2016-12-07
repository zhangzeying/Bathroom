//
//  HotGoodsCollectionCell.h
//  BathroomShopping
//
//  Created by zzy on 7/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityGoodsDetailModel;
@class MallPackageModel;
@interface HotGoodsCollectionCell : UICollectionViewCell
/** 模型 */
@property(nonatomic,strong)ActivityGoodsDetailModel *model;
/** 模型 */
@property(nonatomic,strong)MallPackageModel *packageModel;
@end
