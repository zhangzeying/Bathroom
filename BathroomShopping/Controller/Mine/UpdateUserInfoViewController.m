//
//  UpdateUserInfoViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/20/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "UpdateUserInfoViewController.h"
#import "UserInfoModel.h"
#import "MineService.h"
@interface UpdateUserInfoViewController ()
/** 网络请求对象 */
@property(nonatomic,strong)MineService *service;
/** <##> */
@property (nonatomic, weak)UITextField *txt;
@end

@implementation UpdateUserInfoViewController

- (MineService *)service {
    
    if (_service == nil) {
        
        _service = [[MineService alloc]init];
    }
    
    return _service;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmClick)];
    
}

- (void)initView {

    UserInfoModel *model = [[CommUtils sharedInstance] fetchUserInfo];
    if (self.userInfoType == NickName) {
        
        self.navigationItem.title = @"修改昵称";
        UITextField *txt = [[UITextField alloc]initWithFrame:CGRectMake(10, 64, ScreenW - 10, 40)];
        txt.placeholder = @"请输入昵称";
        [txt becomeFirstResponder];
        if (model.nickname.length > 0) {
            
            txt.text = model.nickname;
        }
        txt.font = [UIFont systemFontOfSize:13];
        txt.backgroundColor = [UIColor whiteColor];
        txt.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:txt];
        
        self.txt = txt;
        
        UILabel *line = [[UILabel alloc]init];
        line.frame = CGRectMake(0, CGRectGetMaxY(txt.frame), ScreenW, 0.5);
        line.backgroundColor = CustomColor(235, 235, 235);
        [self.view addSubview:line];
        
    }
    
}

- (void)confirmClick {

    __weak typeof (self)weakSelf = self;
    [self.service updateUserInfo:self.txt.text completion:^{
        
        UserInfoModel *model = [[CommUtils sharedInstance] fetchUserInfo];
        model.nickname = weakSelf.txt.text;
        [[CommUtils sharedInstance]saveUserInfo:model];
        if (weakSelf.updateUserInfoBlock) {
            
            weakSelf.updateUserInfoBlock(weakSelf.txt.text);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginStateChange" object:nil];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)setUserInfoType:(UserInfoType)userInfoType {

    [self initView];
}
@end
