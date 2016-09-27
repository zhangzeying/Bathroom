//
//  SpecificationTableCell.h
//  BathroomShopping
//
//  Created by zzy on 8/15/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecificationTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,copy)NSString *specStr;
@end
