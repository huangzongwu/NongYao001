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
@property (nonatomic,strong)NSMutableArray *bankArr;
//账户余额Label
@property (weak, nonatomic) IBOutlet UILabel *memberBlanceLabel;
//总额Label
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
//实际支付金额
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;


@end

@implementation DownLinePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"bankJson" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    //解析得到返回结果
     NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    self.bankArr = [NSMutableArray arrayWithArray:jsonArr];
    
    
    
    
    
    
}

//选择余额按钮
- (IBAction)selectBalanceButtonAction:(UIButton *)sender {
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
