//
//  MyCommentListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyCommentListViewController.h"
#import "MyCommentListTableViewCell.h"
#import "Manager.h"
@interface MyCommentListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myCommentListTabelView;

@end

@implementation MyCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 让cell自适应高度
    self.myCommentListTabelView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.myCommentListTabelView.estimatedRowHeight = 44;
    
    
    //网络请求评价
    Manager *manager = [Manager shareInstance];
    [manager myCommentListWithUserId:manager.memberInfoModel.u_id withIsUpdate:YES withPageIndex:1 withPageSize:10 withMyCommentSuccessBlock:^(id successResult) {
        
    } withMyCommentFailBlock:^(NSString *failResultStr) {
        
    }];
    
    
    
    
}


#pragma mark - TableView Delegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    Manager *manager = [Manager shareInstance];
    return manager.myCommentArr.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCommentListCell" forIndexPath:indexPath];
    Manager *manager = [Manager shareInstance];
    MyCommentListModel *tempModel = manager.myCommentArr[indexPath.section];
    
    
    return cell;
    
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
