//
//  MallModel.h
//  BathroomShopping
//
//  Created by zzy on 9/27/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallPackageModel : NSObject
/** <##> */
@property(nonatomic,copy)NSString *id;
/**  */
@property(nonatomic,copy)NSString *name;
/** <##> */
@property(nonatomic,copy)NSString *picture;
/** <##> */
@property(assign,nonatomic)double totalPrice;
/** <##> */
@property(assign,nonatomic)NSInteger sellCount;
/** <##> */
@property(nonatomic,strong)NSMutableArray *productList;
@end
