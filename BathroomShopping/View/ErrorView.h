//
//  ErrorView.h
//  BathroomShopping
//
//  Created by zzy on 9/11/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorView : UIView
/** <##> */
@property(nonatomic,copy)NSString *btnTitle;
/** <##> */
@property(nonatomic,copy)NSString *warnStr;
/** <##> */
@property(nonatomic,copy)NSString *imgName;
- (void)setTarget:(id)target action:(SEL)action;
@end
