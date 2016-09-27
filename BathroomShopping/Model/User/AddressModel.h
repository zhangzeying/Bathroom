//
//  AddressModel.h
//  BathroomShopping
//
//  Created by zzy on 8/25/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
/** <##> */
@property(nonatomic,copy)NSString *code;
/** <##> */
@property(nonatomic,copy)NSString *name;
/** <##> */
@property(nonatomic,strong)NSMutableArray *childrenArr;

@end
