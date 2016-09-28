//
//  MallTableCell.h
//  BathroomShopping
//
//  Created by zzy on 7/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MallPackageModel;

@interface MallTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** 模型 */
@property(nonatomic,strong)MallPackageModel *model;
@end
