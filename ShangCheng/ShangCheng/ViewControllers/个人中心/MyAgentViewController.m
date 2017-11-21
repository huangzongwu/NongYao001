//
//  MyAgentViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentViewController.h"
#import "Manager.h"
#import "MyAgentPeopleTableViewCell.h"
#import "MyAgentOrderTableViewCell.h"
#import "SVProgressHUD.h"
#import "AgentCashApplicationViewController.h"
@interface MyAgentViewController ()<UITableViewDataSource,UITableViewDelegate>
//头部收益金额
@property (weak, nonatomic) IBOutlet UILabel *incomeAmountLabel;
//人员button
@property (weak, nonatomic) IBOutlet UIButton *peopleNumberButton;
@property (weak, nonatomic) IBOutlet UIView *peopleNumberLine;
//订单button
@property (weak, nonatomic) IBOutlet UIButton *orderNumberButton;
@property (weak, nonatomic) IBOutlet UIView *orderNumberLine;


@property (weak, nonatomic) IBOutlet UITableView *myAgentTableView;
//类型，是人员或者订单 peopleType orderType
@property (nonatomic,strong)NSString *currentTypeStr;
//人员页数
@property (nonatomic,assign)NSInteger peoplePageIndex;
//订单页数
@property (nonatomic,assign)NSInteger orderPageIndex;


@end

@implementation MyAgentViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，刷新代理商信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMoneyNew:) name:@"refreshMoneyNew" object:nil];
        
    }
    return self;
}

//刷新代理商金额
- (void)refreshMoneyNew:(NSNotification *)sender {
    Manager *manager = [Manager shareInstance];
    [self httpMyAgentDataWithUserType:manager.memberInfoModel.u_type];
}


- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    //清空一下订单数据，以便下次进来请求最新数据
    Manager *manager = [Manager shareInstance];
    [manager.myAgentDic setValue:nil forKey:@"order"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Manager *manager = [Manager shareInstance];

    // 让cell自适应高度
    self.myAgentTableView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.myAgentTableView.estimatedRowHeight = 44;
    
    //默认为第一页
    self.peoplePageIndex = 1;
    self.orderPageIndex = 1;
    //默认为人员类型
    self.currentTypeStr = @"peopleType";
    
    
    //网络请求人员数据
    if ([SVProgressHUD isVisible] == NO) {
        [SVProgressHUD show];
    }

    [manager httpMyAgentPeopleListDataWithUserId:manager.memberInfoModel.u_id withPageindex:1 withMyAgentSuccess:^(id successResult) {
        [SVProgressHUD dismiss];
        [self.myAgentTableView reloadData];
        
    } withMyagentFail:^(NSString *failResultStr) {
        [SVProgressHUD dismiss];
    }];
    
    
    //更新头部view
    [self upHeaderView];
    
}

#pragma mark - 请求代理信息 -
//网络请求代理数据
- (void)httpMyAgentDataWithUserType:(NSString *)userType {
    Manager *manager = [Manager shareInstance];
    //如果是代理。请求代理数据
    if ([userType integerValue] == 1) {
        [manager httpMyAgentBaseDataWithUserId:manager.memberInfoModel.u_id withMyAgentSuccess:^(id successResult) {
            
            if (manager.myAgentDic != nil) {
                [self upHeaderView];

            }
            
        } withMyagentFail:^(NSString *failResultStr) {
            
        }];
        
    }
    
}


//更新头部View
- (void)upHeaderView {
    
    Manager *manager = [Manager shareInstance];
    
    self.incomeAmountLabel.text = [manager.myAgentDic objectForKey:@"a_commission"];
    [self.orderNumberButton setTitle:[NSString stringWithFormat:@"订单(%@)",[manager.myAgentDic objectForKey:@"ordernum"] ] forState:UIControlStateNormal];
    [self.peopleNumberButton setTitle:[NSString stringWithFormat:@"人员(%@)", [manager.myAgentDic objectForKey:@"peonum"] ] forState:UIControlStateNormal];

}

