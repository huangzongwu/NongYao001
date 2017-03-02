//
//  TodaySaleListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TodaySaleListViewController.h"
#import "TodaySaleHeaderCollectionViewCell.h"
#import "TodaySaleListCollectionViewCell.h"
#import "Manager.h"
#import "MJRefresh.h"
@interface TodaySaleListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *todaySaleListCollectionView;
@property (nonatomic,strong)NSMutableArray *todaySaleListArr;

@end

@implementation TodaySaleListViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self downPushRefresh];
    //执行一次
    [self.todaySaleListCollectionView headerBeginRefreshing];
}

- (void)downPushRefresh {
    Manager *manager = [Manager shareInstance];

    [self.todaySaleListCollectionView addHeaderWithCallback:^{
        [manager searchTodayActivityWithAid:self.temp_a_id withSearchTodaySuccess:^(id successResult) {
            //下拉刷新效果消失
            [self.todaySaleListCollectionView headerEndRefreshing];
            
            self.todaySaleListArr = [NSMutableArray arrayWithArray:successResult];
            [self.todaySaleListCollectionView reloadData];
            
            
        } withSearchTodayFail:^(NSString *failResultStr) {
            
        }];

    }];
    
    
    
}


#pragma mark - collectionView delegate -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.todaySaleListArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenW, kScreenW/3);
    }else {
        return CGSizeMake((kScreenW-1)/2, (kScreenW-1)/2+95);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TodaySaleHeaderCollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"todaySaleListHeaderCell" forIndexPath:indexPath];
        return headerCell;
    }else {
        TodaySaleListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"todaySaleListCollectionCell" forIndexPath:indexPath];
        TodaySaleListModel *tempModel = self.todaySaleListArr[indexPath.row];
        [cell updateTodaySaleListCellWithModel:tempModel];
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
