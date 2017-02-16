//
//  SelectCouponViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/11.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "SelectCouponViewController.h"
#import "CouponTableViewCell.h"
#import "Manager.h"
@interface SelectCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *couponDataSourceArr;
//TableView
@property (weak, nonatomic) IBOutlet UITableView *couponTableView;

@end

@implementation SelectCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册cell
    [self.couponTableView registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"couponCell"];
    
    
    
    //数据请求优惠券
    Manager *manager = [Manager shareInstance];
    [manager httpCouponListWithUserID:manager.memberInfoModel.u_id withCouponSuccessResult:^(id successResult) {
        
        self.couponDataSourceArr = successResult;
        //刷新数据
        [self.couponTableView reloadData];
        
    } withCouponFailResult:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
        
    }];
    
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.couponDataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponCell" forIndexPath:indexPath];
    CouponModel *tempModel = self.couponDataSourceArr[indexPath.row];

    [cell updateCouponCellWith:tempModel];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelectCoupon == YES) {
        Manager *manager = [Manager shareInstance];
        //得到点击的这个购物券
        CouponModel *tempModel = self.couponDataSourceArr[indexPath.row];
        
        //创建购物车id数组
        NSMutableArray *shoppingCarIdArr = [NSMutableArray array];
        for (ShoppingCarModel *tempCarModel in self.previewOrderProductArr) {
            [shoppingCarIdArr addObject:tempCarModel.c_id];
        }
        //网络请求计算优惠券金额
        [manager httpComputeCouponMoneyWithUserID:manager.memberInfoModel.u_id withCouponID:tempModel.c_id withShoppingCarIDArr:shoppingCarIdArr withComputeMoneySuccessResult:^(id successResult) {
            //去掉“”引号
            //        successResult = [(NSString *)successResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            //返回到预订单界面
            self.couponDicBlock(@{@"couponId":tempModel.c_id,@"saleCode":tempModel.c_code,@"saleMoney":successResult});
            //
            [self.navigationController popViewControllerAnimated:YES];
            
            
        } withComputeMoneyFailResult:^(NSString *failResultStr) {
            //
            
        }];

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
