//
//  BathroomHeaderCell.m
//  BathroomShopping
//
//  Created by zzy on 9/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BathroomHeaderCell.h"
#import "CategoryView.h"
#import "BathroomGoodsViewController.h"
#import "GoodsCategoryModel.h"
#import "GoodsCategoryViewController.h"
@interface BathroomHeaderCell()
/** <##> */
@property (nonatomic, weak)CategoryView *headerView;
@end

@implementation BathroomHeaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        CategoryView *headerView = [[CategoryView alloc]init];
        headerView.frame = self.frame;
        headerView.categoryType = Bath;
        
        __weak typeof (self)weakSelf = self;
        headerView.categoryViewBlock = ^(GoodsCategoryModel *model){
            
            if (model.index == 7) {
                
                GoodsCategoryViewController *goodsCategoryVC = [[GoodsCategoryViewController alloc]init];
                goodsCategoryVC.categoryArr = self.categoryArr;
                goodsCategoryVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.vc.navigationController pushViewController:goodsCategoryVC animated:YES];
                return;
            }
            BathroomGoodsViewController *bathroomGoodsVC = [[BathroomGoodsViewController alloc]init];
            bathroomGoodsVC.hidesBottomBarWhenPushed = YES;
            bathroomGoodsVC.model = model;
            [weakSelf.vc.navigationController pushViewController:bathroomGoodsVC animated:YES];
        };
    
        [self addSubview:headerView];
        self.headerView = headerView;
    }
    
    return self;
}

- (void)setCategoryArr:(NSMutableArray *)categoryArr {

    _categoryArr = categoryArr;
    self.headerView.categoryArr = categoryArr;
}

@end
