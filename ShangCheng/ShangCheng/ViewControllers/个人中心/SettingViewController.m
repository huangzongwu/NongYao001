//
//  SettingViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "SettingViewController.h"
#import "Manager.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
//退出登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginOffButton;

@property (nonatomic,strong)NSArray *dataSourceArr;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSourceArr = @[@[@"清除缓存",@"消息推送"],@[@"我要评价"]];
    
    //判断是否登录了，如果没有登录，退出登录就要隐藏
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        self.loginOffButton.hidden = NO;
    }else {
        self.loginOffButton.hidden = YES;
    }
    
    
}

#pragma mark - TableView Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.dataSourceArr[indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
    
}

//退出登录按钮
- (IBAction)logOffButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    
    AlertManager *alert = [AlertManager shareIntance];
    [alert showAlertViewWithTitle:nil withMessage:@"确定退出登录" actionTitleArr:@[@"确定" ,@"取消"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 0) {
            //确定按钮， 退出登录；
            [manager logOffAction];
            //返回到个人中心首页
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
    }];
    
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
