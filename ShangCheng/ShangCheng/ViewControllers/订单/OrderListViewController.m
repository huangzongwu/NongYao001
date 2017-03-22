//
//  OrderListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/6.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderListViewController.h"
#import "PayViewController.h"
#import "OrderListOneTableViewCell.h"
#import "OrderListTwoTableViewCell.h"
#import "OrderListFootOneTableViewCell.h"
#import "OrderListFootTwoTableViewCell.h"
#import "OrderDetailViewController.h"
#import "LineButton.h"
#import "MJRefresh.h"
#import "Manager.h"
#import "KongImageView.h"
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

//哪个TabelView 1-全部  2-待付款  3-进行中  4-已完成
@property (nonatomic,strong)NSString *whichTableView;
//全部TableView
@property (weak, nonatomic) IBOutlet UITableView *allTableView;
//待付款TableView
@property (weak, nonatomic) IBOutlet UITableView *waitPayTableView;
//进行中TableView
@property (weak, nonatomic) IBOutlet UITableView *goOnTableView;
//已完成TableView
@property (weak, nonatomic) IBOutlet UITableView *finishTableView;

//是否需要更新
@property (nonatomic,strong)NSMutableArray *isHttpArr;
@property (nonatomic,strong)NSMutableArray *currentPageArr;//当前是第几页

//合并付款的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTogetherHeightLayout;
//空白页
@property (nonatomic,strong)KongImageView *kongImageView1;
@property (nonatomic,strong)KongImageView *kongImageView2;
@property (nonatomic,strong)KongImageView *kongImageView3;
@property (nonatomic,strong)KongImageView *kongImageView4;

@end

@implementation OrderListViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //默认的是1
        self.whichTableView = @"1";

        //通知，需要刷新
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshOrderListNotification:) name:@"refreshOrderList" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshOrderListNotification:) name:@"logedIn" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshOrderListNotification:) name:@"logOff" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchOrderType:) name:@"mineToOrderListVC" object:nil];

    }
    return self;
}


//重新请求数据进行刷新
- (void)refreshOrderListNotification:(NSNotification *)sender {
    //标记一下有数据变动，需要刷新
    self.isHttpArr = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",nil];
    
}

//跳转到对应的订单类型
- (void)switchOrderType:(NSNotification *)sender {

    //更改whichTableView
    self.whichTableView = [sender.userInfo objectForKey:@"orderType"];
  
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //登录了，才可以请求数据。默认请求全部数据
    
    //请求数据
    switch ([self.whichTableView integerValue]) {
        case 1:
            //检查是否需要更新
            if ([self.isHttpArr[0] isEqualToString:@"1"]) {
                [self.allTableView headerBeginRefreshing];
            }
            break;
        case 2:
            if ([self.isHttpArr[1] isEqualToString:@"1"]) {
                [self.waitPayTableView headerBeginRefreshing];
            }
            break;
        case 3:
            if ([self.isHttpArr[2] isEqualToString:@"1"]) {
                [self.goOnTableView headerBeginRefreshing];
            }
            break;
        case 4:
            if ([self.isHttpArr[3] isEqualToString:@"1"]) {
                [self.finishTableView headerBeginRefreshing];
            }
            break;
        default:
            break;
    }
        
    
}

//下拉刷新
- (void)downPushRefresh {
    
        [self.allTableView addHeaderWithCallback:^{
            NSLog(@"全部tableView刷新");
            
            [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:1 withTableView:self.allTableView];
        }];
        [self.waitPayTableView addHeaderWithCallback:^{
            NSLog(@"待付款tableView刷新");
            [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:1 withTableView:self.waitPayTableView];
        }];
        [self.goOnTableView addHeaderWithCallback:^{
            NSLog(@"进行中tableView刷新");
            [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:1  withTableView:self.goOnTableView];
        }];
        [self.finishTableView addHeaderWithCallback:^{
            NSLog(@"已完成tableView刷新");
            [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:1 withTableView:self.finishTableView];
        }];
    
}

