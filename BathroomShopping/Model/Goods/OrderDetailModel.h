//
//  OrderDetailModel.h
//  BathroomShopping
//
//  Created by zzy on 9/22/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject
/** <##> */
@property(nonatomic,copy)NSString *productID;
/** <##> */
@property(nonatomic,copy)NSString *productName;
/** <##> */
@property(nonatomic,copy)NSString *picture;
/** <##> */
@property(assign,nonatomic)double price;
/** <##> */
@property(assign,nonatomic)NSInteger quantity;
@end
