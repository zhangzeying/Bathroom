//
//  Tools.h
//  BathroomShopping
//
//  Created by zzy on 8/25/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
/**
 * 计算整个文件夹的大小
 */
+ (CGFloat)folderSizeAtPath:(NSString *)path;
/**
 * 清除缓存
 */
+ (void)clearCache:(NSString *)path;
@end
