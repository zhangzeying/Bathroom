//
//  AddressView.h
//  BathroomShopping
//
//  Created by zzy on 8/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddressViewBlock)();
@interface AddressView : UIView
@property(nonatomic,copy)AddressViewBlock addressViewBlock;
@end
