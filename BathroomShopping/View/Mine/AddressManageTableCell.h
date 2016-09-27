//
//  AddressManageTableCell.h
//  BathroomShopping
//
//  Created by zzy on 8/20/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReceiverAddressModel;


@protocol AddressManageDelegate <NSObject>

@optional
/**
 * 编辑地址
 */
- (void)editAddress:(ReceiverAddressModel *)model;

@optional
/**
 * 删除地址
 */
- (void)deleteAddress:(ReceiverAddressModel *)model;

@end

@interface AddressManageTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,strong)ReceiverAddressModel *model;
@property (nonatomic,weak) id<AddressManageDelegate> delegate;
@end
