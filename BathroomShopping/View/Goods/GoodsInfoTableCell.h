//
//  GoodsInfoTableCell.h
//  BathroomShopping
//
//  Created by zzy on 8/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailModel;

@interface GoodsInfoTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,strong)GoodsDetailModel *model;
@end
