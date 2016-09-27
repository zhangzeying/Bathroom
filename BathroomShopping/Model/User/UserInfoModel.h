//
//  UserInfoModel.h
//  BathroomShopping
//
//  Created by zzy on 8/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
/** id */
@property(nonatomic,copy)NSString *id;
/** 电话 */
@property(nonatomic,copy)NSString *tel;
/** 昵称 */
@property(nonatomic,copy)NSString *nickname;
/** 账号 */
@property(nonatomic,copy)NSString *account;
/** 性别 */
@property(nonatomic,copy)NSString *sex;
/** 头像地址 */
@property(nonatomic,copy)NSString *headPortrait;
/** 用户权限，是否可以看到图片 */
@property(assign,nonatomic)BOOL isshow;
@end
