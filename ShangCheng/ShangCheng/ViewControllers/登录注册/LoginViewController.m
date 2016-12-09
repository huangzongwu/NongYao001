//
//  LoginViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//  短信验证码登录

#import "LoginViewController.h"
#import "RegisterAlertView.h"
#import "Manager.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (nonatomic,strong)RegisterAlertView *registerAlertView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismissVCAction)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    //注册按钮点击后出现的注册类型视图
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    self.registerAlertView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterAlertView" owner:self options:nil] firstObject];
    self.registerAlertView.frame = self.view.bounds;
    [window addSubview:self.registerAlertView];
    //alert中普通用户和供应商两个按钮的点击事件block
    __weak LoginViewController *weakVC = self;
    self.registerAlertView.toRegisterVCStr = ^(NSString *toRegisterVCStr){
        if ([toRegisterVCStr isEqualToString:@"generalVC"]) {
            //跳转到普通用户注册
            UINavigationController *registerNav = [weakVC.storyboard instantiateViewControllerWithIdentifier:@"registerNavigationController"];
            [weakVC presentViewController:registerNav animated:YES completion:nil];

        }
        if ([toRegisterVCStr isEqualToString:@"supplierVC"]) {
            //跳转到供应商注册
//            UINavigationController *registerNav = [weakVC.storyboard instantiateViewControllerWithIdentifier:@"RegisterNavigationController"];
//            [weakVC presentViewController:registerNav animated:YES completion:nil];

        }
    };

   
    
    
    
}
#pragma mark - 登录 -
//密码登录按钮
- (IBAction)loginButtonOneAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    [manager loginActionWithUserID:@"admin" withPassword:[manager digest:@"nongyao001"] withLoginSuccessResult:^(id successResult) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } withLoginFailResult:^(NSString *failResultStr) {
        
    }];

    
}
//验证码登录按钮
- (IBAction)loginButtonTwoAction:(UIButton *)sender {
    
}

#pragma mark - 切换登录方式 -
//从密码界面到短信登录界面
- (IBAction)toMessageLoginView:(UIButton *)sender {
    
    self.loginScrollView.contentOffset = CGPointMake(kScreenW, 0);
}
//从短信界面到密码登录界面
- (IBAction)toPasswordLoginView:(UIButton *)sender {
    
    self.loginScrollView.contentOffset = CGPointMake(0, 0);

}


#pragma mark - 注册与忘记密码 -
//密码登录界面的注册按钮
- (IBAction)passwordToRegistVCAction:(UIButton *)sender {
    //弹出注册alert视图
    self.registerAlertView.hidden = NO;
}

//短信登录界面的注册按钮
- (IBAction)messageToRegistVCAction:(UIButton *)sender {
    //弹出注册alert视图
    self.registerAlertView.hidden = NO;
}





//密码登录界面的忘记密码
- (IBAction)passwordToForgetVCAction:(UIButton *)sender {
}

//短信登录界面的忘记密码
- (IBAction)messageToForgetVCAction:(UIButton *)sender {
}

- (void)dismissVCAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
