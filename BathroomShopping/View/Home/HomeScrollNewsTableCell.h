//
//  HomeScrollNewsTableCell.h
//  BathroomShopping
//
//  Created by zzy on 7/20/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScrollNewsTableCell : UITableViewCell
/** 消息 */
@property(nonatomic,copy)NSString *news;
+ (instancetype)cellWithTableView:(UITableView *)table;
@end
