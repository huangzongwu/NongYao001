//
//  MyFavoriteListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyFavoriteListViewController.h"
#import "Manager.h"
#import "MyFavoriteListTableViewCell.h"
@interface MyFavoriteListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myfavoriteTableView;

@end

@implementation MyFavoriteListViewController

//返回
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Manager *manager = [Manager shareInstance];
    [manager httpMyFavoriteListWithUserId:manager.memberInfoModel.u_id withMyFavoriteSuccess:^(id successResult) {
        [self.myfavoriteTableView reloadData];
    } withMyFavoriteFail:^(NSString *failResultStr) {
        
    }];
    
}

#pragma mark - TableView delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    return manager.myFavoriteArr.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyFavoriteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myFavotiteCell" forIndexPath:indexPath];
    cell.deleteButton.indexForButton = indexPath;
    cell.joinShoppingCarButton.indexForButton = indexPath;
    
    Manager *manager = [Manager shareInstance];
    
    MyFavoriteListModel *tempModel = manager.myFavoriteArr[indexPath.row];
    [cell updateMyFavoriteListCell:tempModel];
    
    return cell;

}



#pragma mark - 删除收藏产品 -
- (IBAction)deleteFavoriteProductAction:(IndexButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    MyFavoriteListModel *tempFavoriteModel = manager.myFavoriteArr[sender.indexForButton.row];
    [manager httpDeleteFavoriteProductWithFavoriteArr:[NSMutableArray arrayWithObjects:tempFavoriteModel, nil] withDeleteFavoriteSuccess:^(id successResult) {
        
        [self.myfavoriteTableView reloadData];
        
    } withDeleteFavoriteFail:^(NSString *failResultStr) {
        
    }];
    
}

#pragma mark - 加入购物车 -
- (IBAction)joinShoppingCarButtonAction:(IndexButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    MyFavoriteListModel *tempFavoriteModel = manager.myFavoriteArr[sender.indexForButton.row];
    
    [manager httpProductToShoppingCarWithFormatId:tempFavoriteModel.favoriteProductFormatID withProductCount:@"1" withSuccessToShoppingCarResult:^(id successResult) {
        AlertManager *alertM = [AlertManager shareIntance];
        [alertM showAlertViewWithTitle:nil withMessage:@"加入购物车成功" actionTitleArr:nil withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            //发送通知，让购物车界面刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShoppingCarVC" object:self userInfo:nil];
        }];

    } withFailToShoppingCarResult:^(NSString *failResultStr) {
        NSLog(@"加入失败");
    }];
    
    
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
