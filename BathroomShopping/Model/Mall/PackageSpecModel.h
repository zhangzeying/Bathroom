//
//  PackageSpecModel.h
//  BathroomShopping
//
//  Created by zzy on 10/10/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageSpecModel : NSObject
/** <##> */
@property(assign,nonatomic)NSInteger minStock;
/** <##> */
@property(nonatomic,copy)NSString *productIds;
/** <##> */
@property(nonatomic,copy)NSString *specDesc;
/** <##> */
@property(nonatomic,copy)NSString *specIds;
@end
