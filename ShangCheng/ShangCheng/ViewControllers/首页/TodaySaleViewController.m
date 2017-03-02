//
//  TodaySaleViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TodaySaleViewController.h"
#import "TodaySaleTableViewCell.h"
#import "Manager.h"
#import "MJRefresh.h"
@interface TodaySaleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *todaySaleTableView;
@property (nonatomic,strong)NSMutableArray *todaySaleDataSourceArr;
@end

@implementation TodaySaleViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self downPushRefresh];
    [self.todaySaleTableView headerBeginRefreshing];
    
    
}


//刷新
- (void)downPushRefresh {
    Manager *manager = [Manager shareInstance];

    [self.todaySaleTableView addHeaderWithCallback:^{
        
        [manager todayActivityWithTodaySuccess:^(id successResult) {
            //消失刷新效果
            [self.todaySaleTableView headerEndRefreshing];
            self.todaySaleDataSourceArr = [NSMutableArray arrayWithArray:successResult];
            [self.todaySaleTableView reloadData];
            
        } withTodayFail:^(NSString *failResultStr) {
            
        }];
        
    }];
}

#pragma mark - tableView delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.todaySaleDataSourceArr.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodaySaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todaySaleCell" forIndexPath:indexPath];
    TodaySaleModel *tempModel = self.todaySaleDataSourceArr[indexPath.section];
    [cell updateTodaySaleCellWithModel:tempModel];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"todaySaleVCToTodaySaleListVC" sender:nil];
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
