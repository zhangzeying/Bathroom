//
//  MyButton.m
//  BathroomShopping
//
//  Created by zzy on 8/18/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (void)layoutSubviews {

    [super layoutSubviews];
    self.imageView.height = self.titleLabel.height;
    self.imageView.centerY = self.titleLabel.centerY;
    self.imageView.width = self.imageView.height;
    self.imageView.centerX = self.width / 2 - self.imageView.width / 2 - 14;
    self.titleLabel.centerX = self.width / 2 + self.titleLabel.width / 2 - 8;
}

@end
