//
//  ShoppingCarViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/19.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShoppingCarTableViewCell.h"
#import "PreviewOrderViewController.h"
#import "ProductDetailViewController.h"
#import "Manager.h"
@interface ShoppingCarViewController ()<UITableViewDataSource,UITableViewDelegate>
//判断是否需要刷新
@property (nonatomic,assign)BOOL isRefreshVC;
@property (weak, nonatomic) IBOutlet UITableView *shoppingTableView;

//是否正在编辑
@property (nonatomic,assign)NSInteger isEditing;
//不在编辑
@property (weak, nonatomic) IBOutlet UIView *notEditingView;
//正在编辑
@property (weak, nonatomic) IBOutlet UIView *editingView;
//全选按钮
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
//金额label
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//共多少件Label
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

@end

@implementation ShoppingCarViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，需要刷新
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshShoppingCarNotification:) name:@"refreshShoppingCarVC" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshShoppingCarNotification:) name:@"logedIn" object:nil];


        
    }
    return self;
}

- (void)refreshShoppingCarNotification:(NSNotification *)sender {
    self.isRefreshVC = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isRefreshVC == YES) {
        //需要刷新
        [self httpShoppingCarVCDataAction];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //看看是否登录了，如果登录才能请求数据
    Manager *manager = [Manager shareInstance];
    
    //判断状态，现在是否登陆了，
    if ([manager isLoggedInStatus] == YES) {
        //已经登录
        [self httpShoppingCarVCDataAction];

    }else {
        //未登录，跳转到登录界面
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"您还没有登录，请登录" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            
            UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
            [self presentViewController:loginNav animated:YES completion:nil];

        }];
      
    }

    
}
//请求数据的操作
- (void)httpShoppingCarVCDataAction {
    Manager *manager = [Manager shareInstance];
    
    [manager httpShoppingCarDataWithUserId:manager.memberInfoModel.u_id WithSuccessResult:^(id successResult) {
        
        [self.shoppingTableView reloadData];
        //刷新了，将bool值变为No
        self.isRefreshVC = NO;
        //刷新一下全选按钮
        if (manager.isAllSelectForShoppingCar == YES) {
            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
            
        }else{
            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
        }

        //计算金额
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
        //计算总件数
        self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
        
        
    } withFailResult:^(NSString *failResultStr) {
        NSLog(@"请求失败");
    }];

}

#pragma mark - TableView delegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [Manager shareInstance].shoppingCarDataSourceArr.count;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//分区尾部，用于显示问题产品
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    ShoppingCarModel *shoppingModel = manager.shoppingCarDataSourceArr[section];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    footView.backgroundColor = [UIColor redColor];

    UILabel *errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    [footView addSubview:errorLabel];
    
    
    if (![shoppingModel.productErrorMsg isEqualToString:@""]) {
        //有问题的产品
        footView.hidden = NO;
        errorLabel.text = shoppingModel.productErrorMsg;

    }else{
        //没有问题
        footView.hidden = YES;
    }
    return footView;

}

//分区尾，有问题的显示分区尾
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    ShoppingCarModel *shoppingModel = manager.shoppingCarDataSourceArr[section];
    if (![shoppingModel.productErrorMsg isEqualToString:@""]) {
        //有问题的产品
        return 20;
        
    }else {
        //没有问题不用显示尾部
        return 1;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoppingCarCell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Manager *manager = [Manager shareInstance];
    
    //删除block
    cell.deleteSuccessBlock = ^(NSIndexPath *deletePath) {
        NSLog(@"%ld--%ld",deletePath.section,deletePath.row);
        //删除TableView的ui
        NSIndexSet *deleteIndexSet = [NSIndexSet indexSetWithIndex:deletePath.section];
        [tableView deleteSections:deleteIndexSet withRowAnimation:UITableViewRowAnimationNone];
        
        //刷新一下全选按钮
        if (manager.isAllSelectForShoppingCar == YES) {
            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];

        }else{
            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
        }
        //计算金额
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
        //计算总件数
        self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];

    };
    
    //刷新全选按钮block
    cell.totalPriceBlock = ^{
        if (manager.isAllSelectForShoppingCar == YES) {
            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
        }else{
            [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
        }
        //计算金额
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
        //计算总件数
        self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
    };
    
    //刷新UI
    [cell updateCellWithCellIndex:indexPath];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%ld",indexPath.row);
    
    //当手指离开某行时，就让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShoppingCarModel *tempShoppingCarModel = [[[Manager shareInstance] shoppingCarDataSourceArr] objectAtIndex:indexPath.section];

    ProductModel *tempProductModel = tempShoppingCarModel.shoppingCarProduct;
    //跳转到详情页
    [self performSegueWithIdentifier:@"shoppingCarToDetailVC" sender:tempProductModel];
    

}

#pragma mark - 导航栏上的功能 -
//导航栏右边编辑按钮
- (IBAction)editBarButtonAction:(UIBarButtonItem *)sender {
    
    self.isEditing = !self.isEditing;
    
    if (self.isEditing == YES) {
        //正在编辑状态
        sender.title = @"完成";
        self.editingView.hidden = YES;
        self.notEditingView.hidden = NO;
        
        
    }else {
        //不在编辑状态
        sender.title = @"编辑";
        self.editingView.hidden = NO;
        self.notEditingView.hidden = YES;
        
    }
}

