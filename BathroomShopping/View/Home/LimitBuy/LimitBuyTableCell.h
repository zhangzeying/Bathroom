//
//  LimitBuyTableCell.h
//  BathroomShopping
//
//  Created by zzy on 9/21/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LimitBuyProductModel;
typedef NS_ENUM(NSInteger ,StateType){
    Buying, //抢购中
    WillBuy, //即将开抢
};
typedef void(^LimitBuyBlock)(NSString *);
@interface LimitBuyTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,strong)LimitBuyProductModel *model;
/** <##> */
@property(nonatomic,copy)LimitBuyBlock limitBuyBlock;
/** <##> */
@property(assign,nonatomic)StateType stateType;
@end
