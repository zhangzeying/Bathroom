//
//  ConfirmOrder.h
//  BathroomShopping
//
//  Created by zzy on 11/17/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfirmOrderModel : NSObject
/** <##> */
@property(nonatomic,strong)NSMutableArray *expressList;
/** <##> */
@property(nonatomic,strong)NSMutableArray *addressList;
/** <##> */
@property(nonatomic,strong)NSMutableArray *productList;
/** <##> */
@property(nonatomic,strong)NSMutableArray *proPackageList;
@end
