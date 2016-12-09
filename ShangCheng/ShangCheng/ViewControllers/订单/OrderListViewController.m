//
//  OrderListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/6.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListOneTableViewCell.h"
#import "OrderListTwoTableViewCell.h"
#import "OrderListFootOneTableViewCell.h"
#import "OrderListFootTwoTableViewCell.h"
#import "LineButton.h"
#import "Manager.h"
@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
//切换分类的scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

//全部
@property (weak, nonatomic) IBOutlet LineButton *allButton;
//待付款
@property (weak, nonatomic) IBOutlet LineButton *waitPayButton;
//进行中
@property (weak, nonatomic) IBOutlet LineButton *goOnButton;
//已完成
@property (weak, nonatomic) IBOutlet LineButton *finishButton;


//1-全部  2-待付款  3-进行中  4-已完成
@property (nonatomic,strong)NSString *orderStateStr;
//全部TableView
@property (weak, nonatomic) IBOutlet UITableView *allTableView;
//待付款TableView
@property (weak, nonatomic) IBOutlet UITableView *waitPayTableView;
//进行中TableView
@property (weak, nonatomic) IBOutlet UITableView *goOnTableView;
//已完成TableView
@property (weak, nonatomic) IBOutlet UITableView *finishTableView;
//合并付款的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTogetherHeightLayout;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
    OrderListOneTableViewCell---orderListOneCell
    OrderListTwoTableViewCell---orderListTwoCell
    OrderListFootOneTableViewCell---orderListFootOneCell
    OrderListFootTwoTableViewCell---orderListFootTwoCell
    */
    //注册cell
    [self.allTableView registerNib:[UINib nibWithNibName:@"OrderListOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListOneCell"];
    [self.allTableView registerNib:[UINib nibWithNibName:@"OrderListTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListTwoCell"];
    [self.allTableView registerNib:[UINib nibWithNibName:@"OrderListFootOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListFootOneCell"];
    [self.allTableView registerNib:[UINib nibWithNibName:@"OrderListFootTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListFootTwoCell"];

    
    //
    self.orderStateStr = @"1";
    
    Manager *manager = [Manager shareInstance];
    //登录了，才可以请求数据。默认请求全部数据
    if ([manager isLoggedInStatus] == YES) {
        [self httpOrderListWithPageIndex:@"1" withDownPushRefresh:NO withUpPushRoload:NO withTableView:self.allTableView];
    }
}

//请求订单数据
- (void)httpOrderListWithPageIndex:(NSString *)pageIndex withDownPushRefresh:(BOOL)downPushRefresh withUpPushRoload:(BOOL)upPushRoload withTableView:(UITableView *)tempTableView  {
    
    Manager *manager = [Manager shareInstance];
    
    [manager getOrderListDataWithUserID:manager.memberInfoModel.u_id withOrderStatus:self.orderStateStr withPageIndex:pageIndex withPageSize:@"4" downPushRefresh:downPushRefresh withUpPushReload:upPushRoload withOrderListSuccessResult:^(id successResult) {
        [tempTableView reloadData];
    } withOrderListFailResult:^(NSString *failResultStr) {
        NSLog(@"%@", failResultStr);
    }];
    
}

#pragma mark - 四大按钮 -
//全部
- (IBAction)allButtonAction:(LineButton *)sender {
    self.orderStateStr = @"1";
    //没有合并付款
    self.payTogetherHeightLayout.constant = 0;
    self.backScrollView.contentOffset = CGPointMake(0, 0);
    Manager *manager = [Manager shareInstance];
    //登录了，才可以请求数据。默认请求全部数据
    if ([manager isLoggedInStatus] == YES) {
        [self httpOrderListWithPageIndex:@"1" withDownPushRefresh:NO withUpPushRoload:NO withTableView:self.allTableView];
    }

}
//待付款
- (IBAction)waitPayButtonAction:(LineButton *)sender {
    self.orderStateStr = @"2";
    //没有合并付款
    self.payTogetherHeightLayout.constant = 30;
    self.backScrollView.contentOffset = CGPointMake(kScreenW, 0);

    Manager *manager = [Manager shareInstance];
    //登录了，才可以请求数据。默认请求全部数据
    if ([manager isLoggedInStatus] == YES) {
        [self httpOrderListWithPageIndex:@"1" withDownPushRefresh:NO withUpPushRoload:NO withTableView:self.waitPayTableView];
    }


}
//进行中
- (IBAction)goOnButtonAction:(LineButton *)sender {
    self.orderStateStr = @"3";
    //没有合并付款
    self.payTogetherHeightLayout.constant = 0;
    self.backScrollView.contentOffset = CGPointMake(kScreenW*2, 0);

    Manager *manager = [Manager shareInstance];
    //登录了，才可以请求数据。默认请求全部数据
    if ([manager isLoggedInStatus] == YES) {
        [self httpOrderListWithPageIndex:@"1" withDownPushRefresh:NO withUpPushRoload:NO withTableView:self.goOnTableView];
    }


}
//已完成
- (IBAction)finishButtonAction:(LineButton *)sender {
    self.orderStateStr = @"4";
    //没有合并付款
    self.payTogetherHeightLayout.constant = 0;
    self.backScrollView.contentOffset = CGPointMake(kScreenW*3, 0);

    Manager *manager = [Manager shareInstance];
    //登录了，才可以请求数据。默认请求全部数据
    if ([manager isLoggedInStatus] == YES) {
        [self httpOrderListWithPageIndex:@"1" withDownPushRefresh:NO withUpPushRoload:NO withTableView:self.finishTableView];
    }
    
}



#pragma mark - TableViewDetegate - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *dataArr = [[Manager shareInstance].orderListDataSourceDic objectForKey:self.orderStateStr];
    
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSMutableArray *dataArr = [[Manager shareInstance].orderListDataSourceDic objectForKey:self.orderStateStr];

    SupOrderModel *supOrderModel = dataArr[section];
    //待付款，（这里不包含1A--待确认）
    if ([supOrderModel.p_status isEqualToString:@"0"] || [supOrderModel.p_status isEqualToString:@"1B"] ) {
        OrderListFootOneTableViewCell *footOneCell = [tableView dequeueReusableCellWithIdentifier:@"orderListFootOneCell"];
        footOneCell.orderPayButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
        footOneCell.orderCancelButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
        
        return footOneCell;
    }else {
        
        OrderListFootTwoTableViewCell *footTwoCell = [tableView dequeueReusableCellWithIdentifier:@"orderListFootTwoCell"];
        footTwoCell.orderDetailInfoButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
        
        return footTwoCell;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *dataArr = [[Manager shareInstance].orderListDataSourceDic objectForKey:self.orderStateStr];
    
    SupOrderModel *supOrderModel = dataArr[indexPath.section];
    
    if (supOrderModel.subOrderArr.count < 2) {
        OrderListOneTableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"orderListOneCell" forIndexPath:indexPath];
        [oneCell updateOrderLIstOneCellWithModel:supOrderModel];
        return oneCell;
    }else {
        OrderListTwoTableViewCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"orderListTwoCell" forIndexPath:indexPath];
        
        return twoCell;
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
