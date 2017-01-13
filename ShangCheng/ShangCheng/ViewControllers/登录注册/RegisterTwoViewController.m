//
//  RegisterTwoViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/4.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "RegisterTwoViewController.h"
#import "SelectAddressView.h"
#import "Manager.h"
@interface RegisterTwoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;

@property (weak, nonatomic) IBOutlet UIButton *selectAreaButton;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@property (nonatomic,strong) SelectAddressView *selectAddressView;



//地区选择器
//@property (weak, nonatomic) IBOutlet UIPickerView *areaPickView;
//地区选择器背景view
//@property (weak, nonatomic) IBOutlet UIView *areaBackView;

//地区编码
@property (nonatomic,strong)NSString *areaID;


//@property (nonatomic,assign)NSInteger oldShengInt;
//@property (nonatomic,assign)NSInteger oldShiInt;
//@property (nonatomic,assign)NSInteger oldQuInt;
//
//@property (nonatomic,assign)NSInteger selectShengInt;
//@property (nonatomic,assign)NSInteger selectShiInt;
//@property (nonatomic,assign)NSInteger selectQuInt;

@end

@implementation RegisterTwoViewController
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isRed = NO;
    //第一个密码输入框操作，只有第二个密码输入框内容大于5，才有可能会变红
    if (textField == self.passwordTextField && self.passwordAgainTextField.text.length > 5) {
        /*下面两个满足一个就变红
         1、第一个密码输入框在输入内容,内容大于等于6,即location>4，
         2、第一个密码输入框消去内容，内容还大于等于6,即location>5
         */

        if (string.length > 0 && range.location > 4) {
            isRed = YES;
        }
        //如果id输入框在消去内容，
        if (string.length == 0 && range.location > 5) {
            isRed = YES;
        }
    }
    
    //验证码输入框，同上
    if (textField == self.passwordAgainTextField && self.passwordTextField.text.length > 5) {
        if (string.length > 0 && range.location > 4) {
            isRed = YES;
        }
        if (string.length == 0 && range.location > 5) {
            isRed = YES;
        }
    }
    
    if (isRed == YES) {
        //红色可点击
        self.registerButton.enabled = YES;
        self.registerButton.backgroundColor = kColor(208,23,21, 1);
    }else {
        //灰色不可点击
        self.registerButton.enabled = NO;
        self.registerButton.backgroundColor = kColor(238, 238, 238, 1);
    }
    
    return YES;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载地区pickview
    self.selectAddressView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddressView" owner:self options:nil] firstObject];
    self.selectAddressView.frame = self.view.frame;
    //首先先隐藏
    self.selectAddressView.hidden = YES;
    [self.view addSubview:self.selectAddressView];

    
    
}

- (IBAction)selectAreaInfoButton:(UIButton *)sender {
    
    [self.passwordTextField resignFirstResponder];
    [self.passwordAgainTextField resignFirstResponder];
    
    
    //得到地区数据，然后显示
    Manager *manager = [Manager shareInstance];
    if (manager.areaArr.count > 0 ) {
        //说明有数据
        NSLog(@"地区成功1");
        //显示pickView
        [self showAddressPickView];

    }else {
        //没有数据，就从本地获取或者网络请求
        [manager httpAreaTreeWithSuccessAreaInfo:^(id successResult) {
            NSLog(@"地区成功2");
            //刷新pickView
            [self showAddressPickView];
            
        } withFailAreaInfo:^(NSString *failResultStr) {
            NSLog(@"地区请求失败");
        }];
    }
}

//显示pickView
- (void)showAddressPickView {
    [self.selectAddressView showPickerViewEnterSelectAreaWithAreaInfo:^(NSString *areaId, NSString *shengStr, NSString *shiStr, NSString *quStr) {
        
        NSLog(@"地区id%@",areaId);
        self.areaID = areaId;
        [self.selectAreaButton setTitle:[NSString stringWithFormat:@"%@ %@ %@",shengStr,shiStr,quStr] forState:UIControlStateNormal];
    }];
    
//    //将老的Int赋给新的Int，用于刷新
//    self.selectShengInt = self.oldShengInt;
//    self.selectShiInt = self.oldShiInt;
//    self.selectQuInt = self.oldQuInt;
    
//    [self.areaPickView reloadAllComponents];
//    //滚动到Int的地方
//    [self.areaPickView selectRow:self.selectShengInt inComponent:0 animated:NO];
//    [self.areaPickView selectRow:self.selectShiInt inComponent:1 animated:NO];
//    [self.areaPickView selectRow:self.selectQuInt inComponent:2 animated:NO];

}

