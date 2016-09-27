//
//  HomeTabBarController.m
//  chemistry
//
//  Created by zzy on 3/5/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "HomeTabBarController.h"
#import "BaseNavigationController.h"

@interface HomeTabBarController ()

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setTabBar];
}

//设置tabBar
- (void)setTabBar {
    
    //添加子控制器
    NSArray *classNames = @[@"HomeViewController", @"BathroomViewController", @"MallViewController", @"MineViewController"];
    
    NSArray *titles = @[@"首页", @"卫浴", @"商城", @"我的"];
    
    NSArray *imageNames = @[@"home_noselected_icon", @"bath_noselected_icon", @"shopping_noselected_icon", @"mine_noselected_icon"];
    
    NSArray *selectedImageNames = @[@"home_selected_icon", @"bath_selected_icon", @"shopping_selected_icon", @"mine_selected_icon"];
    
    for (int i = 0; i < classNames.count; i++) {
        
        UIViewController *vc = (UIViewController *)[[NSClassFromString(classNames[i]) alloc] init];
        BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:vc];
        vc.tabBarItem.title = titles[i];
        vc.tabBarItem.image = [[UIImage imageNamed:imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        vc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        vc.view.layer.shadowOpacity = 0.2;
        [self addChildViewController:nc];
        
    }
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.selectedIndex = 0;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
