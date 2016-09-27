//
//  UpdatePasswordViewController.m
//  BathroomShopping
//
//  Created by zzy on 8/28/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "LoginAndRegisterService.h"
#import "MineService.h"
@interface UpdatePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *verifyTxt;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTxt;
@property (weak, nonatomic) IBOutlet UITextField *nowPwdTxt1;
@property (weak, nonatomic) IBOutlet UITextField *nowPwdTxt2;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
/** 网络请求对象 */
@property(nonatomic,strong)LoginAndRegisterService *service;
/** <##> */
@property(nonatomic,strong)MineService *mineService;
@end

@implementation UpdatePasswordViewController

#pragma mark --- LazyLoad ---
- (LoginAndRegisterService *)service {
    
    if (_service == nil) {
        
        _service = [[LoginAndRegisterService alloc]init];
    }
    
    return _service;
}

- (MineService *)mineService {
    
    if (_mineService == nil) {
        
        _mineService = [[MineService alloc]init];
    }
    
    return _mineService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CustomColor(235, 235, 235);
    self.navigationItem.title = @"修改密码";
    
    [self.phoneTxt addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.verifyTxt addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.oldPwdTxt addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.nowPwdTxt1 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.nowPwdTxt2 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    
    self.verifyBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.verifyBtn.layer.borderWidth = 0.5;
    self.verifyBtn.layer.cornerRadius = 5;
    
    self.submitBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.submitBtn.layer.borderWidth = 0.5;
    self.submitBtn.layer.cornerRadius = 5;
    
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = [UIColor grayColor];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)getVerifyClick:(id)sender {
    
    if (self.phoneTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入手机号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (![[CommUtils sharedInstance] checkPhoneNum:self.phoneTxt.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    
    __weak typeof (self)weakSelf = self;
    [self.service getVerifyCode:self.phoneTxt.text completion:^{
        
        [weakSelf startTime];
    }];
}
- (IBAction)submitClick:(id)sender {
    
    if (![[CommUtils sharedInstance] checkPhoneNum:self.phoneTxt.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    NSDictionary *params = @{@"account":self.phoneTxt.text,
                             @"password":self.oldPwdTxt.text,
                             @"newPassword":self.nowPwdTxt1.text,
                             @"newPassword2":self.nowPwdTxt2.text,
                             @"vcode":self.verifyTxt.text,
                             @"token":[[CommUtils sharedInstance] fetchToken]};
    
    __weak typeof (self)weakSelf = self;
    [self.mineService updatePassword:params completion:^{
       
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

}

/**
 * 简单来说，dispatch source是一个监视某些类型事件的对象。当这些事件发生时，它自动将一个block放入一个dispatch queue的执行例程中
 */
- (void)startTime {
    
    __block int timeout= 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [self.verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                self.verifyBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [self.verifyBtn setTitle:[NSString stringWithFormat:@"%@秒重发",strTime] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
                self.verifyBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
}

- (void)valueChanged:(UITextField *)sender {

    if (self.phoneTxt.text.length == 0 || self.verifyTxt.text.length == 0 || self.oldPwdTxt.text.length == 0 || self.nowPwdTxt1.text.length == 0 || self.nowPwdTxt2.text.length == 0) {
        
        self.submitBtn.enabled = NO;
        self.submitBtn.backgroundColor = [UIColor grayColor];
        
    }else {
    
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = [UIColor whiteColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
