//
//  OneMoneySaleTableCell.h
//  BathroomShopping
//
//  Created by zzy on 7/25/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailModel;
@class ShoppingCartDetailModel;
typedef void(^LotteryBlock)(ShoppingCartDetailModel *);
@interface OneMoneySaleTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** 商品数据模型 */
@property(nonatomic,strong)GoodsDetailModel *model;
@property (weak, nonatomic) IBOutlet UILabel *dayLbl;
@property (weak, nonatomic) IBOutlet UILabel *hourLbl;
@property (weak, nonatomic) IBOutlet UILabel *minuteLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondsLbl;
/** <##> */
@property(nonatomic,copy)LotteryBlock lotteryBlock;
@end
