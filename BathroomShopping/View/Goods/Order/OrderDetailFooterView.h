//
//  OrderDetailFooterView.h
//  BathroomShopping
//
//  Created by zzy on 8/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^FooterViewBlock)(NSString *btnType);
@interface OrderDetailFooterView : UIView
+ (OrderDetailFooterView *)instanceFooterView;
/** <##> */
@property(nonatomic,copy)FooterViewBlock footerViewBlock;
@end
