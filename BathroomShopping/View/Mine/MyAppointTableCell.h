//
//  MyAppointTableCell.h
//  BathroomShopping
//
//  Created by zzy on 9/9/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppointModel;
@interface MyAppointTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,strong)AppointModel *model;
@end
