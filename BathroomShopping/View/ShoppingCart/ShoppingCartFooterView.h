//
//  ShoppingCartFooterView.h
//  BathroomShopping
//
//  Created by zzy on 7/15/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCartModel;
typedef void(^CalculateBlock)();
typedef void(^CheckBlock)(BOOL);
@interface ShoppingCartFooterView : UIView
+ (ShoppingCartFooterView *)instanceFooterView;
/** <##> */
@property(copy,nonatomic)CalculateBlock calculateBlock;
/** <##> */
@property(nonatomic,copy)CheckBlock checkBlock;
/** <##> */
@property(nonatomic,strong)ShoppingCartModel *model;

@property (weak, nonatomic) IBOutlet UIButton *checkBox;
/** <##> */
@property(assign,nonatomic)BOOL isEditing;
/** <##> */
@property(assign,nonatomic)double totalMoney;
@end