#pragma mark - 底部功能 -
//全选
- (IBAction)allSelectButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    //如果现在是全选状态，那么就全不选
    if (manager.isAllSelectForShoppingCar == YES) {
        
        for (ShoppingCarModel *tempModel in manager.shoppingCarDataSourceArr) {
            tempModel.isSelectedShoppingCar = NO;
            
        }
        
    }else {
        for (ShoppingCarModel *tempModel in manager.shoppingCarDataSourceArr) {
            tempModel.isSelectedShoppingCar = YES;
            
        }
    }
    //刷新UI
    [self.shoppingTableView reloadData];
    
    //判断一下是否全选
    [manager isAllSelectForShoppingCarAction];
    //需要刷新全选按钮
    if (manager.isAllSelectForShoppingCar == YES) {
        [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
    }else {
        [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
    }
    //计算总价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
    //计算总件数
    self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
}


//编辑状态的删除按钮
- (IBAction)editDeleteButtonAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];

    //查看是否选择了产品
    if ([manager isSelectAnyOneProduct] == YES) {
        //设置set为了删除数据源
        NSMutableIndexSet *deleteIndexSet = [NSMutableIndexSet indexSet];
        //从所有产品中，得到选中的产品的下标，即i的值
        for (int i = 0; i < manager.shoppingCarDataSourceArr.count; i++) {
            if ([manager.shoppingCarDataSourceArr[i] isSelectedShoppingCar] == YES) {
                //如果选中了这个产品，那么就将下标加入
                [deleteIndexSet addIndex:i];
                
            }
        }
        //删除
        [[Manager shareInstance] deleteShoppingCarWithProductIndexSet:deleteIndexSet WithSuccessResult:^(id successResult) {
            [self.shoppingTableView deleteSections:deleteIndexSet withRowAnimation:UITableViewRowAnimationNone];
            
            //需要刷新全选按钮
            if (manager.isAllSelectForShoppingCar == YES) {
                [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];
            }else {
                [self.allSelectButton setBackgroundImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];
            }
            //计算总金额
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
            //计算总件数
            self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",[manager isSelectProductCount]];
            
        } withFailResult:^(NSString *failResultStr) {
            //删除失败
        }];

    }else {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"您还没有选择产品" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
    }
    
    
}

//立即支付按钮
- (IBAction)payButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    //有选择产品才可以支付
    if ([manager isSelectAnyOneProduct] == YES) {
        //将选择的产品下标记录一下，主要用户刷新UI
        NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
        //将选择的产品id记录一下，传给接口
        NSMutableArray *shoppingCarIdArr = [NSMutableArray array];
        for (int i = 0; i < manager.shoppingCarDataSourceArr.count; i++) {
            ShoppingCarModel *shoppingCarModel = manager.shoppingCarDataSourceArr[i];
            //清空所有的问题产品信息
            shoppingCarModel.productErrorMsg = @"";
            
            if (shoppingCarModel.isSelectedShoppingCar == YES) {
                //如果选中了这个产品，那么产品下标家属indexSet中,产品id加入数组，
                [selectIndexSet addIndex:i];
                [shoppingCarIdArr addObject:shoppingCarModel.c_id];
            }
        }
        
        //调用订单预支付接口，看看哪些产品不能生成订单
        [manager httpOrderPreviewWithShoppingCarIDArr:shoppingCarIdArr withPreviewSuccessResult:^(id successResult) {
            
            if ([[successResult objectForKey:@"code"] integerValue] == 200) {
                //全部产品成功,即可生成订单了，跳转到下一页，在跳转下一页的时候，先清空一下上次有错误的产品UI
                [self.shoppingTableView reloadData];
                //跳转
                [self performSegueWithIdentifier:@"toPreviewOrderVC" sender:sender];
                
                
            }else if ([[successResult objectForKey:@"code"] integerValue] == 400) {
                //有些产品不成功
                NSArray *contentArr = [successResult objectForKey:@"content"];
                for (NSDictionary *contentDic in contentArr) {
                    //遍历返回的不成功的产品,在购物车数组中，做标记
                    for (ShoppingCarModel *tempShoppingCarModel in manager.shoppingCarDataSourceArr) {
                        if ([tempShoppingCarModel.c_id isEqualToString:[contentDic objectForKey:@"cartid"]]) {
                            //找到问题产品。做标记
                            tempShoppingCarModel.productErrorMsg = [contentDic objectForKey:@"message"];
                            
                        }
                    }
                }
                //刷新UI,展示问题产品
                [self.shoppingTableView reloadSections:selectIndexSet withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        } withPreviewFailResult:^(NSString *failResultStr) {
            
        }];
        
    }else {
        AlertManager *alert = [AlertManager shareIntance];
        [alert showAlertViewWithTitle:nil withMessage:@"您还没有选择产品" actionTitleArr:nil withViewController:self withReturnCodeBlock:nil];
    }
    
    
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Manager *manager = [Manager shareInstance];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toPreviewOrderVC"]) {
        NSMutableArray *selectArr = [NSMutableArray array];
        //找到选择的产品数据
        for (ShoppingCarModel *tempModel in manager.shoppingCarDataSourceArr) {
            if (tempModel.isSelectedShoppingCar == YES) {
                //选择了这个产品，加入数组中
                [selectArr addObject:tempModel];
            }
        }
        
        PreviewOrderViewController *previewOrderVC = [segue destinationViewController];
        previewOrderVC.selectedProductArr = selectArr;

    }
    
    //点击cell跳转到详情
    if ([segue.identifier isEqualToString:@"shoppingCarToDetailVC"]) {
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productID = ((ProductModel *)sender).productID;
        
    }
    
}


@end
