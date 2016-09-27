//
//  SelectAddressView.m
//  BathroomShopping
//
//  Created by zzy on 8/18/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "SelectAddressView.h"
#import "GoodsService.h"
#import "AddressModel.h"
#import "AddressTableCell.h"
@interface SelectAddressView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)GoodsService *service;
/** 省份数组 */
@property(nonatomic,strong)NSMutableArray *provinceArr;
/** 城市数组 */
@property(nonatomic,strong)NSMutableArray *cityArr;
/** 区数组 */
@property(nonatomic,strong)NSMutableArray *districtArr;
/** <##> */
@property (nonatomic, weak)UIScrollView *scroll;
@end

@implementation SelectAddressView

- (GoodsService *)service {
    
    if (_service == nil) {
        
        _service = [[GoodsService alloc]init];
    }
    return _service;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self.backgroundColor = [UIColor whiteColor];
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        __weak typeof (self)weakSelf = self;
        __block UITableView *table = (UITableView *)[self.scroll viewWithTag:1];
        [self.service getProvice:^(NSMutableArray *proviceArr) {
            
            weakSelf.provinceArr = proviceArr;
            [table reloadData];
        }];
    }
    return self;
}

- (void)initView {

//    NSInteger btnCount = self.addressArr.count == 3 ? self.addressArr.count : self.addressArr.count + 1;
//    for (int i = 0; i < 1; i++) {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"请选择" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn sizeToFit];
    //        CGFloat btnX = (i + 1) * 15 + btn.width * i;
    btn.frame = CGRectMake(15, 0, btn.width, 30);
    //        btn.tag = i + 10;
    [self addSubview:btn];
    //    }
    
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = CustomColor(235, 235, 235);
    line.frame = CGRectMake(0, 30, ScreenW, 0.5);
    [self addSubview:line];
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.frame = CGRectMake(0, CGRectGetMaxY(line.frame), ScreenW, self.height - CGRectGetMaxY(line.frame));
//    scroll.contentSize = CGSizeMake(ScreenW * 3, 0);
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.pagingEnabled = YES;
    [self addSubview:scroll];
    self.scroll = scroll;
    
    for (int i = 0; i < 3; i++) {
        
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(ScreenW * i, 0, ScreenW, scroll.height) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
//        table.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        table.rowHeight = 30;
        table.tag = i + 1;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [scroll addSubview:table];
    }
}

#pragma mark --- UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 1){
        
        return self.provinceArr.count;
        
    }else if(tableView.tag == 2){
        
        return self.cityArr.count;
        
    }else{
        
        return self.districtArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView.tag == 1) {
        
        AddressTableCell *cell = [AddressTableCell cellWithTableView:tableView];
        cell.model = self.provinceArr[indexPath.row];
        return cell;
        
    }else if(tableView.tag == 2) {
        
        AddressTableCell *cell = [AddressTableCell cellWithTableView:tableView];
        cell.model = self.cityArr[indexPath.row];
        return cell;
        
    }else {
        
        AddressTableCell *cell = [AddressTableCell cellWithTableView:tableView];
        cell.model = self.districtArr[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView.tag == 1){//选择省份加载对应的城市
        
        __block AddressModel *provinceModel = self.provinceArr[indexPath.row];
        __weak typeof (self)weakSelf = self;
        
        //刷新数据
        [self.cityArr removeAllObjects];
        [self.districtArr removeAllObjects];
        UITableView *cityTable = (UITableView *)[self.scroll viewWithTag:2];
        [cityTable reloadData];
        UITableView *districtTable = (UITableView *)[self.scroll viewWithTag:3];
        [districtTable reloadData];
        
//        UIButton *btn1 = [self viewWithTag:10];
//        [btn1 setTitle:provinceModel.name forState:UIControlStateNormal];
//        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn1 sizeToFit];
//        [btn1 layoutIfNeeded];
//    
//        UIButton *btn2 = [self viewWithTag:11];
//        [btn2 setTitle:@"请选择" forState:UIControlStateNormal];
//        [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [btn2 sizeToFit];
//        [btn2 layoutIfNeeded];
        
        [self.service getCityByProvinceCode:provinceModel.code completion:^(NSMutableArray *cityModelArr) {
            
            weakSelf.cityArr = cityModelArr;
            UITableView *table = (UITableView *)[self.scroll viewWithTag:2];
            [table reloadData];
            provinceModel.childrenArr = cityModelArr;
            weakSelf.scroll.contentSize = CGSizeMake(2 * ScreenW, 0);
            [weakSelf.scroll setContentOffset:CGPointMake(ScreenW, 0) animated:YES];
        }];

    }else if(tableView.tag == 2){//选择城市加载对应的区
        
        UITableView *provinceTable = (UITableView *)[self.scroll viewWithTag:1];
        __block AddressModel *provinceModel = self.provinceArr[[[provinceTable indexPathForSelectedRow] row]];
        __block AddressModel *cityModel = self.cityArr[indexPath.row];
        __weak typeof (self)weakSelf = self;
        
        [self.service getDistrictByCityCode:provinceModel.code cityCode:cityModel.code completion:^(NSMutableArray *districtModelArr) {
            
            weakSelf.districtArr = districtModelArr;
            UITableView *table = (UITableView *)[self.scroll viewWithTag:3];
            [table reloadData];
            provinceModel.childrenArr = districtModelArr;
            weakSelf.scroll.contentSize = CGSizeMake(3 * ScreenW, 0);
            [weakSelf.scroll setContentOffset:CGPointMake(2 * ScreenW, 0) animated:YES];
        }];

    }else{
        
        UITableView *provinceTable = (UITableView *)[self.scroll viewWithTag:1];
        UITableView *cityTable = (UITableView *)[self.scroll viewWithTag:2];
        AddressModel *provinceModel = self.provinceArr[[[provinceTable indexPathForSelectedRow] row]];
        AddressModel *cityModel = self.cityArr[[[cityTable indexPathForSelectedRow] row]];
        AddressModel *districtModel = self.districtArr[[[tableView indexPathForSelectedRow] row]];
        NSMutableArray *addressArr = [NSMutableArray arrayWithObjects:provinceModel,cityModel,districtModel,nil];
        if (self.selectAddressViewBlock) {
            
            self.selectAddressViewBlock(addressArr);
        }
    }
}

//- (void)setAddressArr:(NSMutableArray *)addressArr {
//
//    _addressArr = addressArr;
//}
@end
