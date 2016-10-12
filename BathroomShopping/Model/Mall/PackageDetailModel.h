//
//  PackageDetailModel.h
//  BathroomShopping
//
//  Created by zzy on 10/10/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageDetailModel : NSObject
/** <##> */
@property(nonatomic,copy)NSString *allName;
/** <##> */
@property(nonatomic,strong)NSMutableArray *specAllList;
/** <##> */
@property(assign,nonatomic)double sellCount;
/** <##> */
@property(nonatomic,copy)NSString *picture;
/** <##> */
@property(assign,nonatomic)double totalPrice;
/** <##> */
@property(assign,nonatomic)CGFloat cellHeight;
@end
