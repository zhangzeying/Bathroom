//
//  MyLikedTableCell.h
//  BathroomShopping
//
//  Created by zzy on 9/7/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailModel;
@interface MyLikedTableCell : UITableViewCell
/** <##> */
@property(nonatomic,strong)GoodsDetailModel *model;
+ (instancetype)cellWithTableView:(UITableView *)table;
@end
