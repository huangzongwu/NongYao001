//
//  MotifyPasswordViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MotifyPasswordViewController.h"
#import "Manager.h"
#import "AlertManager.h"
#import "SVProgressHUD.h"
@interface MotifyPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

//定时器
@property (nonatomic,strong)NSTimer *tempTimer;
@property (nonatomic,assign)NSInteger countDownTime;//倒计时秒数

@end

@implementation MotifyPasswordViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    Manager *manager = [Manager shareInstance];
    
    BOOL isRed = NO;
  
    //验证码输入框，手机号码必须11位，才有可能会变红
   
    if (textField == self.codeTextField && manager.memberInfoModel.u_mobile.length == 11) {
        /*下面两个满足一个就变红
         1、id输入框在输入内容，
         2、id输入框消去内容，没有消除完
         */

        if (string.length > 0 ) {
            isRed = YES;
        }
        if (string.length == 0 && range.location > 0) {
            isRed = YES;
        }
    }
    
    if (isRed == YES) {
        //红色可点击
        self.nextButton.enabled = YES;
        self.nextButton.backgroundColor = kMainColor;
    }else {
        //灰色不可点击
        self.nextButton.enabled = NO;
        self.nextButton.backgroundColor = kccccccColor;
    }
    
    return YES;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //定制器取消
    [self endTimeDown];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Manager *manager = [Manager shareInstance];
    NSString *secMobile = [manager.memberInfoModel.u_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    self.mobileLabel.text = [NSString stringWithFormat:@"当前绑定手机号：%@",secMobile];
    
    //设置倒计时初始值
    self.countDownTime = 60;

}



#pragma mark - 获取验证码 和 倒计时 -
//开始倒计时
- (void)startTimeDown {
    //开始60秒倒计时
    self.tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    //按钮不可点击
    self.getCodeButton.enabled = NO;
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"倒计时 %ld",self.countDownTime] forState:UIControlStateNormal];
    //背景变灰色
    self.getCodeButton.backgroundColor = kColor(153, 153, 153, 1);
}
//倒计时结束
- (void)endTimeDown {
    //倒计时回归
    self.countDownTime = 60;
    //停止倒计时
    [self.tempTimer invalidate];
    //按钮可以点击
    self.getCodeButton.enabled = YES;
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    //背景色变红
    self.getCodeButton.backgroundColor = kMainColor;
    
}
- (void)timerAction:(NSTimer *)timer {
    NSLog(@"aaaaaaaa");
    self.countDownTime--;
    //    NSLog(@"倒计时 %ld",self.countDownTime);
    self.getCodeButton.titleLabel.text = [NSString stringWithFormat:@"倒计时(%ld)",self.countDownTime];
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"倒计时(%ld)",self.countDownTime] forState:UIControlStateNormal];
    if (self.countDownTime == 0) {
        //倒计时结束
        [self endTimeDown];
        
    }
}


//获取短信验证码
- (IBAction)getMobileNumber:(UIButton *)sender {
    [self keyboardDismissAction];

    Manager *manager = [Manager shareInstance];
    
    if (manager.memberInfoModel.u_mobile.length == 11) {

        [manager httpMobileCodeWithMobileNumber:manager.memberInfoModel.u_mobile withCodeSuccessResult:^(id successResult) {
            
            if ([successResult isEqualToString:@"200"]) {
                AlertManager *alert = [AlertManager shareIntance];
                [alert showAlertViewWithTitle:nil withMessage:@"短信验证码发送成功，请注意查收" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    //发送成功后，开始倒计时
                    [self startTimeDown];
                    
                }];
            }
        } withCodeFailResult:^(NSString *failResultStr) {
            
            AlertManager *alert = [AlertManager shareIntance];
            [alert showAlertViewWithTitle:nil withMessage:[NSString stringWithFormat:@"短信验证发送失败，%@",failResultStr ] actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                
            }];
        }];
        
    }else {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"手机号不正确" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
}

//下一步
- (IBAction)nextButtonAction:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"motifyNextVC" sender:nil];
    
    
    AlertManager *alertM = [AlertManager shareIntance];
    Manager *manager = [Manager shareInstance];
    [self keyboardDismissAction];

    
    if (manager.memberInfoModel.u_mobile.length == 11 ) {
        if (self.codeTextField.text.length > 0) {
            
            if ([SVProgressHUD isVisible] == NO) {
                [SVProgressHUD show];
            }

            //验证一下验证码是否正确
            [[Manager shareInstance] httpCheckMobileCodeWithMobileNumber:manager.memberInfoModel.u_mobile withCode:self.codeTextField.text withCodeSuccessResult:^(id successResult) {
                [SVProgressHUD dismiss];
                if ([successResult isEqualToString:@"200"]) {
                    //下一步
                    [self performSegueWithIdentifier:@"motifyNextVC" sender:nil];

                    
                }
            } withCodeFailResult:^(NSString *failResultStr) {
                //
                [SVProgressHUD dismiss];

                [alertM showAlertViewWithTitle:nil withMessage:[NSString stringWithFormat:@"短信验证码验证失败，%@",failResultStr ] actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    
                }];
                
            }];
            
        }else {
            NSLog(@"请输入验证码");
            [alertM showAlertViewWithTitle:nil withMessage:@"请输入验证码" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }
    }else {
        NSLog(@"请输入正确的手机号");
        [alertM showAlertViewWithTitle:nil withMessage:@"请输入正确的手机号" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

    }
    
}

- (void)keyboardDismissAction {
    [self.codeTextField resignFirstResponder];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self keyboardDismissAction];
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
