//
//  UIImage+Rotate.h
//  BathroomShopping
//
//  Created by zzy on 11/26/15.
//  Copyright © 2015 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotate)

+ (UIImage *)rotateImage:(UIImage *)aImage orientation:(int)aOrientation;
- (UIImage *)fixOrientation;
@end
