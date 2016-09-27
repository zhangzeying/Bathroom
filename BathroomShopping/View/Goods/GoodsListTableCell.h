//
//  GoodsListTableCell.h
//  BathroomShopping
//
//  Created by zzy on 9/8/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCartDetailModel;
@interface GoodsListTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,strong)ShoppingCartDetailModel *model;
@end
