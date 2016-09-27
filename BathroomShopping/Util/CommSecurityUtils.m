//
//  CommSecurityUtils.m
//  BathroomShopping
//
//  Created by zzy on 7/30/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "CommSecurityUtils.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation CommSecurityUtils
#pragma mark 编码,普通字符串转换成Base64
+ (NSString*)encodeBase64String:(NSString* )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
#pragma mark 解码，Base64转换成普通字符串
+ (NSString*)decodeBase64String:(NSString* )input {
    NSData*data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

#pragma mark - MD5加密
+(NSString *) md5HexDigest:(NSString *)string
{
    if(!string || string.length == 0) return @"";
    
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02x", result[i]];
    return [hash lowercaseString];
}
@end
