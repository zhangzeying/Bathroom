//
//  GradualLabel.h
//  BathroomShopping
//
//  Created by zzy on 9/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradualLabel : UILabel
///  变色比例  0~1
@property (nonatomic, assign) CGFloat colorRatio;
///  混合颜色
@property (nonatomic, strong) UIColor *blendColor;
@end
