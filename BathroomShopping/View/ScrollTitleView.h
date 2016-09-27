//
//  ScrollTitleView.h
//  BathroomShopping
//
//  Created by zzy on 7/31/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollTitleViewDelegate <NSObject>

- (void)scroll:(NSInteger)index;

@end

@interface ScrollTitleView : UIView
/** <##> */
@property(nonatomic,strong)NSMutableArray *titleArr;
/** <##> */
@property(assign,nonatomic)NSInteger index;
@property (nonatomic,weak) id<ScrollTitleViewDelegate> delegate;
@end
