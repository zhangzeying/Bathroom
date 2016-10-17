//
//  OrderDetailGoodsTableCell.h
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailModel;
@interface OrderDetailGoodsTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,strong)OrderDetailModel *model;
@end
