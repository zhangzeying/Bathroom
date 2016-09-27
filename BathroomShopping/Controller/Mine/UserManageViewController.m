//
//  UserManageViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/11/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "UserManageViewController.h"
#import "UserInfoModel.h"
#import "SelectedPhoto.h"
#import "MineService.h"
#import "VPImageCropperViewController.h"
#import "UpdateUserInfoViewController.h"
#import "AddressManageViewController.h"
#import "UpdatePasswordViewController.h"

static NSString *ID = @"cell";

@interface UserManageViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    SelectedPhoto *selectPhoto; //管理选择照片的类
}

@property(nonatomic,strong)NSArray *titleArr;
/** <##> */
@property(nonatomic,strong)UserInfoModel *model;
/** 网络请求对象 */
@property(nonatomic,strong)MineService *service;
/** <##> */
@property (nonatomic, weak)UITableView *table;
@end

@implementation UserManageViewController

- (MineService *)service {
    
    if (_service == nil) {
        
        _service = [[MineService alloc]init];
    }
    
    return _service;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"账户管理";
    self.titleArr = @[@[@"头像",@"用户名",@"昵称"],@[@"修改密码",@"地址管理"]];
    self.model = [[CommUtils sharedInstance] fetchUserInfo];
    [self setupTableView];
}

- (void)setupTableView {

    UITableView *table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [UIView new];
    [self.view addSubview:table];
    self.table = table;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *dataArr = self.titleArr[section];
    return dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    NSArray *dataArr = self.titleArr[indexPath.section];
    cell.textLabel.text = dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *arrowImg = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"arrow_icon"];
    arrowImg.image = image;
    arrowImg.x = ScreenW - image.size.width - 10;
    arrowImg.height = image.size.height;
    arrowImg.width = image.size.width;
    arrowImg.centerY = cell.height / 2;
    [cell.contentView addSubview:arrowImg];
    if (indexPath.row == 1 && indexPath.section == 0) {
        
        arrowImg.hidden = YES;
    }
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        UIImageView *avator = [[UIImageView alloc]init];
        NSString *avatorUrl = [NSString stringWithFormat:@"%@%@",baseurl,self.model.headPortrait];
        if (self.model.headPortrait.length > 0) {
            
            [avator sd_setImageWithURL:[NSURL URLWithString:avatorUrl] placeholderImage:nil];
        }else {
        
            avator.image = [UIImage imageNamed:@"avator_no_login"];
        }
        avator.width = 30;
        avator.height = 30;
        avator.x = ScreenW - 30 - arrowImg.width - 10 - 8;
        avator.centerY = cell.height / 2 + 3;
        avator.layer.cornerRadius = avator.width / 2;
        avator.layer.masksToBounds = YES;
        arrowImg.centerY = cell.height / 2 + 3;
        [cell.contentView addSubview:avator];
        
    }else if (indexPath.row == 1 && indexPath.section == 0) {
    
        UILabel *accountLbl = [[UILabel alloc]init];
        accountLbl.text = self.model.account;
        [accountLbl sizeToFit];
        accountLbl.textColor = CustomColor(193, 193, 193);
        accountLbl.font = [UIFont systemFontOfSize:13];
        accountLbl.centerY = cell.height / 2;
        accountLbl.x = ScreenW - arrowImg.width - 10 - 8 - accountLbl.width;
        accountLbl.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:accountLbl];
    }else if (indexPath.row == 2 && indexPath.section == 0) {
        
        UILabel *nickLbl = [[UILabel alloc]init];
        nickLbl.text = self.model.nickname;
        [nickLbl sizeToFit];
        nickLbl.textColor = CustomColor(193, 193, 193);
        nickLbl.font = [UIFont systemFontOfSize:13];
        nickLbl.centerY = cell.height / 2;
        nickLbl.x = ScreenW - arrowImg.width - 10 - 8 - nickLbl.width;
        nickLbl.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:nickLbl];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row == 0 && indexPath.section == 0) {//修改头像
        
        __weak typeof(self) weakSelf = self;
        if (selectPhoto == nil) {
            selectPhoto = [[SelectedPhoto alloc] init];
        }
        [selectPhoto selectedOnePhoto:self completion:^(UIImage * image,BOOL isCancel) {
            if (!isCancel) {
                [selectPhoto cropperImage:image parentViewController:weakSelf completion:^(VPImageCropperViewController *vc, UIImage *editImage) {
                    
                    [weakSelf uploadImage:vc image:editImage];
                }];
            }
        }];
        
    }else if (indexPath.row == 2 && indexPath.section == 0) {//修改昵称
    
        UpdateUserInfoViewController *updateUserInfoVC = [[UpdateUserInfoViewController alloc]init];
        updateUserInfoVC.userInfoType = NickName;
        __weak typeof (self)weakSelf = self;
        updateUserInfoVC.updateUserInfoBlock = ^(NSString *nickName){
        
            weakSelf.model.nickname = nickName;
            [weakSelf.table reloadData];
        };
        [self.navigationController pushViewController:updateUserInfoVC animated:YES];
    }else if (indexPath.row == 1 && indexPath.section == 1) {
    
        AddressManageViewController *addressManageVC = [[AddressManageViewController alloc]init];
        addressManageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressManageVC animated:YES];
        
    }else if (indexPath.row == 0 && indexPath.section == 1) {
        
        UpdatePasswordViewController *updatePasswordVC = [[UpdatePasswordViewController alloc]init];
        updatePasswordVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:updatePasswordVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return 50;
        
    }else {
    
        return 44;
    }
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;//section头部高度
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

/**
 * 上传头像
 */
- (void)uploadImage:(VPImageCropperViewController *)cropperViewController image:(UIImage *)image {

    __weak typeof (self)weakSelf = self;
    [SVProgressHUD show];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
        [weakSelf.service uploadAvator:image completion:^(NSString *avatorUrl) {
            
            weakSelf.model.headPortrait = avatorUrl;
            [[CommUtils sharedInstance] saveUserInfo:weakSelf.model];
            [weakSelf.table reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginStateChange" object:nil];
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
