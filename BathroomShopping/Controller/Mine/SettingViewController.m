//
//  SettingViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/12/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "Tools.h"
static NSString *ID = @"cell";
@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property(nonatomic,strong)NSArray *titleArr;
/** <##> */
@property (nonatomic, weak)UITableView *table;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = CustomColor(243, 244, 246);
    self.navigationItem.title = @"设置";
    self.titleArr = @[@"推送消息设置",@"清除本地缓存"];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    self.table = table;
    
    if ([[CommUtils sharedInstance] isLogin]) {
        
        UIView *footerView = [[UIView alloc]init];
        footerView.width = ScreenW;
        footerView.height = 70;
        footerView.backgroundColor = [UIColor clearColor];
        
        UIView *topLine = [[UIView alloc]init];
        topLine.backgroundColor = [UIColor colorWithHexString:@"0xcfcfcf"];
        topLine.width = ScreenW;
        topLine.height = 0.5;
        [footerView addSubview:topLine];
        
        UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        quitBtn.backgroundColor = [UIColor redColor];
        quitBtn.width = ScreenW - 30;
        quitBtn.centerX = footerView.centerX;
        quitBtn.height = 40;
        quitBtn.centerY = footerView.centerY;
        quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [quitBtn addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:quitBtn];
        table.rowHeight = 50;
        table.tableFooterView = footerView;

        
    }else {
        
        table.tableFooterView = [UIView new];
    }
    
}

#pragma mark --- UITableViewDataSource ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    if (indexPath.row == 1) {
        
        UILabel *cachelbl = [[UILabel alloc]init];
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        cachelbl.text = [NSString stringWithFormat:@"%.2fM",[Tools folderSizeAtPath:cachePath]];
        cachelbl.width = 50;
        cachelbl.height = 30;
        cachelbl.font = [UIFont systemFontOfSize:13];
        cachelbl.textColor = CustomColor(193, 193, 193);
        cell.accessoryView = cachelbl;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 1) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定清除本地缓存？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 100;
        [alertView show];
        
    }
}

- (void)quitClick {

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"你确定要退出当前账号?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    alertView.tag = 101;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        if (alertView.tag == 100) {
            
            NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
            [SVProgressHUD show];
            [Tools clearCache:cachePath];
            [self.table reloadData];
            
        }else {
        
            [[CommUtils sharedInstance] removeUserInfo];
            [[CommUtils sharedInstance] removeToken];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginStateChange" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
