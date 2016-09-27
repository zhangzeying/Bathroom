//
//  Tools.m
//  BathroomShopping
//
//  Created by zzy on 8/25/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "Tools.h"

@implementation Tools
/**
 * 计算单个文件的大小
 */
+ (CGFloat)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
/**
 * 计算整个文件夹的大小
 */
+ (CGFloat)folderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    CGFloat folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[Tools fileSizeAtPath:absolutePath];
        }
        
        folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

/**
 * 清除缓存
 */
+ (void)clearCache:(NSString *)path {
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
        [SVProgressHUD showSuccessWithStatus:@"清除完毕" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

@end
