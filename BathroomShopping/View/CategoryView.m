//
//  CategoryView.m
//  BathroomShopping
//
//  Created by zzy on 7/28/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "CategoryView.h"
#import "CustomButton.h"
#import "GoodsCategoryModel.h"
#import <SDWebImage/UIButton+WebCache.h>
// ----每行的按钮最多数量----
#define maxNumOfRow 4
// ----按钮数量的最多行----
#define maxNumRow 2
//// ----按钮水平间距----
//#define hspace (self.width - numOfRow * btnW) / (numOfRow + 1)
//// ----按钮垂直间距----
//#define vspace (self.height - (self.categoryArr.count / numOfRow + 1) * btnH) / (self.categoryArr.count / numOfRow + 2)
// ----按钮的宽度----
#define btnW self.width / maxNumOfRow
// ----按钮的高度----
#define btnH self.height / maxNumRow
@interface CategoryView()
/** <##> */
@property (nonatomic, weak)UIView *bgView;
@end

@implementation CategoryView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initView {
    
    NSInteger btnMaxCount = MIN(self.categoryArr.count, 8);
    
    UIView *bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor redColor];
    [self addSubview:bgView];
    self.bgView = bgView;
    for (NSInteger i = 0; i < btnMaxCount; i++) {
        
        CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
        GoodsCategoryModel *model = self.categoryArr[i];
        btn.tag = i;
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",baseurl, model.picture];
        [btn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.centerOffset = 30;
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [bgView addSubview:btn];
        
        //创建更多按钮
        if (i == 7) {
            
            if (self.categoryType == Bath) {
                
                [btn setImage:[UIImage imageNamed:@"more_category_icon1"] forState:UIControlStateNormal];
                
            }else {
            
                [btn setImage:[UIImage imageNamed:@"more_category_icon0"] forState:UIControlStateNormal];
            }
            
            [btn setTitle:@"更多" forState:UIControlStateNormal];
        }
    }
}

- (void)layoutSubviews {

    self.bgView.frame = self.frame;
    
    for (int i = 0; i < self.bgView.subviews.count; i++) {
        
        CustomButton *btn = (CustomButton *)self.bgView.subviews[i];
        CGFloat btnX = (i % maxNumOfRow) * btnW;
        CGFloat btnY = (i / maxNumOfRow) * btnH;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
       
    }
}

- (void)btnClick:(UIButton *)sender {

    GoodsCategoryModel *model = self.categoryArr[sender.tag];
    model.index = sender.tag;
    if (self.categoryViewBlock) {
        
        self.categoryViewBlock(model);
    }
}

- (void)setCategoryType:(CategoryType)categoryType {
    
    _categoryType = categoryType;
}

- (void)setCategoryArr:(NSMutableArray *)categoryArr {

    _categoryArr = categoryArr;
    if (self.bgView != nil) {
        
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }
    [self initView];
}
@end
