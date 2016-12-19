//
//  PayViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/13.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "PayViewController.h"
#import "PayTableViewCell.h"
#import "Manager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface PayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *payTableView;
//订单金额
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
//选择账户余额的按钮
@property (weak, nonatomic) IBOutlet UIButton *selectMemberBalanceButton;
@property (nonatomic,assign)BOOL isSelectBalance;//是否选择了余额
@property (nonatomic,assign)float useBalanceFloat;//使用的余额数量
//账户余额Label
@property (weak, nonatomic) IBOutlet UILabel *memberBalanceLabel;
@property (nonatomic,assign)float memberBalanceFloat;//账户余额
//另需支付
@property (weak, nonatomic) IBOutlet UILabel *otherPayLabel;

//支付方式datasource
@property (nonatomic,strong)NSMutableArray *payKindDataSourceArr;
//选择了哪种支付方式  11-支付宝 12-微信 21-线下
@property (nonatomic,assign)NSInteger payKindInt;

//底部的两个Label
@property (weak, nonatomic) IBOutlet UILabel *bottomNeedPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomBalanceLabel;

@end

@implementation PayViewController

//默认的一些信息
- (void)defaultSomeData {
    //支付类型
    NSMutableDictionary *aliPayDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"payImg",@"支付宝支付",@"payTitle",@"0",@"isSelectPay", nil];
    NSMutableDictionary *weiXinPayDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"payImg",@"微信支付",@"payTitle",@"0",@"isSelectPay", nil];
    NSMutableDictionary *downLinePayDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"payImg",@"线下银行转账",@"payTitle",@"0",@"isSelectPay", nil];
    
    NSArray *uplinePayArr = @[ @[aliPayDic], @[weiXinPayDic] ];
    NSArray *downlinePayArr = @[ @[downLinePayDic] ];
    self.payKindDataSourceArr = [NSMutableArray arrayWithObjects:uplinePayArr,downlinePayArr, nil];

    
    //默认的余额为零，等请求了余额信息后，在重新赋值
    self.memberBalanceFloat = 0.00;
    //由于余额为零，就只能三方支付，不能选择余额了
    self.selectMemberBalanceButton.enabled = NO;//选择余额按钮禁止点击
    [self isSelectBalanceUIWithSelectYesOrNo:NO];//
    //刷新UI
    [self updateHeaderView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //一些默认信息
    [self defaultSomeData];
    
    
    //查询账户余额
    Manager *manager = [Manager shareInstance];
    [manager searchUserAmount:manager.memberInfoModel.u_id withAmountSuccessBlock:^(id successResult) {
//        self.memberBalanceFloat = 0.00;
        self.memberBalanceFloat = [[[successResult objectAtIndex:0] objectForKey:@"u_amount_avail"] floatValue];
        //将最新的余额存入模型中
        manager.memberInfoModel.u_amount = [[successResult objectAtIndex:0] objectForKey:@"u_amount"];
        manager.memberInfoModel.u_amount_avail = [[successResult objectAtIndex:0] objectForKey:@"u_amount_avail"];
        manager.memberInfoModel.u_amount_frozen = [[successResult objectAtIndex:0] objectForKey:@"u_amount_frozen"];

        //有了余额 重新更新一下信息/
        if (self.memberBalanceFloat > 0) {
            //开启余额选择按钮
            self.selectMemberBalanceButton.enabled = YES;
            //有余额就默认选择余额
            [self isSelectBalanceUIWithSelectYesOrNo:YES];
            //刷新UI
            [self updateHeaderView];
            
        }
        
    } withAmountFailBlock:^(NSString *failResultStr) {
        
    }];
    
}



//选择余额与否
- (void)isSelectBalanceUIWithSelectYesOrNo:(BOOL)yesOrNo {

    if (yesOrNo == YES) {
        //如果是YES。修改UI和判断
        self.isSelectBalance = YES;
        //如果余额不足，那么 使用余额=余额全部；如果余额充足，那么 使用余额=总价格
        //如果余额不足，另需支付=总价格-余额全部；如果余额充足，另需支付=0
        if (self.memberBalanceFloat < self.totalAmountFloat) {
            //余额不足
            self.useBalanceFloat = self.memberBalanceFloat;
            self.otherPayLabel.text = [NSString stringWithFormat:@"%.2f",self.totalAmountFloat-self.memberBalanceFloat];
        }else {
            //余额充足
            self.useBalanceFloat = self.totalAmountFloat;
            self.otherPayLabel.text = @"0.00";
        }
        
        self.selectMemberBalanceButton.backgroundColor = [UIColor redColor];
    }else {
        //否则。另需支付=总价格
        self.isSelectBalance = NO;
        self.useBalanceFloat = 0.00;
        self.selectMemberBalanceButton.backgroundColor = [UIColor lightGrayColor];
        self.otherPayLabel.text = [NSString stringWithFormat:@"%.2f",self.totalAmountFloat];
    }
    
    //底部还需支付。如果余额不足，还需支付和另需支付一样
    self.bottomNeedPayLabel.text = self.otherPayLabel.text;
    //底部的余额支付，就是使用余额
    self.bottomBalanceLabel.text = [NSString stringWithFormat:@"%.2f",self.useBalanceFloat ];

}




