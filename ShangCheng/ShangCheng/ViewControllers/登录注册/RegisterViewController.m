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
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

//消失
- (IBAction)dismissRegisterVC:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//获取短信验证码
- (IBAction)getMobileNumber:(UIButton *)sender {
    
    //获取验证码
    [[Manager shareInstance] httpMobileCodeWithMobileNumber:self.mobileNumberTextField.text withCodeSuccessResult:^(id successResult) {
        if ([successResult isEqualToString:@"200"]) {
            AlertManager *alert = [AlertManager shareIntance];
            [alert showAlertViewWithTitle:nil withMessage:@"短信验证码发送成功，请注意查收" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                //开始倒计时
                
            }];
        }
    } withCodeFailResult:^(NSString *failResultStr) {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:[NSString stringWithFormat:@"短信验证发送失败，%@",failResultStr ] actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            
        }];
    }];
    
}

//下一步
- (IBAction)nextButtonAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"registerNext" sender:sender];

/*
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
    */
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
