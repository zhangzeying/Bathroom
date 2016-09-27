//
//  AppointDetailModel.h
//  BathroomShopping
//
//  Created by zzy on 9/21/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointDetailModel : NSObject
/** <##> */
@property(nonatomic,copy)NSString *singleSpecColor;
/** <##> */
@property(nonatomic,copy)NSString *singleSpecSize;
/** <##> */
@property(assign,nonatomic)double specPrice;
/** <##> */
@property(nonatomic,copy)NSString *picture;
/** <##> */
@property(nonatomic,copy)NSString *name;
@end
