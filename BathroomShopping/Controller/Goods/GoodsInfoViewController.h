//
//  GoodsInfoViewController.h
//  BathroomShopping
//
//  Created by zzy on 7/26/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BaseViewController.h"
@class MallPackageModel;

@interface GoodsInfoViewController : BaseViewController
- (instancetype)initWithGoodsId:(NSString *)goodsId packgeModel:(MallPackageModel *)packgeModel;
@end
