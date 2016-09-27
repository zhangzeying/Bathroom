//
//  SelectAddressView.h
//  BathroomShopping
//
//  Created by zzy on 8/18/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectAddressViewBlock)(id);
@interface SelectAddressView : UIView
/** <##> */
@property(nonatomic,copy)SelectAddressViewBlock selectAddressViewBlock;
@end