//上拉加载
- (void)upPushLoad {
    
    [self.allTableView addFooterWithCallback:^{
        NSLog(@"全部tableView加载");
        //现在第几页
        NSInteger tempCurrentPage = [self.currentPageArr[0] integerValue] ;
        //总共有几页
        NSInteger totalPage = [[[[Manager shareInstance].orderListDataSourceDic objectForKey:self.whichTableView] objectForKey:@"totalpages"] integerValue];

        if (tempCurrentPage < totalPage) {

            [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:tempCurrentPage+1 withTableView:self.allTableView];

        }else {
            [self.allTableView footerEndRefreshing];
        }
    }];
    
    [self.waitPayTableView addFooterWithCallback:^{
        NSLog(@"待付款tableView加载");
        NSInteger tempCurrentPage = [self.currentPageArr[1] integerValue] ;
        //总共有几页
        NSInteger totalPage = [[[[Manager shareInstance].orderListDataSourceDic objectForKey:self.whichTableView] objectForKey:@"totalpages"] integerValue];
        if (tempCurrentPage < totalPage) {

            [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:tempCurrentPage+1 withTableView:self.waitPayTableView];
        }else{
            [self.waitPayTableView footerEndRefreshing];
        }
    }];
    [self.goOnTableView addFooterWithCallback:^{
        NSLog(@"进行中tableView加载");
        NSInteger tempCurrentPage = [self.currentPageArr[2] integerValue] ;
        //总共有几页
        NSInteger totalPage = [[[[Manager shareInstance].orderListDataSourceDic objectForKey:self.whichTableView] objectForKey:@"totalpages"] integerValue];
        if (tempCurrentPage < totalPage) {

            [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:tempCurrentPage+1  withTableView:self.goOnTableView];
        }else {
            [self.goOnTableView footerEndRefreshing];
        }
    }];
    [self.finishTableView addFooterWithCallback:^{
        NSLog(@"已完成tableView加载");
        NSInteger tempCurrentPage = [self.currentPageArr[3] integerValue] ;
        //总共有几页
        NSInteger totalPage = [[[[Manager shareInstance].orderListDataSourceDic objectForKey:self.whichTableView] objectForKey:@"totalpages"] integerValue];
        if (tempCurrentPage < totalPage) {


            [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:tempCurrentPage withTableView:self.finishTableView];
        }else {
            [self.finishTableView footerEndRefreshing];
        }
    }];

    
}

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
    //全部的tableView
    [self.allTableView registerNib:[UINib nibWithNibName:@"OrderListOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListOneCell"];
    [self.allTableView registerNib:[UINib nibWithNibName:@"OrderListTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListTwoCell"];
    [self.allTableView registerNib:[UINib nibWithNibName:@"OrderListFootOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListFootOneCell"];
    [self.allTableView registerNib:[UINib nibWithNibName:@"OrderListFootTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListFootTwoCell"];

    //待支付的TableView
    [self.waitPayTableView registerNib:[UINib nibWithNibName:@"OrderListOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListOneCell"];
    [self.waitPayTableView registerNib:[UINib nibWithNibName:@"OrderListTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListTwoCell"];
    [self.waitPayTableView registerNib:[UINib nibWithNibName:@"OrderListFootOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListFootOneCell"];
    [self.waitPayTableView registerNib:[UINib nibWithNibName:@"OrderListFootTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListFootTwoCell"];
    
    //进行中的TableView
    [self.goOnTableView registerNib:[UINib nibWithNibName:@"OrderListOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListOneCell"];
    [self.goOnTableView registerNib:[UINib nibWithNibName:@"OrderListTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListTwoCell"];
    [self.goOnTableView registerNib:[UINib nibWithNibName:@"OrderListFootTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListFootTwoCell"];

    //已完成的tableView
    [self.finishTableView registerNib:[UINib nibWithNibName:@"OrderListOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListOneCell"];
    [self.finishTableView registerNib:[UINib nibWithNibName:@"OrderListTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListTwoCell"];
    [self.finishTableView registerNib:[UINib nibWithNibName:@"OrderListFootTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderListFootTwoCell"];
    
    //加载下拉刷新
    [self downPushRefresh];
    //上拉加载
    [self upPushLoad];
    
    //默认都是需要刷新的
    self.isHttpArr = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1", nil];
    //默认都是第一页
    self.currentPageArr = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",nil];
    
    //加载空白页1
    self.kongImageView1 = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView1.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction1:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView1.frame = self.allTableView.bounds;
    [self.allTableView addSubview:self.kongImageView1];

    //加载空白页2
    self.kongImageView2 = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView2.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction2:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView2.frame = self.waitPayTableView.bounds;
    [self.waitPayTableView addSubview:self.kongImageView2];

    //加载空白页3
    self.kongImageView3 = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView3.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction3:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView3.frame = self.goOnTableView.bounds;
    [self.goOnTableView addSubview:self.kongImageView3];

    //加载空白页4
    self.kongImageView4 = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView4.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction4:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView4.frame = self.finishTableView.bounds;
    [self.finishTableView addSubview:self.kongImageView4];

}

- (void)reloadAgainButtonAction1:(IndexButton *)sender {
    if (sender.indexForButton.row == 1) {
        //重新请求数据
        [self.allTableView headerBeginRefreshing];
    }
    if (sender.indexForButton.row == 4) {
        //登录
        UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentViewController:loginNav animated:YES completion:nil];
    }

}
- (void)reloadAgainButtonAction2:(IndexButton *)sender {
    if (sender.indexForButton.row == 1) {
        //重新请求数据
        [self.waitPayTableView headerBeginRefreshing];
    }
    if (sender.indexForButton.row == 4) {
        //登录
        UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentViewController:loginNav animated:YES completion:nil];
    }

}
- (void)reloadAgainButtonAction3:(IndexButton *)sender {
    if (sender.indexForButton.row == 1) {
        //重新请求数据
        [self.goOnTableView headerBeginRefreshing];
    }
    if (sender.indexForButton.row == 4) {
        //登录
        UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentViewController:loginNav animated:YES completion:nil];
    }

}
- (void)reloadAgainButtonAction4:(IndexButton *)sender {
    if (sender.indexForButton.row == 1) {
        //重新请求数据
        [self.finishTableView headerBeginRefreshing];
    }
    if (sender.indexForButton.row == 4) {
        //登录
        UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentViewController:loginNav animated:YES completion:nil];
    }

}



//请求订单数据
- (void)httpOrderListWithProduct:(NSString *)product withCode:(NSString *)code withPageIndex:(NSInteger )pageIndex withTableView:(UITableView *)tempTableView  {

    Manager *manager = [Manager shareInstance];
    
    if ([manager isLoggedInStatus] == YES) {
    
        [manager getOrderListDataWithUserID:manager.memberInfoModel.u_id withProduct:product withCode:code withWhichTableView:self.whichTableView withPageIndex:pageIndex withPageSize:10 withOrderListSuccessResult:^(id successResult) {
            
            if (pageIndex == 1) {
                //刷新
                //请求后，标记已经刷新过了
                self.isHttpArr[[self.whichTableView integerValue]-1] = @"0";
                //刷新了，就要重置currentPage
                self.currentPageArr[[self.whichTableView integerValue]-1] = @"1";
                [tempTableView headerEndRefreshing];//取消头部刷新效果
                
                //看看是否有空白页
                [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"订单数据为空"];
            }else {
                //加载
                [tempTableView footerEndRefreshing];//取消尾部加载效果
                //加载要刷新currentPage
                self.currentPageArr[[self.whichTableView integerValue]-1] = [NSString stringWithFormat:@"%ld",pageIndex];
                
            }
            
            [tempTableView reloadData];

        } withOrderListFailResult:^(NSString *failResultStr) {
            NSLog(@"%@", failResultStr);
            //看看是否有空白页
            [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];
        }];
    }else {
        [tempTableView headerEndRefreshing];//取消头部刷新效果

        [self isShowKongImageViewWithType:KongTypeWithNotLogin withKongMsg:@"请您先登录哦"];
    }
    
}

#pragma mark - 四大按钮 -
//全部
- (IBAction)allButtonAction:(LineButton *)sender {
    self.whichTableView = @"1";
    //刷新UI
    [self changeLineButtonWithButton:sender];
    
    //没有合并付款
    self.payTogetherHeightLayout.constant = 0;
    self.backScrollView.contentOffset = CGPointMake(0, 0);
    
    Manager *manager = [Manager shareInstance];
    //需要刷新，才请求数据。默认请求全部数据
    if ([self.isHttpArr[0] isEqualToString:@"1"]) {
        
        [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:1 withTableView:self.allTableView];
    }
}
//待付款
- (IBAction)waitPayButtonAction:(LineButton *)sender {
    self.whichTableView = @"2";
    //刷新UI
    [self changeLineButtonWithButton:sender];
    
    //没有合并付款
    self.payTogetherHeightLayout.constant = 61;
    self.backScrollView.contentOffset = CGPointMake(kScreenW, 0);

    Manager *manager = [Manager shareInstance];
    //需要刷新，才请求数据。默认请求全部数据
    if ( [self.isHttpArr[1] isEqualToString:@"1"]) {
        
        [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:1 withTableView:self.waitPayTableView];
    }


}
//进行中
- (IBAction)goOnButtonAction:(LineButton *)sender {
    self.whichTableView = @"3";
    //刷新UI
    [self changeLineButtonWithButton:sender];
    //没有合并付款
    self.payTogetherHeightLayout.constant = 0;
    self.backScrollView.contentOffset = CGPointMake(kScreenW*2, 0);
    
    //需要刷新，才请求数据。默认请求全部数据
    Manager *manager = [Manager shareInstance];
    if ([self.isHttpArr[2] isEqualToString:@"1"]) {

        [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:1 withTableView:self.goOnTableView];
    }


}

//已完成
- (IBAction)finishButtonAction:(LineButton *)sender {
    self.whichTableView = @"4";
    //刷新UI
    [self changeLineButtonWithButton:sender];
   
    
    //没有合并付款
    self.payTogetherHeightLayout.constant = 0;
    self.backScrollView.contentOffset = CGPointMake(kScreenW*3, 0);

    //登录了，并且需要刷新，才请求数据。默认请求全部数据
    Manager *manager = [Manager shareInstance];
    if ( [self.isHttpArr[3] isEqualToString:@"1"]) {

        [self httpOrderListWithProduct:@"" withCode:@"" withPageIndex:1 withTableView:self.finishTableView];
    }
    
}

- (void)changeLineButtonWithButton:(LineButton *)sender {
    //将所有的button变为默认状态
    for (UIView *tempLineButton in sender.superview.subviews) {
        if ([tempLineButton isKindOfClass:[LineButton class]]) {
            ((LineButton *)tempLineButton).lineColor = [UIColor whiteColor];
            [((LineButton *)tempLineButton) setTitleColor:k333333Color forState:UIControlStateNormal];
        }
    }
    
    //将选中的这button变为选中状态
    sender.lineColor = kMainColor;
    [sender setTitleColor:kMainColor forState:UIControlStateNormal];
}


#pragma mark - TableViewDetegate - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *dataArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:self.whichTableView] objectForKey:@"content"];
    
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 11;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 43 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 168;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    NSMutableArray *dataArr;
    if (tableView == self.allTableView) {
        dataArr = [[manager.orderListDataSourceDic objectForKey:@"1"] objectForKey:@"content"];
    }
    if (tableView == self.waitPayTableView) {
        dataArr = [[manager.orderListDataSourceDic objectForKey:@"2"] objectForKey:@"content"];
    }
    if (tableView == self.goOnTableView) {
        dataArr = [[manager.orderListDataSourceDic objectForKey:@"3"] objectForKey:@"content"];
    }
    if (tableView == self.finishTableView) {
        dataArr = [[manager.orderListDataSourceDic objectForKey:@"4"] objectForKey:@"content"];
    }
   

    SupOrderModel *supOrderModel = dataArr[section];
    
    //待付款，（这里不包含1A--待确认）
    if ([supOrderModel.p_status isEqualToString:@"0"] || [supOrderModel.p_status isEqualToString:@"1B"] ) {
        OrderListFootOneTableViewCell *footOneCell = [tableView dequeueReusableCellWithIdentifier:@"orderListFootOneCell"];
        footOneCell.orderPayButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
        footOneCell.enterPayButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
        footOneCell.orderCancelButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
        
        //三个按钮Action的Block
        footOneCell.footOneButtonBlock = ^(NSIndexPath * buttonIndex ,NSString *buttonActionStr){
            //得到点击的模型
            NSArray *modelArr = [[manager.orderListDataSourceDic objectForKey:self.whichTableView] objectForKey:@"content"];

            SupOrderModel *selectModel = modelArr[buttonIndex.section];
            
            //buttonActionStr有三种情况。1-orderPay  2-enterPay  3-cancelOrder
            //去支付
            if ([buttonActionStr isEqualToString:@"orderPay"]) {
                
                [self performSegueWithIdentifier:@"orderListToPayVC" sender:@[selectModel]];
            }
            if ([buttonActionStr isEqualToString:@"enterPay"]) {
                
            }
            //取消订单
            if ([buttonActionStr isEqualToString:@"cancelOrder"]) {
                SupOrderModel *selectModel = modelArr[buttonIndex.section];
                [manager cancelSupOrderWithUserID:manager.memberInfoModel.u_id wiOrderID:selectModel.p_id withCancelSuccessResult:^(id successResult) {
                    AlertManager *alertM = [AlertManager shareIntance];
                    [alertM showAlertViewWithTitle:nil withMessage:@"取消订单成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
                        //取消订单后，刷新 当前TableView。其他的在切换的时候刷新

                        [tableView reloadData];
                        //设为1，切换TableView就会执行刷新
                        self.isHttpArr = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1", nil];
                    }];
                   
                    
                } withCancelFailResult:^(NSString *failResultStr) {
                    
                }];
                
            }
            
        };
        return footOneCell;
    }else {
        
        OrderListFootTwoTableViewCell *footTwoCell = [tableView dequeueReusableCellWithIdentifier:@"orderListFootTwoCell"];
        footTwoCell.orderDetailInfoButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
        //查看详情按钮
        footTwoCell.footTwoButtonBlock = ^(NSIndexPath * buttonIndex){
            NSArray *modelArr = [[manager.orderListDataSourceDic objectForKey:self.whichTableView] objectForKey:@"content"];
            
            SupOrderModel *selectModel = modelArr[buttonIndex.section];
            [self performSegueWithIdentifier:@"OrderListToOrderDetailVC" sender:selectModel];

            
        };
        return footTwoCell;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *dataArr;
    if (tableView == self.allTableView) {
        dataArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"1"] objectForKey:@"content"];
    }
    if (tableView == self.waitPayTableView) {
        dataArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"2"] objectForKey:@"content"];
    }
    if (tableView == self.goOnTableView) {
        dataArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"3"] objectForKey:@"content"];
    }
    if (tableView == self.finishTableView) {
        dataArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"4"] objectForKey:@"content"];
    }
    
    SupOrderModel *supOrderModel = dataArr[indexPath.section];
    
    if (supOrderModel.subOrderArr.count < 2) {
        OrderListOneTableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"orderListOneCell" forIndexPath:indexPath];
        [oneCell updateOrderLIstOneCellWithModel:supOrderModel withWhichTableView:self.whichTableView withCellIndex:indexPath];
        //选择按钮
        oneCell.selectButtonBlock = ^(IndexButton *selectButton){
            //只有第二个TableView，才有选择按钮
            //得到对应的模型
            NSArray *selectOrderArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"2"] objectForKey:@"content"];

            SupOrderModel *selectModel = selectOrderArr[selectButton.indexForButton.section];
            selectModel.isSelectOrder = !selectModel.isSelectOrder;
            //改变UI
            if (selectModel.isSelectOrder == YES) {
                [selectButton setImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];

            }else {
                [selectButton setImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];

            }
            
            
        };
        
        return oneCell;
    }else {
        OrderListTwoTableViewCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"orderListTwoCell" forIndexPath:indexPath];
        [twoCell updateOrderLIstOneCellWithModel:supOrderModel withWhichTableView:self.whichTableView withCellIndex:indexPath];
        //点击选择产品按钮
        twoCell.selectButtonBlock = ^(IndexButton *selectButton){
            //只有第二个TableView，才有选择按钮
            //得到对应的模型
            NSArray *selectOrderArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"2"] objectForKey:@"content"];
            
            SupOrderModel *selectModel = selectOrderArr[selectButton.indexForButton.section];
            selectModel.isSelectOrder = !selectModel.isSelectOrder;
            //改变UI
            if (selectModel.isSelectOrder == YES) {
                selectButton.backgroundColor = [UIColor redColor];
            }else {
                selectButton.backgroundColor = [UIColor lightGrayColor];
            }

        };
        return twoCell;
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //当手指离开某行时，就让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSMutableArray *dataArr;
    if (tableView == self.allTableView) {
        dataArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"1"] objectForKey:@"content"];
    }
    if (tableView == self.waitPayTableView) {
        dataArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"2"] objectForKey:@"content"];
    }
    if (tableView == self.goOnTableView) {
        dataArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"3"] objectForKey:@"content"];
    }
    if (tableView == self.finishTableView) {
        dataArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"4"] objectForKey:@"content"];
    }
    
    SupOrderModel *supOrderModel = dataArr[indexPath.section];
    
    [self performSegueWithIdentifier:@"OrderListToOrderDetailVC" sender:supOrderModel];
    
}

