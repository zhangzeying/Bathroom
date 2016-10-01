//
//  CSHotAndHistorySearchView.m
//  ChangShuo
//
//  Created by zzy on 6/22/16.
//  Copyright © 2016 ctkj. All rights reserved.
//

#import "HotAndHistorySearchView.h"
#import "GoodsDetailModel.h"
#import "FileNameDefine.h"
// ----标签间垂直的距离----
#define distanceV 9
// ----标签水平间距----
#define distanceH 13

#define deleteBtnBgImage [UIImage imageNamed:@"recycle"]

@interface HotAndHistorySearchView()
/** 热门搜索section 背景view */
@property (nonatomic, weak)UIView *hotView;
/** 搜索历史section 背景view */
@property (nonatomic, weak)UIView *historyView;
/** 热门搜索section title */
@property (nonatomic, weak)UILabel *hotTitle;
/** 搜索历史section title */
@property (nonatomic, weak)UILabel *historyTitle;
/** 删除历史搜索按钮 */
@property (nonatomic, weak)UIButton *deleteBtn;
@end

@implementation HotAndHistorySearchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -- CreatUI --
- (void)initUI {
    
    
    if (self.hotArr.count > 0) {
        
        //创建热门搜索背景view
        UIView *hotView = [[UIView alloc]init];
        [self addSubview:hotView];
        self.hotView = hotView;
        //创建热门搜索title
        UILabel *hotTitle = [[UILabel alloc]init];
        hotTitle.text = @"热门搜索";
        hotTitle.font = [UIFont systemFontOfSize:15];
        hotTitle.textColor = [UIColor darkGrayColor];
        [hotView addSubview:hotTitle];
        self.hotTitle = hotTitle;
        //创建热门搜索section
        for (int i = 0; i < self.hotArr.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:CustomColor(102, 102, 102) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@"search_btn_bg"] forState:UIControlStateNormal];
            [hotView addSubview:btn];
        }
    }
    
    //创建搜索历史背景view
    if (self.historyArr.count > 0) {
        
        UIView *historyView = [[UIView alloc]init];
        [self addSubview:historyView];
        self.historyView = historyView;
        
        //创建搜索历史title
        UILabel *historyTitle = [[UILabel alloc]init];
        historyTitle.text = @"最近搜索";
        historyTitle.textColor = [UIColor darkGrayColor];
        historyTitle.font = [UIFont systemFontOfSize:15];
        [historyView addSubview:historyTitle];
        self.historyTitle = historyTitle;
        
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:deleteBtnBgImage forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
        
        //创建搜索历史section
        for (int i = 0; i < self.historyArr.count; i++) {
            
            UIButton *btn = [[UIButton alloc]init];
            [btn setTitleColor:CustomColor(102, 102, 102) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@"search_btn_bg"] forState:UIControlStateNormal];
            [historyView addSubview:btn];
        }
    }
    
}

