//
//  MyTradeRecordViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyTradeRecordViewController.h"
#import "TradeRecordTableViewCell.h"
#import "Manager.h"
@interface MyTradeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tradeRecordtableView;

@end

@implementation MyTradeRecordViewController

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    
     
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Manager *manager = [Manager shareInstance];
    
    [manager httpSearchUserAccountListWithUserId:manager.memberInfoModel.u_id withIsCash:self.isCashStr withSdt:@"" withEdt:@"" withPageIndex:1 withPageSize:10 withSearchSuccess:^(id successResult) {
        
        [self.tradeRecordtableView reloadData];
        
    } withSearchFail:^(NSString *failResultStr) {
        
    }];
    
}


#pragma mark - TableView Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    Manager *manager = [Manager shareInstance];
    if ([self.isCashStr isEqualToString:@"1"]) {
        //提现
        return manager.cashDateKeyArr.count;

    }else {
        return manager.tradeDateKeyArr.count;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    NSString *keyStr;
    if ([self.isCashStr isEqualToString:@"1"]) {
        //提现
        keyStr =  manager.cashDateKeyArr[section];
    }else {
        //交易
        keyStr =  manager.tradeDateKeyArr[section];
    }

    return keyStr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    if ([self.isCashStr isEqualToString:@"1"]) {
        NSString *keyStr1 = manager.cashDateKeyArr[section];
        NSMutableArray *valusArr1 = [manager.cashDetailDic objectForKey:keyStr1];
        return valusArr1.count;

    }else {
        NSString *keyStr2 =  manager.tradeDateKeyArr[section];
        NSMutableArray *valusArr2 = [manager.tradeDetailDic objectForKey:keyStr2];
        return valusArr2.count;

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TradeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tradeRecordCell" forIndexPath:indexPath];
    Manager *manager = [Manager shareInstance];
    
    if ([self.isCashStr isEqualToString:@"1"]) {
        //提现记录
        NSString *keyStr =  manager.cashDateKeyArr[indexPath.section];
        NSMutableArray *valusArr = [manager.cashDetailDic objectForKey:keyStr];
        MyTradeRecordModel *tempModel = valusArr[indexPath.row];
        
        [cell updateTradeRecordCellWithModel:tempModel];
        
        return cell;

        
    }else {
        NSString *keyStr =  manager.tradeDateKeyArr[indexPath.section];
        NSMutableArray *valusArr = [manager.tradeDetailDic objectForKey:keyStr];
        MyTradeRecordModel *tempModel = valusArr[indexPath.row];
        
        [cell updateTradeRecordCellWithModel:tempModel];
        
        return cell;

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