//人员
- (IBAction)peopleButtonAction:(UIButton *)sender {
    //只有当前为订单类型，点击人员按钮才有效果
    if ([self.currentTypeStr isEqualToString:@"orderType"]) {
        //更改类型
        self.currentTypeStr = @"peopleType";
        //变换颜色
        [self.peopleNumberButton setTitleColor:kMainColor forState:UIControlStateNormal];
        self.peopleNumberLine.backgroundColor = kMainColor;
        [self.orderNumberButton setTitleColor:k333333Color forState:UIControlStateNormal];
        self.orderNumberLine.backgroundColor = [UIColor whiteColor];
        
        
        
        Manager *manager = [Manager shareInstance];
        
        if ([manager.myAgentDic objectForKey:@"people"] != nil && [[manager.myAgentDic objectForKey:@"people"] isKindOfClass:[NSMutableArray class]]) {
            //不用请求，刷新cell
            NSLog(@"不用请求，只做刷新cell");
            [self.myAgentTableView reloadData];

            
        }else {
            //需要请求
            //网络请求人员数据
            if ([SVProgressHUD isVisible] == NO) {
                [SVProgressHUD show];
            }

            [manager httpMyAgentPeopleListDataWithUserId:manager.memberInfoModel.u_id withPageindex:1 withMyAgentSuccess:^(id successResult) {
                [SVProgressHUD dismiss];
                
                [self.myAgentTableView reloadData];
                
            } withMyagentFail:^(NSString *failResultStr) {
                [SVProgressHUD dismiss];
            }];
            
        }

        
        
    }
    
}
//订单
- (IBAction)orderButtonAction:(UIButton *)sender {
    //只有当前为人员类型，点击订单按钮才有效果
    if ([self.currentTypeStr isEqualToString:@"peopleType"]) {
        //更改类型
        self.currentTypeStr = @"orderType";
        //变换颜色
        [self.orderNumberButton setTitleColor:kMainColor forState:UIControlStateNormal];
        self.orderNumberLine.backgroundColor = kMainColor;
        [self.peopleNumberButton setTitleColor:k333333Color forState:UIControlStateNormal];
        self.peopleNumberLine.backgroundColor = [UIColor whiteColor];

        
        
        Manager *manager = [Manager shareInstance];
        if ([manager.myAgentDic objectForKey:@"order"] != nil && [[manager.myAgentDic objectForKey:@"order"] isKindOfClass:[NSMutableArray class]]) {
            //不用请求，刷新cell
            NSLog(@"不用请求，只做刷新cell");
            [self.myAgentTableView reloadData];
            
        }else {
            //需要请求
            //网络请求订单数据
            if ([SVProgressHUD isVisible] == NO) {
                [SVProgressHUD show];
            }

            [manager httpMyAgentOrderListDataWithUserId:manager.memberInfoModel.u_id withPageindex:1 withMyAgentSuccess:^(id successResult) {
                [SVProgressHUD dismiss];
                
                [self.myAgentTableView reloadData];
                
            } withMyagentFail:^(NSString *failResultStr) {
                [SVProgressHUD dismiss];
            }];
            
            
        }

    }
    
}


#pragma mark - TableView Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    if ([self.currentTypeStr isEqualToString:@"peopleType"]) {
        if ([manager.myAgentDic objectForKey:@"people"] != nil && [[manager.myAgentDic objectForKey:@"people"] isKindOfClass:[NSMutableArray class]]) {
            return [[manager.myAgentDic objectForKey:@"people"] count];
        }
        
    }
    
    if ([self.currentTypeStr isEqualToString:@"orderType"]) {
        if ([manager.myAgentDic objectForKey:@"order"] != nil && [[manager.myAgentDic objectForKey:@"order"] isKindOfClass:[NSMutableArray class]]) {
            return [[manager.myAgentDic objectForKey:@"order"] count];
        }
        
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    
    if ([self.currentTypeStr isEqualToString:@"peopleType"]) {
        MyAgentPeopleTableViewCell *peopleCell = [tableView dequeueReusableCellWithIdentifier:@"agentPeopleCell" forIndexPath:indexPath];
        MyAgentPeopleModel *peopleModel = [[manager.myAgentDic objectForKey:@"people"] objectAtIndex:indexPath.row];
        [peopleCell updateMyAgentPeopleCellWithAgentModel:peopleModel];
        return peopleCell;
    }
    
    if ([self.currentTypeStr isEqualToString:@"orderType"]) {
        MyAgentOrderTableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"agentOrderCell" forIndexPath:indexPath];
        MyAgentOrderModel *orderModel = [[manager.myAgentDic objectForKey:@"order"] objectAtIndex:indexPath.row];

        [orderCell updateMyAgentOrderCellWithAgentModel:orderModel];

        return orderCell;
    }
    return 0;
    
    
}

#pragma mark - 代理商提现 -
- (IBAction)AgentCashBtnAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    if ([[manager.myAgentDic objectForKey:@"a_commission"] floatValue] > 0) {
        //跳转到提现界面
        [self performSegueWithIdentifier:@"myAgentToCashVC" sender:nil];
        
        
    }else {
        [alertM showAlertViewWithTitle:@"暂时不能提现" withMessage:@"您还没有收益" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
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
    if ([segue.identifier isEqualToString:@""]) {
        AgentCashApplicationViewController *agentCashVC = [segue destinationViewController];
        agentCashVC.cashType = @"agentCash";
    }
}


@end