//#pragma mark - pickerView delegate -
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    Manager *manager = [Manager shareInstance];
//    if (manager.areaArr.count > 0 ) {
//        return 3;
//    }else {
//        return 0;
//    }
//}
//
////每个分区有多少行
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    Manager *manager = [Manager shareInstance];
//
//        switch (component) {
//        case 0:
//            //省
//            return manager.areaArr.count;
//            break;
//        case 1:
//            //市
//        {
//            NSArray *shiArr = [manager.areaArr[self.selectShengInt] objectForKey:@"item"];
//            return shiArr.count;
//
//        }
//            
//            break;
//        case 2:
//                //区
//            {
//                //得到市数组
//                NSArray *shiArr = [manager.areaArr[self.selectShengInt] objectForKey:@"item"];
//                //得到区数组
//                NSArray *quArr = [shiArr[self.selectShiInt] objectForKey:@"item"];
//                return quArr.count;
//            }
//            break;
//     
//        default:
//                return 0;
//            break;
//    }
//
//}
//
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    Manager *manager = [Manager shareInstance];
//    NSString *titleStr ;
//    switch (component) {
//        case 0:
//            //省
//            titleStr = [manager.areaArr[row] objectForKey:@"a_name"];
//            break;
//        case 1:
//            //市
//        {
//            NSArray *shiArr = [manager.areaArr[self.selectShengInt] objectForKey:@"item"];
//            titleStr = [shiArr[row] objectForKey:@"a_name"];
//        }
//            break;
//        case 2:
//            //区
//        {
//            //得到市数组
//            NSArray *shiArr = [manager.areaArr[self.selectShengInt] objectForKey:@"item"];
//            //得到区数组
//            NSArray *quArr = [shiArr[self.selectShiInt] objectForKey:@"item"];
//            titleStr = [quArr[row] objectForKey:@"a_name"];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 40)] ;
//    myView.textAlignment = NSTextAlignmentCenter;
//    myView.text =titleStr;
//    myView.textColor = kColor(51, 51, 51, 1);
//    myView.font = [UIFont systemFontOfSize:16];         //用label来设置字体大小
//    return myView;
//}
//
////行高
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
//    return 40;
//}
//
////选择了哪一行
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSLog(@"点击%ld--%ld",component,row);
//    switch (component) {
//        case 0:
//        {
//            //选择省
//            self.selectShengInt = row;
//            //市和区归0
//            self.selectShiInt = 0;
//            self.selectQuInt = 0;
//            //刷新
//            [self.areaPickView reloadComponent:1];
//            [self.areaPickView selectRow:0 inComponent:1 animated:YES];
//            [self.areaPickView reloadComponent:2];
//            [self.areaPickView selectRow:0 inComponent:2 animated:YES];
//        }
//            break;
//        case 1:
//        {
//            //选择市
//            self.selectShiInt = row;
//            //区 归0
//            self.selectQuInt = 0;
//            //刷新
//            [self.areaPickView reloadComponent:2];
//            [self.areaPickView selectRow:0 inComponent:2 animated:YES];
//
//            
//        }
//            break;
//        case 2:
//        {
//            //选择区
//            self.selectQuInt = row;
//        }
//            break;
//    
//        default:
//            break;
//    }
//    
//}
//
//
////取消 选择地区按钮
//- (IBAction)cancelSelectAreaButtonAction:(UIButton *)sender {
//
//    //消失
//    self.areaBackView.hidden = YES;
//    
//}
////确定选择地区按钮
//- (IBAction)enterSelectAreaButtonAction:(UIButton *)sender {
//    Manager *manager = [Manager shareInstance];
//    
//    //地区编码记录一下
//    //得到省名称
//    NSString *shengStr = [manager.areaArr[self.selectShengInt] objectForKey:@"a_name"];
//    //得到市数组
//    NSArray *shiArr = [manager.areaArr[self.selectShengInt] objectForKey:@"item"];
//    //得到市名称
//    NSString *shiStr = [shiArr[self.selectShiInt] objectForKey:@"a_name"];
//    //得到区数组
//    NSArray *quArr = [shiArr[self.selectShiInt] objectForKey:@"item"];
//    //得到区名称
//    NSString *quStr = [quArr[self.selectQuInt] objectForKey:@"a_name"];
//    //得到区编码
//    self.areaID = [quArr[self.selectQuInt] objectForKey:@"a_num"];
//
//    //将省市区名称拼接，赋值到button上
//    [self.selectAreaButton setTitle:[NSString stringWithFormat:@"%@  %@  %@",shengStr,shiStr,quStr] forState:UIControlStateNormal ];
//    
//    //将新的Int赋给老的int
//    self.oldShengInt = self.selectShengInt;
//    self.oldShiInt = self.selectShiInt;
//    self.oldQuInt = self.selectQuInt;
//
//    //消失
//    self.areaBackView.hidden = YES;
//
//
//}


//注册
- (IBAction)registerButtonAction:(UIButton *)sender {
    if (self.areaID != nil && ![self.areaID isEqualToString:@""]) {
        if ([self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text]) {
            //注册
            [[Manager shareInstance] httpRegisterWithMobileNumber:self.mobileNumber withPassword:self.passwordTextField.text withUserType:@"2" withAreaId:self.areaID withRegisterSuccess:^(id successResult) {
                if ([successResult isEqualToString:@"注册成功"]) {
                    AlertManager *alert = [AlertManager shareIntance];
                    [alert showAlertViewWithTitle:nil withMessage:successResult actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                }
                
                
            } withRegisterFailResult:^(NSString *failResultStr) {
                
                AlertManager *alert = [AlertManager shareIntance];
                [alert showAlertViewWithTitle:nil withMessage:failResultStr actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                
            }];
            
        }else {
            AlertManager *alert = [AlertManager shareIntance];
            [alert showAlertViewWithTitle:nil withMessage:@"两个密码输入的不一致" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];        }
    }else {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"请您选择所在地区" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
}

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
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
