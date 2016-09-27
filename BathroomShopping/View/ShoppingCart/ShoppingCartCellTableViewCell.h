//
//  ShoppingCartCellTableViewCell.h
//  BathroomShopping
//
//  Created by zzy on 7/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCartModel;
@class ShoppingCartDetailModel;
@protocol ShoppingCartDelegate <NSObject>

- (void)check:(ShoppingCartDetailModel *)model;
- (void)cartDelete:(UITableViewCell *)cell model:(ShoppingCartDetailModel *)model;
- (void)changeBuyCount;
- (void)appoint:(ShoppingCartDetailModel *)model;
@end

@interface ShoppingCartCellTableViewCell : UITableViewCell
@property(nonatomic,strong)ShoppingCartDetailModel *detailModel;
@property (nonatomic,weak) id<ShoppingCartDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)table;

@end
