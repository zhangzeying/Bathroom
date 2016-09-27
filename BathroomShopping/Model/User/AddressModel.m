//
//  AddressModel.m
//  BathroomShopping
//
//  Created by zzy on 8/25/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
- (NSMutableArray *)childrenArr
{
    if (!_childrenArr) {
        
        self.childrenArr = [NSMutableArray array];
    }
    return _childrenArr;
}
@end
