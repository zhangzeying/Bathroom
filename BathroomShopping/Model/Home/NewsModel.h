//
//  NewsModel.h
//  BathroomShopping
//
//  Created by zzy on 7/20/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
/** id */
@property(nonatomic,copy)NSString *id;
/** 标题 */
@property(nonatomic,copy)NSString *title;
/** 内容 */
@property(nonatomic,copy)NSString *content;
/** 创建时间 */
@property(nonatomic,copy)NSString *createtime;
@end
