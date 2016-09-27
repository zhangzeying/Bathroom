//
//  HomeHeaderView.h
//  BathroomShopping
//
//  Created by zzy on 9/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderCell : UICollectionReusableView
/** 轮播图 */
@property(nonatomic,strong)NSMutableArray *imageUrlArr;
/** 滚动新闻 */
@property(nonatomic,strong)NSMutableArray *newsArr;
@end
