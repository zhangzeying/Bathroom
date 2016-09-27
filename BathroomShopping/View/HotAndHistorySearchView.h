//
//  CSHotAndHistorySearchView.h
//  ChangShuo
//
//  Created by zzy on 6/22/16.
//  Copyright © 2016 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchDelegate <NSObject>

- (void)searchClick:(NSString *)searchContent;
- (void)resignKeyboard;
@end
@interface HotAndHistorySearchView : UIView
/** 热门搜索数据数组 */
@property(nonatomic,strong)NSMutableArray *hotArr;
/** 搜索历史数据数组 */
@property(nonatomic,strong)NSMutableArray *historyArr;
@property (nonatomic,weak) id<SearchDelegate> delegate;
@end
