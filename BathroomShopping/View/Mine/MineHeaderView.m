//
//  MineHeaderView.m
//  BathroomShopping
//
//  Created by zzy on 7/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "MineHeaderView.h"
#import "UserInfoModel.h"
@interface MineHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *avator;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UIButton *infomationBtn;
/** 用户信息数据模型 */
@property(nonatomic,strong)UserInfoModel *model;
@end

@implementation MineHeaderView

- (void)awakeFromNib {

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginStateChange) name:@"loginStateChange" object:nil];
    self.line.backgroundColor = CustomColor(235, 235, 235);
    [self.infomationBtn setTitleColor:CustomColor(102, 102, 102) forState:UIControlStateNormal];
    CGSize size = [self.infomationBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [self.infomationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [self.infomationBtn setImageEdgeInsets:UIEdgeInsetsMake(0, size.width, 0, -size.width)];
    self.avator.layer.cornerRadius = self.avator.width / 2;
    self.avator.layer.masksToBounds = YES;
    [self initView];
}

- (void)initView {

    if ([[CommUtils sharedInstance] isLogin]) {
        
        self.model = [[CommUtils sharedInstance] fetchUserInfo];
        NSString *avatorUrl = [NSString stringWithFormat:@"%@%@",baseurl,self.model.headPortrait];
        if (self.model.headPortrait.length > 0) {
            
            [self.avator sd_setImageWithURL:[NSURL URLWithString:avatorUrl] placeholderImage:nil];
            
        }else {
            
            self.avator.image = [UIImage imageNamed:@"avator_no_login"];
        }
        self.usernameLbl.text = self.model.nickname;
        self.loginBtn.hidden = YES;
        self.usernameLbl.hidden = NO;
        self.infomationBtn.hidden = NO;
        
    }else {
        
        self.loginBtn.hidden = NO;
        self.usernameLbl.hidden = YES;
        self.infomationBtn.hidden = YES;
        self.avator.image = [UIImage imageNamed:@"avator_no_login"];
    }
}

+ (MineHeaderView *)instanceHeaderView {

    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}

#pragma mark --- UIButtonClick ---
- (IBAction)loginBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(login)]) {
        
        [self.delegate login];
    }
}

- (IBAction)infoBtnClick:(id)sender {
    
    [self.delegate infomation];
}

#pragma mark --- NSNotification ---
- (void)loginStateChange {

    [self initView];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
