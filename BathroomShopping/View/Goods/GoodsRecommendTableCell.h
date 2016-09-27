//
//  GoodsRecommendTableCell.h
//  BathroomShopping
//
//  Created by zzy on 8/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GoodsRecommendTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,strong)NSMutableArray *recommendGoodsArr;
/** <##> */
@property(assign,nonatomic)CGFloat cellHeight;
+ (CGFloat)getCellHeight:(NSMutableArray *)recommendGoodsArr;
@end
