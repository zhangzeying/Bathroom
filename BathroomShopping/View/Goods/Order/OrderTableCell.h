//
//  OrderTableCell.h
//  BathroomShopping
//
//  Created by zzy on 9/28/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface OrderTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,strong)OrderModel *model;
@end
