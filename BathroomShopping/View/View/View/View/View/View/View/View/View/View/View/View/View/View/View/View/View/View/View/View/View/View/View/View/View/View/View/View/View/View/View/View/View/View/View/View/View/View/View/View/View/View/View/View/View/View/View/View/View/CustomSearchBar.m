//
//  CustomSearchBar.m
//  BathroomShopping
//
//  Created by zzy on 7/5/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "CustomSearchBar.h"

@implementation CustomSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"搜索";
        self.background = [UIImage imageNamed:@"searchbar_bg"];
        
        UIImageView *searchIcon = [[UIImageView alloc]init];
        searchIcon.image = [UIImage imageNamed:@"search_icon"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar {

    return [[self alloc]init];
}

@end
