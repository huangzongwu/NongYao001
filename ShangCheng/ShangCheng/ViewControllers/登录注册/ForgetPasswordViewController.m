//
//  ForgetPasswordViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/20.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "Manager.h"
#import "ForgetPasswordTwoViewController.h"
@interface ForgetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;


//定时器
@property (nonatomic,strong)NSTimer *tempTimer;
@property (nonatomic,assign)NSInteger countDownTime;//倒计时秒数

@end

@implementation ForgetPasswordViewController

- (IBAction)leftBatButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isRed = NO;
    
    //验证码输入框，只有手机输入框有内容，才有可能会变红
    if (textField == self.codeTextField) {
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
    
    self.mobileLabel.text = [NSString stringWithFormat:@"当前绑定手机号：%@",self.tempMobile];

}


#pragma mark - 获取验证码 和 倒计时 -
- (IBAction)getCodeButtonAction:(UIButton *)sender {

    //获取验证码
        [[Manager shareInstance] httpMobileCodeWithMobileNumber:self.tempMobile withCodeSuccessResult:^(id successResult) {
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


//下一步
- (IBAction)nextButtonAction:(UIButton *)sender {
    //验证码检验
    if (self.codeTextField.text > 0) {
        //验证一下验证码是否正确
        [[Manager shareInstance] httpCheckMobileCodeWithMobileNumber:self.tempMobile withCode:self.codeTextField.text withCodeSuccessResult:^(id successResult) {
            if ([successResult isEqualToString:@"200"]) {
                //下一步
                [self performSegueWithIdentifier:@"forgetPasswordToTwoVC" sender:sender];
                
            }
        } withCodeFailResult:^(NSString *failResultStr) {
            //
            AlertManager *alert = [AlertManager shareIntance];
            [alert showAlertViewWithTitle:nil withMessage:[NSString stringWithFormat:@"短信验证失败，%@",failResultStr ] actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                
            }];
        }];


    }else {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"请输入短信验证码" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            
        }];

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
    
    if ([segue.identifier isEqualToString:@"forgetPasswordToTwoVC"]) {
        ForgetPasswordTwoViewController *forgetPasswordTwoVC = [segue destinationViewController];
        forgetPasswordTwoVC.tempMobile = self.tempMobile;
    }

    
}


@end
