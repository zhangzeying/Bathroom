//
//  UpdateUserInfoViewController.h
//  BathroomShopping
//
//  Created by zzy on 8/20/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger ,UserInfoType){
    
    NickName, //昵称
};

typedef void(^UpdateUserInfoBlock)(NSString *);
@interface UpdateUserInfoViewController : BaseViewController
/** <##> */
@property(assign,nonatomic)UserInfoType userInfoType;
/** <##> */
@property(nonatomic,copy)UpdateUserInfoBlock updateUserInfoBlock;
@end