#pragma mark - 合并付款 和 合并确认 -
- (IBAction)payTogetherAction:(UIButton *)sender {
    //
    NSMutableArray *selectOrderArr = [NSMutableArray array];
    
    //查看那些订单被选择了
    NSArray *allWaitOrderArr = [[[Manager shareInstance].orderListDataSourceDic objectForKey:@"2"] objectForKey:@"content"];
    for (SupOrderModel *tempOrderModel in allWaitOrderArr) {
        if (tempOrderModel.isSelectOrder == YES) {
            [selectOrderArr addObject:tempOrderModel];
        }
    }
    
    if (selectOrderArr.count > 0) {
        //跳转到支付界面
        [self performSegueWithIdentifier:@"orderListToPayVC" sender:selectOrderArr];
    }else {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"您还没有选择任何订单" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
    }
    
}

- (IBAction)enterTogetherAction:(UIButton *)sender {
    //查看那些订单被选择了
    
}


#pragma mark - 空白页 -
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];
    NSMutableArray *tempArr = [[manager.orderListDataSourceDic objectForKey:self.whichTableView] objectForKey:@"content"];
    if (tempArr.count > 0) {
        switch ([self.whichTableView integerValue]) {
            case 1:
                [self.kongImageView1 hiddenKongView];

                break;
            case 2:
                [self.kongImageView2 hiddenKongView];

                break;
            case 3:
                [self.kongImageView3 hiddenKongView];

                break;
            case 4:
                [self.kongImageView4 hiddenKongView];

                break;
            default:
                break;
        }

    }else {
        switch ([self.whichTableView integerValue]) {
            case 1:
                [self.kongImageView1 showKongViewWithKongMsg:msg withKongType:kongType];
                
                break;
            case 2:
                [self.kongImageView2 showKongViewWithKongMsg:msg withKongType:kongType];
                
                break;
            case 3:
                [self.kongImageView3 showKongViewWithKongMsg:msg withKongType:kongType];
                
                break;
            case 4:
                [self.kongImageView4 showKongViewWithKongMsg:msg withKongType:kongType];
                
                break;
            default:
                break;
        }

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
    
    if ([segue.identifier isEqualToString:@"orderListToPayVC"]) {
        NSMutableArray *payVCIdArr = [NSMutableArray array];
        float payVCTotalAmount = 0;
        for (SupOrderModel *tempOrderModel in (NSArray *)sender) {
            [payVCIdArr addObject: tempOrderModel.p_id ];
            payVCTotalAmount += [tempOrderModel.p_o_price_total floatValue];
            payVCTotalAmount -= [tempOrderModel.p_discount floatValue];
        }
        PayViewController *payVC = [segue destinationViewController];
        payVC.orderIDArr = payVCIdArr;
        payVC.totalAmountFloat = payVCTotalAmount;
    }
    
    if ([segue.identifier isEqualToString:@"OrderListToOrderDetailVC"]) {
        OrderDetailViewController *orderDetailVC = [segue destinationViewController];
        orderDetailVC.tempSupOrderModel = (SupOrderModel *)sender;
        orderDetailVC.refreshOrderListBlock = ^(){
            
            //设为1，切换TableView就会执行刷新
            self.isHttpArr = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1", nil];
            
        };
        
    }
    
}


@end
