//
//  ReceiverAddressModel.h
//  BathroomShopping
//
//  Created by zzy on 8/28/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiverAddressModel : NSObject
/** 地址id */
@property(nonatomic,copy)NSString *id;
/** 收货人账号 */
@property(nonatomic,copy)NSString *account;
/** 地址（街道。。） */
@property(nonatomic,copy)NSString *address;
/** 省市区 */
@property(nonatomic,copy)NSString *pcadetail;
/** 手机号 */
@property(nonatomic,copy)NSString *mobile;
/** 收货人姓名 */
@property(nonatomic,copy)NSString *name;
/** 省code */
@property(nonatomic,copy)NSString *province;
/** 市code */
@property(nonatomic,copy)NSString *city;
/** 区code */
@property(nonatomic,copy)NSString *area;
/** 是否是默认地址 */
@property(nonatomic,assign)BOOL isdefault;
/** 是否被选中 */
@property(assign,nonatomic)BOOL isSelected;
@end
