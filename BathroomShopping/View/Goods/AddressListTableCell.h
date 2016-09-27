//
//  AddressListTableCell.h
//  BathroomShopping
//
//  Created by zzy on 9/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReceiverAddressModel;    
@interface AddressListTableCell : UITableViewCell
/** <##> */
@property(nonatomic,strong)ReceiverAddressModel *model;
+ (instancetype)cellWithTableView:(UITableView *)table;
@end
