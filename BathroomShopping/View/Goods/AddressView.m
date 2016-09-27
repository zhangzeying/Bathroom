//
//  AddressView.m
//  BathroomShopping
//
//  Created by zzy on 8/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "AddressView.h"
#import "SelectAddressView.h"
static NSString *ID = @"cell";
@interface AddressView()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
/** <##> */
@property (nonatomic, weak)UIScrollView *scroll;
/** <##> */
@property (nonatomic, weak)UIButton *backBtn;
@end

@implementation AddressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView {

    UILabel *titleLbl = [[UILabel alloc]init];
    titleLbl.text = @"配送至";
    titleLbl.textColor = CustomColor(193, 193, 193);
    [titleLbl sizeToFit];
    titleLbl.frame = CGRectMake(0, 15, titleLbl.width, titleLbl.height);
    titleLbl.centerX = self.width / 2;
    titleLbl.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLbl];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(15, 0, 12, 18);
    backBtn.centerY = titleLbl.centerY;
    backBtn.hidden = YES;
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(self.width - 10 - 19, 10, 19, 19);
    closeBtn.centerY = titleLbl.centerY;
    [self addSubview:closeBtn];
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    CGFloat scrollY = CGRectGetMaxY(titleLbl.frame) + 12;
    scroll.frame = CGRectMake(0, scrollY, ScreenW, self.height - scrollY);
    scroll.delegate = self;
    [self addSubview:scroll];
    self.scroll = scroll;
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, scroll.height - 50) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [UIView new];
    [scroll addSubview:table];
    
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(0, scroll.height - 50, ScreenW, 50);
    [addressBtn setTitle:@"选择其他地址" forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(selectAddressClick) forControlEvents:UIControlEventTouchUpInside];
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    addressBtn.backgroundColor = [UIColor redColor];
    [scroll addSubview:addressBtn];
    
    SelectAddressView *selectAddressView = [[SelectAddressView alloc]initWithFrame:CGRectMake(ScreenW, 0, ScreenW, scroll.height)];
    [scroll addSubview:selectAddressView];
}

#pragma mark --- UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"111";
    return cell;
}

#pragma mark --- UIButtonClick ---
- (void)closeClick {
    
    if (self.addressViewBlock) {
        
        self.addressViewBlock();
    }
}

- (void)backClick {

    [self.scroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)selectAddressClick {

    [self.scroll setContentOffset:CGPointMake(ScreenW, 0) animated:YES];
}

#pragma mark --- UIScrollViewDelegate ---
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.x == 0) {
        
        self.backBtn.hidden = YES;
        
    }else {
    
        self.backBtn.hidden = NO;
    }
}
@end
