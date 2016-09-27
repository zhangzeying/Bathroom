//
//  MineHeaderView.h
//  BathroomShopping
//
//  Created by zzy on 7/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineHeaderViewDelegate <NSObject>

- (void)login;
- (void)infomation;

@end

@interface MineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *line;
+ (MineHeaderView *)instanceHeaderView;
/** delegate */
@property (nonatomic, weak)id <MineHeaderViewDelegate>delegate;
@end
