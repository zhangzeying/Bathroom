//
//  NSString+Extension.m
//  BathroomShopping
//
//  Created by zzy on 9/9/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
/**
 * 判断是否为整数
 */
- (BOOL)isPureInt {
    
    NSScanner *scan = [NSScanner scannerWithString:self];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
}
@end
