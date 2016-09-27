//
//  GoodsInfoDetailViewController.h
//  BathroomShopping
//
//  Created by zzy on 8/4/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BaseViewController.h"

@protocol GoodsInfoDetailDelegate <NSObject>

- (void)pullDown;

@end

@interface GoodsInfoDetailViewController : BaseViewController
@property (nonatomic,weak) id<GoodsInfoDetailDelegate> delegate;
/** <##> */
@property(nonatomic,copy)NSString *imageUrl;
@end