#pragma mark -- 布局子控件 - -
- (void)layoutSubviews {
    
    // -------- hotView ----------
    self.hotTitle.frame = CGRectMake(0, 10, 40, 40);
    [self.hotTitle sizeToFit];
    NSInteger hotRow = 0; //记录行数
    //因为hotView第一个subview是titleLabel，所有从1开始才是按钮
    for (int i = 1; i < self.hotView.subviews.count; i++) {
        
        if ([self.hotView.subviews[i] isKindOfClass:[UIButton class]]) {
            
            UIButton *btn = self.hotView.subviews[i];
            btn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
            GoodsDetailModel *model = self.hotArr[i - 1];
            btn.searchContent = model.name;
            if (model.name.length > 15) {
                
                model.name = [model.name substringToIndex:15];
                model.name = [model.name stringByAppendingString:@"..."];
            }
            [btn setTitle:model.name forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn sizeToFit];
            CGFloat btnW = MAX(btn.frame.size.width + 5, 60);
            CGFloat btnH = btn.frame.size.height;
            CGFloat btnX;
            if (i > 1) {
                
                UIButton *lastBtn = self.hotView.subviews[i - 1];
                btnX = CGRectGetMaxX(lastBtn.frame) + distanceH;
                
            }else {
                
                btnX = 0;
            }
            
            CGFloat btnY;
            //换行
            if (btnX + btnW > self.frame.size.width) {
                
                hotRow++; //行数加一
                btnX = 0;
            }
            
            btnY = hotRow * (distanceV + btnH) + CGRectGetMaxY(self.hotTitle.frame) + 8;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }
    }
    
    self.hotView.frame = CGRectMake(0, 0, self.frame.size.width - 20, CGRectGetMaxY([self.hotView.subviews lastObject].frame));
    
    
    // -------- historyView ----------
    self.historyTitle.frame = CGRectMake(0, 0, 40, 40);
    [self.historyTitle sizeToFit];
    
    
    CGFloat deleteBtnW = deleteBtnBgImage.size.width + 20;
    CGFloat deleteBtnH = deleteBtnBgImage.size.height + 20;
    self.deleteBtn.frame = CGRectMake(self.frame.size.width - deleteBtnW, CGRectGetMaxY(self.hotView.frame) + 15, deleteBtnW, deleteBtnH);
    NSInteger historyRow = 0; //记录行数
    //因为historyView第一个subview是titleLabel，所有从1开始才是按钮
    for (int i = 1; i < self.historyView.subviews.count; i++) {
        
        if ([self.historyView.subviews[i] isKindOfClass:[UIButton class]]) {
            
            UIButton *btn = self.historyView.subviews[i];
            btn.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
            NSString *historyStr = self.historyArr[i - 1];
            if (historyStr.length > 15) {
                
                historyStr = [historyStr substringToIndex:15];
                historyStr = [historyStr stringByAppendingString:@"..."];
            }
            [btn setTitle:historyStr forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn sizeToFit];
            btn.searchContent = self.historyArr[i - 1];
            CGFloat btnW = MAX(btn.frame.size.width + 5, 50);
            CGFloat btnH = btn.frame.size.height;
            CGFloat btnX;
            if (i > 1) {
                
                UIButton *lastBtn = self.historyView.subviews[i - 1];
                btnX = CGRectGetMaxX(lastBtn.frame) + distanceH;
                
            }else {
                
                btnX = 0;
            }
            
            CGFloat btnY;
            //换行
            if (btnX + btnW > self.frame.size.width) {
                
                historyRow++; //行数加一
                btnX = 0;
            }
            
            btnY = historyRow * (distanceV + btnH) + CGRectGetMaxY(self.historyTitle.frame) + 8;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }
    }
    
    self.historyView.frame = CGRectMake(0, CGRectGetMaxY(self.hotView.frame) + 20, self.frame.size.width, CGRectGetMaxY([self.historyView.subviews lastObject].frame));
}

#pragma mark --- UIButtonClick ---
- (void)searchClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(searchClick:)]) {
    
        [self.delegate searchClick:sender.searchContent];
    }
}

- (void)deleteClick {

    NSString *searchHistoryFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kSearchHistoryFileName];
    NSMutableArray *historyArr = [[NSMutableArray alloc] initWithContentsOfFile:searchHistoryFilePath];
    [historyArr removeAllObjects];
    [historyArr writeToFile:searchHistoryFilePath atomically:YES];
    [self.historyArr removeAllObjects];
    [self reloadView];
    
}

#pragma mark -- Setter --
- (void)setHistoryArr:(NSMutableArray *)historyArr {
    
    _historyArr = historyArr;
    [self reloadView];
}

- (void)setHotArr:(NSMutableArray *)hotArr {
    
    _hotArr = hotArr;
    [self reloadView];
}

- (void)reloadView {

    [self.hotView removeFromSuperview];
    [self.historyView removeFromSuperview];
    [self.deleteBtn removeFromSuperview];
    self.historyView = nil;
    self.hotView = nil;
    [self initUI];
    [self setNeedsLayout];
}

#pragma mark --- touchesBegan ---
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self.delegate respondsToSelector:@selector(resignKeyboard)]) {
        
        [self.delegate resignKeyboard];
    }
}

@end
