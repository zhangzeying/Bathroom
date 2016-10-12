//
//  GoodsSearchViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/11/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "GoodsSearchViewController.h"
#import "CustomSearchBar.h"
#import "HotAndHistorySearchView.h"
#import "HomeService.h"
#import "FileNameDefine.h"
#import "MyLikedTableCell.h"
#import "ErrorView.h"
#import "GoodsInfoViewController.h"
#import "GoodsDetailModel.h"
// ----标签间垂直的距离----
#define distanceV 9
// ----标签水平间距----
#define distanceH 13

#define deleteBtnBgImage [UIImage imageNamed:@"recycle"]

@interface GoodsSearchViewController ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource, SearchDelegate>
/** 热门搜索section title */
@property (nonatomic, weak)UILabel *hotTitle;
/** 搜索历史section title */
@property (nonatomic, weak)UILabel *historyTitle;
/** 删除历史搜索按钮 */
@property (nonatomic, weak)UIButton *deleteBtn;
/** <##> */
@property(nonatomic,strong)HomeService *service;
/** <##> */
@property(nonatomic,strong)HotAndHistorySearchView *searchView;
/** <##> */
@property(nonatomic,copy)NSString *historyFilePath;
/** <##> */
@property(nonatomic,strong)NSMutableArray *historyArr;
/** <##> */
@property (nonatomic, copy)NSString *keyword;
/** <##> */
@property (nonatomic, weak)CustomSearchBar *searchBar;
/** <##> */
@property(nonatomic,strong)UITableView *table;
/** <##> */
@property(nonatomic,strong)NSMutableArray *dataArr;
/** <##> */
@property (nonatomic, weak)ErrorView *errorView;
/** <##> */
@property(assign,nonatomic)BOOL isUp;
@end

@implementation GoodsSearchViewController

- (HotAndHistorySearchView *)searchView {
    
    if (_searchView == nil) {
        
        _searchView = [[HotAndHistorySearchView alloc]init];
        _searchView.frame = CGRectMake(15, 64, ScreenW - 30, ScreenH - 64);
        _searchView.delegate = self;
        [self.view addSubview:_searchView];
    }
    
    return _searchView;
}

- (NSMutableArray *)dataArr {
    
    if (_dataArr == nil) {
        
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}

- (UITableView *)table {
    
    if (_table == nil) {
        
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH - 64) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.rowHeight = 150;
        _table.hidden = YES;
        [self.view addSubview:_table];
    }
    
    return _table;
}

- (HomeService *)service {
    
    if (_service == nil) {
        
        _service = [[HomeService alloc]init];
    }
    
    return _service;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CustomSearchBar *searchBar = [CustomSearchBar searchBar];
    searchBar.width = 250;
    searchBar.placeholder = @"请输入商品名";
    searchBar.height = 30;
    searchBar.delegate = self;
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchBar addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.navigationItem.titleView = searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchGoods)];
    self.searchBar = searchBar;
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {

    self.isUp = YES;
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.isUp) {
            
            [self.searchBar becomeFirstResponder];
        }
        
    });
}

- (void)initUI {

    self.historyFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kSearchHistoryFileName]; //历史搜索缓存路径
    
    self.historyArr = [[NSMutableArray alloc] initWithContentsOfFile:self.historyFilePath];
    self.searchView.historyArr = (NSMutableArray *)[[self.historyArr reverseObjectEnumerator]allObjects];
    __block HotAndHistorySearchView *searchV = self.searchView;
    [self.service gethotProductList:^(NSMutableArray *dataArr) {
       
        searchV.hotArr = dataArr;
        
    }];
}

/**
 * 搜索
 */
- (void)searchGoods {
    
    [self.searchBar resignFirstResponder];
    self.keyword = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.searchView.hidden = YES;
    self.table.hidden = NO;
    if (self.keyword.length == 0) {
        // 只输入了空格
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        progress.mode = MBProgressHUDModeText;
        progress.removeFromSuperViewOnHide = YES;
        progress.label.text = @"请输入有效关键字";
        [progress setOffset:CGPointMake(0, -10.0f)];
        [progress hideAnimated:YES afterDelay:1.0];
        return;
    }
    __weak typeof (self)weakSelf = self;
    [self.service searchProductByKeywords:self.keyword completion:^(NSMutableArray *dataArr) {
        
        weakSelf.dataArr = dataArr;
        [weakSelf.table reloadData];
        if (dataArr.count == 0) {
            
            ErrorView *errorView = [[ErrorView alloc]initWithFrame:self.view.frame];
            errorView.warnStr = @"抱歉！没有找到该商品";
            errorView.imgName = @"sys_xiao8";
            errorView.btnTitle = @"";
            [weakSelf.view addSubview:errorView];
            weakSelf.table.hidden = YES;
            weakSelf.errorView = errorView;
            
        }else {
            
            weakSelf.table.hidden = NO;
            [weakSelf.errorView removeFromSuperview];
            weakSelf.errorView = nil;
        }
    }];
    [self updateHistoryData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyLikedTableCell *cell = [MyLikedTableCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    GoodsDetailModel *model = self.dataArr[indexPath.row];
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]initWithGoodsId:model.id packgeModel:nil];
    goodsInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

/**
 * 更新数据
 */
- (void)updateHistoryData {
    
    //从缓存中取出搜索历史数据
    
    self.historyArr = [[NSMutableArray alloc] initWithContentsOfFile:self.historyFilePath] == nil ? [NSMutableArray array] : [[NSMutableArray alloc] initWithContentsOfFile:self.historyFilePath];
    
    //替换多个空格为一个空格
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"\\s+"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];
    self.keyword = [regular stringByReplacingMatchesInString:_keyword options:0 range:NSMakeRange(0, [_keyword length]) withTemplate:@" "];
    
    
    //搜索历史去重
    for (NSString *str in self.historyArr) {
        
        if ([self.keyword isEqualToString:str]) {
            
            [self.historyArr removeObject:str];
            break;
        }
    }
    
    if (self.historyArr.count >= 10) {
        
        [self.historyArr removeObjectAtIndex:0];
        [self.historyArr addObject:self.keyword];
    }else {
        
        [self.historyArr addObject:self.keyword];
    }
    
    [self.historyArr writeToFile:self.historyFilePath atomically:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self searchGoods];
    return YES;
}

- (void)valueChanged:(CustomSearchBar *)sender {
    
    if (sender.text.length == 0) {
        
        self.searchView.hidden = NO;
        if (self.table != nil) {
            
            self.table.hidden = YES;
        }
        
        if (self.errorView != nil) {
            
            self.errorView.hidden = YES;
        }
        
    }
}

- (void)searchClick:(NSString *)searchContent {

    self.searchBar.text = searchContent;
    [self.searchBar resignFirstResponder];
    [self searchGoods];
}

- (void)resignKeyboard {

    [self.searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.isUp = NO;
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
