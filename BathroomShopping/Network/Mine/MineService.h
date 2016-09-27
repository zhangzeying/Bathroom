//
//  MineService.h
//  BathroomShopping
//
//  Created by zzy on 8/19/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineService : NSObject
/**
 * 上传头像
 */
- (void)uploadAvator:(UIImage *)headPortrait completion :(void(^)(id))completion;
/**
 * 修改个人信息
 */
- (void)updateUserInfo:(NSString *)nickname completion :(void(^)())completion;
/**
 * 获取我的地址
 */
- (void)getAddressList:(void(^)(id))completion;
/**
 * 保存地址
 */
- (void)saveAddress:(NSDictionary *)param completion:(void(^)())completion;
/**
 * 删除地址
 */
- (void)deleteAddress:(NSString *)addressId completion:(void(^)())completion;
/**
 * 修改密码
 */
- (void)updatePassword:(NSDictionary *)params completion:(void(^)())completion;
/**
 * 获取我的收藏
 */
- (void)getLikedGoodsList:(void(^)(id))completion;
/**
 * 获取商品预约
 */
- (void)getAppointList:(void(^)(id))completion;
/**
 * 获取商品预约
 */
- (void)getUserRoot;
/**
 * 获取关于我们公司介绍
 */
- (void)getAboutContent:(void(^)(id))completion;
@end
