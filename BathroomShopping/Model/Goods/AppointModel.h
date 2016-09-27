//
//  AppointModel.h
//  BathroomShopping
//
//  Created by zzy on 9/9/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppointDetailModel;
@interface AppointModel : NSObject
/** 规格id */
@property(nonatomic,copy)NSString *buySpecID;
@property(nonatomic,copy)NSString *productID;
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,assign)NSInteger reserveNum;
/** <##> */
@property(nonatomic,copy)NSString *createTime;
/** <##> */
@property(nonatomic,strong)NSDictionary *product;
/** <##> */
@property(nonatomic,strong)AppointDetailModel *detailModel;
@end
