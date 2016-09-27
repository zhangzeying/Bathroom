//
//  GoodsCategoryTableCell.h
//  BathroomShopping
//
//  Created by zzy on 7/14/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCategoryTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@end