- (void)updateHeaderView {
    self.orderAmountLabel.text = [NSString stringWithFormat:@"%.2f",self.totalAmountFloat ];
    
    self.memberBalanceLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",self.memberBalanceFloat];
    
}

//选择余额按钮
- (IBAction)selectBalanceButtonAction:(UIButton *)sender {
    self.isSelectBalance = !self.isSelectBalance;
    [self isSelectBalanceUIWithSelectYesOrNo:self.isSelectBalance];
}

#pragma mark - TableViewDelegate - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.payKindDataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.payKindDataSourceArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PayTableViewCell *payCell = [tableView dequeueReusableCellWithIdentifier:@"payCellIdentifier" forIndexPath:indexPath];
    NSDictionary *jsonDic = [[self.payKindDataSourceArr[indexPath.section] objectAtIndex:indexPath.row] firstObject];
    [payCell updatePayCellWithJsonDic:jsonDic];
    
    
    return payCell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   //没有选择余额，或者余额不足，就需要三方支付
    if (self.isSelectBalance == NO || self.memberBalanceFloat < self.totalAmountFloat) {
        NSLog(@"需要三方支付");

        
        //如果是线下支付，就跳转
        if (indexPath.section == 1) {
            [self performSegueWithIdentifier:@"toDownLinePayVC" sender:nil];

        }
        
    }else{
        NSLog(@"不需要三方支付");
    }
    
    
//    if ([self.totalAmountStr floatValue] > [self.selectBalanceStr floatValue]) {
//        NSLog(@"需要三方支付");
//        
//        //先清空所有的状态
//        for (NSArray *tempPayKindArr in self.payKindDataSourceArr) {
//            
//            for (NSArray *tempDetailKindArr in tempPayKindArr) {
//                NSDictionary *tempJsonDic = [tempDetailKindArr firstObject];
//                [tempJsonDic setValue:@"0" forKey:@"isSelectPay"];
//            }
//        }
//        
//        //选择了某种支付方式
//        NSDictionary *jsonDic = [[self.payKindDataSourceArr[indexPath.section] objectAtIndex:indexPath.row] firstObject];
//        [jsonDic setValue:@"1" forKey:@"isSelectPay"];
//        
//        if (indexPath.section == 0) {
//            switch (indexPath.row) {
//                case 0:
//                    //支付宝
//                    self.payKindInt = 11;
//                    break;
//                case 1:
//                    //微信
//                    self.payKindInt = 12;
//                    break;
//                default:
//                    break;
//            }
//        }else {
//            //section == 1
//            //线下
//            self.payKindInt = 21;
//        }
//        
//        //刷新UI
//        [self.payTableView reloadData];
//
//        
//    }else {
//        NSLog(@"三方不需支付");
//    }
//
    
    
   
}


- (IBAction)enterPayButtonAction:(UIButton *)sender {
    /*
    if ([self.totalAmountStr floatValue] > [self.selectBalanceStr floatValue]) {
        //余额不足，需要第三方继续支付
        NSString *tempPayAmountStr = [NSString stringWithFormat:@"%.2f", [self.totalAmountStr floatValue] - [self.selectBalanceStr floatValue]];
        //进行支付验证
        Manager *manager = [Manager shareInstance];
        [manager paybeforeVerifyWithUserId:manager.memberInfoModel.u_id withTotalAmount:self.totalAmountStr withBalance:self.selectBalanceStr withPayAmount:tempPayAmountStr withOrderIdArr:self.orderIDArr withVerifySuccessBlock:^(id successResult) {
            
        } withVerfityFailBlock:^(NSString *failResultStr) {
            
        }];
        
        switch (self.payKindInt) {
            case 11:
                //支付宝支付
                
                break;
            case 12:
                //微信支付
                break;
            case 21:
                //线下支付
                break;
                
            default:
                //未选择支付方式
                break;
        }

        
    }else {
        //余额充足，直接支付
        
        
    }
    
    */
    
}

#pragma mark - 支付宝支付 -
- (void)aliPayAction {
    
    
    
    
    
    
    
    
    
    
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"";
    NSString *privateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
#warning 订单id
    order.biz_content.out_trade_no = @""; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"Nongyao001Alisdk";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
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
    
    if ([segue.identifier isEqualToString:@"toDownLinePayVC"]) {
        
    }
}




@end
