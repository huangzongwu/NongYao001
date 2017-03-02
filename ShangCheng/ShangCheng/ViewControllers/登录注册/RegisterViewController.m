//
//  RegisterViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/4.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "RegisterViewController.h"
#import "Manager.h"
#import "AlertManager.h"
#import "RegisterTwoViewController.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//定时器
@property (nonatomic,strong)NSTimer *tempTimer;
@property (nonatomic,assign)NSInteger countDownTime;//倒计时秒数

@end

@implementation RegisterViewController

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isRed = NO;
    //手机号输入框的操作，只有验证码输入框有内容，才有可能会变红
    if (textField == self.mobileNumberTextField && self.codeTextField.text.length > 0) {
        /*下面两个满足一个就变红
         1、id输入框在输入内容，
         2、id输入框消去内容，没有消除完
         */
        if (string.length > 0) {
            isRed = YES;
        }
        //如果id输入框在消去内容，
        if (string.length == 0 && range.location > 0) {
            isRed = YES;
        }
    }
    
    //验证码输入框，同上
    if (textField == self.codeTextField && self.mobileNumberTextField.text.length > 0) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置倒计时初始值
    self.countDownTime = 60;

}

//消失
- (IBAction)dismissRegisterVC:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if (self.mobileNumberTextField.text.length == 11) {
        //获取验证码
        [[Manager shareInstance] httpMobileCodeWithMobileNumber:self.mobileNumberTextField.text withCodeSuccessResult:^(id successResult) {
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

    }
    
}

//下一步
- (IBAction)nextButtonAction:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"registerNext" sender:sender];

    if (self.mobileNumberTextField.text.length == 11 ) {
        if (self.codeTextField.text.length > 0) {
            
            //验证一下验证码是否正确
            [[Manager shareInstance] httpCheckMobileCodeWithMobileNumber:self.mobileNumberTextField.text withCode:self.codeTextField.text withCodeSuccessResult:^(id successResult) {
                if ([successResult isEqualToString:@"200"]) {
                    //下一步
                    [self performSegueWithIdentifier:@"registerNext" sender:sender];
                    
                }
            } withCodeFailResult:^(NSString *failResultStr) {
                //
                AlertManager *alert = [AlertManager shareIntance];
                [alert showAlertViewWithTitle:nil withMessage:[NSString stringWithFormat:@"短信验证失败，%@",failResultStr ] actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                    
                }];

            }];
            
        }else {
            NSLog(@"请输入验证码");
        }
    }else {
        NSLog(@"请输入正确的手机号");
    }
     
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    RegisterTwoViewController *registerTwoVC = [segue destinationViewController];
    registerTwoVC.mobileNumber = self.mobileNumberTextField.text;
}


@end
