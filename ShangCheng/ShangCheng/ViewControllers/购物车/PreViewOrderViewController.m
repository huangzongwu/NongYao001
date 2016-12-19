//
//  PreviewOrderViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/9.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "PreviewOrderViewController.h"
#import "PreviewOrderTableViewCell.h"
#import "SelectCouponViewController.h"
#import "PayViewController.h"
#import "Manager.h"
#import "AlertManager.h"
@interface PreviewOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
//couponId:优惠卷id  saleCode:优惠码  saleMoney:优惠金额
@property (nonatomic,strong)NSDictionary *saleMoneyDic;
//记录下单时间
@property (nonatomic,strong) NSTimer *tempTimer;


//------------------footView上的控件
//优惠券
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
//产品价格
@property (weak, nonatomic) IBOutlet UILabel *productTotalPriceLabel;
//优惠金额
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
//数量
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
//需付款
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
//-----------底部控件----------------------
//底部的实付款Label
@property (weak, nonatomic) IBOutlet UILabel *bottomPayMoneyLabel;

@property (nonatomic,strong)NSString *creatOrderId;


@end

@implementation PreviewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Manager *manager = [Manager shareInstance];
    //默认是没有选择优惠券
    self.saleMoneyDic = @{@"couponId":@"",@"saleCode":@"",@"saleMoney":@"0"};
    
    //更新一下footView
    [self upFootview];
   //底部实付款
    self.bottomPayMoneyLabel.text = [NSString stringWithFormat:@"实付款：￥%.2f", [self computeProductTotalPrice] - [[self.saleMoneyDic objectForKey:@"saleMoney"] integerValue]];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //开始展示下单时间
    self.tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
- (void)timerAction:(NSTimer *)timer {
    NSLog(@"aaaa");
    Manager *manager = [Manager shareInstance];
    self.payTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",[manager getNowTimeStr]];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    //界面消失，下单时间停止
    [self.tempTimer invalidate];
}
//总金额
- (float)computeProductTotalPrice {
    float totalPrice = 0;
    for (ShoppingCarModel *tempModel in self.selectedProductArr) {
        // 一个产品的总价格 = 单价*数量
        totalPrice += [tempModel.totalprice floatValue];
    }
    return totalPrice;

}

//刷新FootView
- (void)upFootview {
    Manager *manager = [Manager shareInstance];
    
    //优惠券
    if ([[self.saleMoneyDic objectForKey:@"saleCode"] isEqualToString:@""]) {
        self.couponLabel.text = @"未选择";

    }else {
        self.couponLabel.text = [self.saleMoneyDic objectForKey:@"saleCode"];

    }

    
    //总金额
    self.productTotalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self computeProductTotalPrice]];
    
    //优惠金额
    self.salePriceLabel.text = [NSString stringWithFormat:@"-￥%.2f",  [[self.saleMoneyDic objectForKey:@"saleMoney"] floatValue]];
    
    
    //产品的总个数
    int totalCount = 0;
    for (ShoppingCarModel *tempModel in self.selectedProductArr) {
        totalCount += [tempModel.c_number integerValue];
    }
    self.productCountLabel.text = [NSString stringWithFormat:@"%d件",totalCount];
    
    
    //需付款
    self.payMoneyLabel.text = [NSString stringWithFormat:@"%.2f", [self computeProductTotalPrice] - [[self.saleMoneyDic objectForKey:@"saleMoney"] integerValue]];
    //时间
    self.payTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",[manager getNowTimeStr]];
   
    
}

#pragma mark - tableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedProductArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PreviewOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"previewOrderTCell" forIndexPath:indexPath];
    ShoppingCarModel *tempShoppingModel = self.selectedProductArr[indexPath.row];
    
    [cell updatePreviewOrderCellWithShoppingCarModel:tempShoppingModel];
    
    return cell;
    
}



#pragma mark - 头部地址选择 -

#pragma mark - 联系客服 -


#pragma mark - 底部功能 -
//提交订单，即生成订单
- (IBAction)submitOrderButtonAction:(UIButton *)sender {
#warning 地区假数据
    Manager *manager = [Manager shareInstance];
    [manager creatOrderWithUserID:manager.memberInfoModel.u_id withReceivedID:@"A90F69B863C7468883FAA64AA0CE0B9A" withTotalAmount:[NSString stringWithFormat:@"%f",[self computeProductTotalPrice]] withDiscount:[self.saleMoneyDic objectForKey:@"saleMoney"] withCouponId:[self.saleMoneyDic objectForKey:@"couponId"] withArr:self.selectedProductArr withOrderSuccessResult:^(id successResult) {
        
        self.creatOrderId = successResult;
        
        //提交订单后，就进入支付界面
        [self performSegueWithIdentifier:@"previewOrderVCToPayVC" sender:sender];
        
        
    } withOrderFailResult:^(NSString *failResultStr) {
        
    }];
    
     
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
    //选择优惠劵
    if ([segue.identifier isEqualToString:@"toSelectCouponVC"]) {
        //大于等于1000才能进入优惠券界面
        if ([self computeProductTotalPrice] >= 1000) {
            //将产品模型传值到选择优惠券界面
            SelectCouponViewController *selectCouponVC = [segue destinationViewController];
            selectCouponVC.previewOrderProductArr = self.selectedProductArr;
            selectCouponVC.couponDicBlock = ^(NSDictionary *couponDicBlock){
                //优惠金额赋值
                self.saleMoneyDic = couponDicBlock;
                //刷新footView 的ui
                [self upFootview];
                
                self.bottomPayMoneyLabel.text = [NSString stringWithFormat:@"实付款：￥%.2f", [self computeProductTotalPrice] - [[self.saleMoneyDic objectForKey:@"saleMoney"] integerValue]];
                
            };
            
        }else {
            //
            AlertManager *alertManager = [AlertManager shareIntance];
            [alertManager showAlertViewWithTitle:nil withMessage:@"优惠券不可用" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
        }

    }
    
    //提交订单，进入支付界面
    if ([segue.identifier isEqualToString:@"previewOrderVCToPayVC"]) {
        PayViewController *payVC = [segue destinationViewController];
        payVC.orderIDArr = @[self.creatOrderId];
        payVC.totalAmountFloat = [self computeProductTotalPrice] - [[self.saleMoneyDic objectForKey:@"saleMoney"] integerValue];
    }
}


@end
