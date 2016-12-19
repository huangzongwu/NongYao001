//
//  RegisterTwoViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/4.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "RegisterTwoViewController.h"
#import "Manager.h"
@interface RegisterTwoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;

//地区编码
@property (nonatomic,strong)NSString *areaID;

@end

@implementation RegisterTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#warning 假数据，地区
    self.areaID = @"22143";
    
    
}

//注册
- (IBAction)registerButtonAction:(UIButton *)sender {
    
    if (self.passwordTextField.text.length > 0 && self.passwordAgainTextField.text.length > 0) {
        
        if ([self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text]) {
            
            //注册
            [[Manager shareInstance] httpRegisterWithMobileNumber:self.mobileNumber withPassword:self.passwordTextField.text withUserType:@"2" withAreaId:@"22143" withRegisterSuccess:^(id successResult) {
                
            } withRegisterFailResult:^(NSString *failResultStr) {
                
            }];
            
            
            
        }else {
            NSLog(@"两个密码不一样");
        }
        
    }else {
        NSLog(@"密码输入框不能为空");
    }
    
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
