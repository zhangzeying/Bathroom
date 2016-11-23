//
//  ProPackageModel.h
//  BathroomShopping
//
//  Created by zzy on 11/17/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProPackageModel : NSObject
/** <##> */
@property(nonatomic,copy)NSString *id;
/** <##> */
@property(nonatomic,copy)NSString *specDesc;
/** <##> */
@property(nonatomic,assign)double packagePice;
/** <##> */
@property(nonatomic,copy)NSString *picture;
/** <##> */
@property(nonatomic,assign)double buyCount;
/** <##> */
@property(nonatomic,copy)NSString *name;
/** <##> */
@property(nonatomic,strong)NSMutableArray *productList;

@end
