//
//  BaseViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/2/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

//CGRect rect = CGRectMake(0, 0, 85, 44);//button 的尺寸
//CGSize radio = CGSizeMake(3, 3);//圆角尺寸
//UIRectCorner corner = UIRectCornerTopRight|UIRectCornerBottomRight;//圆角位置
//UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
//CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];//创建shapelayer
//masklayer.frame = _goBuyBtn.bounds;
//masklayer.path = path.CGPath;//设置路径
//_goBuyBtn.layer.mask = masklayer;

@end
