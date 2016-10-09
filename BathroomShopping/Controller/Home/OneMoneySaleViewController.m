//
//  OneMoneySaleViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/24/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "OneMoneySaleViewController.h"
#import "OneMoneySaleTableCell.h"
#import "OneMoneySaleHeaderView.h"
#import "HomeService.h"
#import "ActivityGoodsDetailModel.h"
#import "GoodsModel.h"
#import "GoodsDetailModel.h"
#import "MyButton.h"
#import "FillOrderViewController.h"
#import "LotteryTableCell.h"
#import "ShoppingCartDetailModel.h"
@interface OneMoneySaleViewController ()<UITableViewDelegate, UITableViewDataSource>
/** table */
@property (nonatomic, weak)UITableView *table;
/** 网络请求对象 */
@property(nonatomic,strong)HomeService *service;
/** <##> */
@property(nonatomic,strong)GoodsModel *goodsModel;

@property(nonatomic,retain) dispatch_source_t timer;
/** <##> */
@property(nonatomic,strong)NSMutableArray *lotteryArr;
@end

@implementation OneMoneySaleViewController

- (HomeService *)service {
    
    if (_service == nil) {
        
        _service = [[HomeService alloc]init];
    }
    
    return _service;
}

- (NSMutableArray *)lotteryArr {
    
    if (_lotteryArr == nil) {
        
        _lotteryArr = [NSMutableArray array];
    }
    
    return _lotteryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"一元抢购";
    [self initView];
}



- (void)initView {
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 15 - 150) style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 150;
    table.tag = 1;
    [self.view addSubview:table];
    self.table = table;
    
    __weak typeof (self)weakSelf = self;
    [self.service getOneSaleList:^(GoodsModel *model) {
        
        weakSelf.goodsModel = model;
        [weakSelf.table reloadData];
        [[CommUtils sharedInstance] countDownWithPER_SECBlock:^{
            
            [weakSelf updateTimeInVisibleCells];
        }];
    }];
    
    
    UIView *headerView = [[UIView alloc]init];
    headerView.width = ScreenW - 20;
    headerView.backgroundColor = CustomColor(93, 143, 211);
    
    UILabel *titleLbl = [[UILabel alloc]init];
    titleLbl.text = @"抽奖中奖名单";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.x = 10;
    titleLbl.y = 10;
    [titleLbl sizeToFit];
    [headerView addSubview:titleLbl];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn sizeToFit];
    moreBtn.width += moreBtn.width ;
    moreBtn.x = headerView.width - 10 - moreBtn.width;
    moreBtn.centerY = titleLbl.centerY;
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [moreBtn setImage:[UIImage imageNamed:@"buy_btn_icon"] forState:UIControlStateNormal];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    CGSize size = [moreBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -14, 0, 14)];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, size.width, 0, -size.width)];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [headerView addSubview:moreBtn];
    
    headerView.height = CGRectGetMaxY(titleLbl.frame) + 8;
    
    UITableView *lotteryTable = [[UITableView alloc]initWithFrame:CGRectMake(10, ScreenH - 15 - 150, ScreenW - 20, 150) style:UITableViewStylePlain];
    lotteryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    lotteryTable.dataSource = self;
    lotteryTable.delegate = self;
    lotteryTable.backgroundColor = CustomColor(93, 143, 211);
    lotteryTable.tag = 2;
    lotteryTable.scrollEnabled = NO;
    lotteryTable.rowHeight = (150 - headerView.height) / 3;
    lotteryTable.tableHeaderView = headerView;
    [self.view addSubview:lotteryTable];
    
    
    [self.service getLotteryUserList:^(NSMutableArray *lotterUserArr) {
        
        weakSelf.lotteryArr = lotterUserArr;
    }];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 1) {
        
        return self.goodsModel.list.count;
        
    }else {
        
        return MIN(self.lotteryArr.count, 3);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        
        OneMoneySaleTableCell *cell = [OneMoneySaleTableCell cellWithTableView:tableView];
        cell.model = self.goodsModel.list[indexPath.row];
        cell.tag = indexPath.row;
        __weak typeof (self)weakSelf = self;
        cell.lotteryBlock = ^(ShoppingCartDetailModel *detailModel){
            
            FillOrderViewController *fillOrderVC = [[FillOrderViewController alloc]init];
            fillOrderVC.goodsArr = [NSMutableArray arrayWithObjects:detailModel, nil];
            fillOrderVC.pageType = OneSale;
            [weakSelf.navigationController pushViewController:fillOrderVC animated:YES];
        };
        return cell;
        
    }else {
        
        LotteryTableCell *cell = [[LotteryTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.lotteryArr[indexPath.row];
        return cell;
    }
}


/**
 * 每秒更新一次时间
 */
- (void)updateTimeInVisibleCells {
    NSArray *cells = self.table.visibleCells; //取出屏幕可见ceLl
    for (OneMoneySaleTableCell *cell in cells) {
        
        GoodsDetailModel *model = self.goodsModel.list[cell.tag];
        NSDate *finishDate = [[CommUtils sharedInstance] dateFromString:model.activityEndDateTime];
        NSDate *startDate = [NSDate date];
        NSTimeInterval timeInterval =[finishDate timeIntervalSinceDate:startDate];
        if (timeInterval <= 0) {
            
            
            
        }else {
            
            int days = (int)(timeInterval/(3600*24));
            int hours = (int)((timeInterval-days*24*3600)/3600);
            int minute = (int)(timeInterval-days*24*3600-hours*3600)/60;
            int second = timeInterval-days*24*3600-hours*3600-minute*60;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                cell.dayLbl.text = [NSString stringWithFormat:@"%zd",days];
                cell.hourLbl.text = [NSString stringWithFormat:@"%zd",hours];
                cell.minuteLbl.text = [NSString stringWithFormat:@"%zd",minute];
                cell.secondsLbl.text = [NSString stringWithFormat:@"%zd",second];
            });
            
        }
    }
}

- (void)dealloc {
    
    [[CommUtils sharedInstance]destoryTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
