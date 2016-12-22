//
//  DownLinePayViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/18.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DownLinePayViewController.h"
#import "DownLineTableViewCell.h"
@interface DownLinePayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *bankArr;
//选择余额按钮button
@property (weak, nonatomic) IBOutlet UIButton *selectBalanceButton;
@property (nonatomic,assign)BOOL isSelectBalance;//是否选择使用余额
@property (nonatomic,assign) float useBalanceFloat;//使用了多少余额
//账户余额Label
@property (weak, nonatomic) IBOutlet UILabel *memberBalanceLabel;
//总额Label
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
//实际支付金额
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;


@end

@implementation DownLinePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.memberBalanceFloat = 144.00;
    // Do any additional setup after loading the view.
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"bankJson" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    //解析得到返回结果
     NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    self.bankArr = [NSMutableArray arrayWithArray:jsonArr];
    
    //账户余额
    self.memberBalanceLabel.text = [NSString stringWithFormat:@"账户余额：%.2f",self.memberBalanceFloat];
    
    //有余额按钮才可以点击,
    if (self.memberBalanceFloat > 0.00) {
        self.selectBalanceButton.enabled = YES;
        self.isSelectBalance = YES;
        
    }else {
        //没有余额，不可点击
        self.selectBalanceButton.enabled = NO;
        self.isSelectBalance = NO;
    }
    //通过余额更新一些信息
    [self updateDataAndUIWithUseBalanceYesOrNo:self.isSelectBalance];
    
    //订单总额
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%.2f", self.orderTotalAmountFloat];
}

//通过是否选择余额更新一些信息
- (void)updateDataAndUIWithUseBalanceYesOrNo:(BOOL)yesOrNo {
    if (yesOrNo == YES) {
        //如果是选择了余额
        //改变button的样式
        self.selectBalanceButton.backgroundColor = [UIColor redColor];
        //余额不足， 使用余额 = 余额全部.
        //余额充足， 使用余额 = 订单总价格
        if (self.memberBalanceFloat > self.orderTotalAmountFloat) {
            self.useBalanceFloat = self.orderTotalAmountFloat;

        }else {
            self.useBalanceFloat = self.memberBalanceFloat;

        }
        
    }else {
        //改变button的样式
        self.selectBalanceButton.backgroundColor = [UIColor lightGrayColor];
        //不选择余额，那么余额为0
        self.useBalanceFloat = 0.00;
    }
    //实际转款 = 总额 - 使用余额
    self.payAmountLabel.text = [NSString stringWithFormat:@"%.2f",self.orderTotalAmountFloat - self.useBalanceFloat];
    
}

//选择余额按钮
- (IBAction)selectBalanceButtonAction:(UIButton *)sender {
    //反转状态
    self.isSelectBalance = !self.isSelectBalance;
    //更新
    [self updateDataAndUIWithUseBalanceYesOrNo:self.isSelectBalance];
}


#pragma mark - tableView delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankCellIndentifier" forIndexPath:indexPath];
    //点击cell没有灰色阴影效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateBankUIWithBankDic:self.bankArr[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (NSMutableDictionary *tempDic in self.bankArr) {
        [tempDic setObject:@"NO" forKey:@"isSelect"];
    }
    
    NSMutableDictionary *selectDic = self.bankArr[indexPath.row];
    [selectDic setObject:@"YES" forKey:@"isSelect"];
    
    [tableView reloadData];
}

#pragma mark - 底部的两个按钮 -
//发送卡号到手机
- (IBAction)sendCardNumberToPhoneButtonAction:(UIButton *)sender {
    
    for (NSMutableDictionary *tempDic in self.bankArr) {

        if ([[tempDic objectForKey:@"isSelect"] isEqualToString:@"YES"]) {
            //如果选择了.发送卡号到手机
            NSLog(@"%@---%@",[tempDic objectForKey:@"bankNumber"],[tempDic objectForKey:@"bankName"]);
            
            return ;
            
        }
    }
    

    
}


//我已经线下转款按钮
- (IBAction)downLinePayButtonAction:(UIButton *)sender {
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
