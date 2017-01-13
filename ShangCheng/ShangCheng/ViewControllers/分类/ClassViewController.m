//
//  ClassViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/19.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ClassViewController.h"
#import "LeftProductClassTableViewCell.h"
#import "RightHeaderCollectionReusableView.h"
#import "RightProductClassCollectionViewCell.h"
#import "Manager.h"
#import "ProductListViewController.h"

@interface ClassViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//左边的TableView
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;

//选择左边分类的标记
@property(nonatomic,assign)NSInteger selectLeftInt;
//右边的collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;
@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //请求分类数据
    Manager *manager = [Manager shareInstance];
    [manager httpProductClassTreeWithClassTreeSuccess:^(id successResult) {
        [self.leftTableView reloadData];
        [self.rightCollectionView reloadData];

    } withClassTreeFali:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);

    }];
   
    
}

#pragma mark - 左边的 TableView Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    return manager.productClassTreeArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];

    LeftProductClassTableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:@"leftProductClassCell" forIndexPath:indexPath];
    ClassModel *tempLeftModel = manager.productClassTreeArr[indexPath.row];
    
    [leftCell updateLeftCellWithTitle:tempLeftModel.d_value];
    
    return leftCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果选择了不同的分类，那么就刷新右边的collectionView
    if (self.selectLeftInt != indexPath.row) {
        self.selectLeftInt = indexPath.row;
        [self.rightCollectionView reloadData];
    }

    
}

#pragma mark - 右边的 CollectionView Delegate -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    Manager *manager = [Manager shareInstance];
    if (manager.productClassTreeArr.count > 0) {
        NSArray *rightArr = [manager.productClassTreeArr[self.selectLeftInt] subItemArr];
        return rightArr.count;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Manager *manager = [Manager shareInstance];
    NSArray *rightArr = [manager.productClassTreeArr[self.selectLeftInt] subItemArr];
    
    ClassModel *tempModel = rightArr[section];
    if (tempModel.isMore == NO && tempModel.subItemArr.count > 6) {
        return 6;
    }else {
        return tempModel.subItemArr.count;
    }
    
    
    
   
    
}

////分区头高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//   
//    
//}


//分区头设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    RightHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"rightCollectionHeaderView" forIndexPath:indexPath];
    headerView.rightHeaderButton.indexForButton = indexPath;
    
    Manager *manager = [Manager shareInstance];
    NSArray *rightArr = [manager.productClassTreeArr[self.selectLeftInt] subItemArr];
    ClassModel *rightModel = rightArr[indexPath.section];
    [headerView updateRightHeaderViewWithModel:rightModel];
    
    headerView.moreButtonIndex = ^(NSIndexPath *moreButtonIndex){

        ClassModel *rightModel1 = rightArr[moreButtonIndex.section];
        rightModel1.isMore = !rightModel1.isMore;
        NSIndexSet *setaa = [NSIndexSet indexSetWithIndex:moreButtonIndex.section];
        [self.rightCollectionView reloadSections:setaa];
        
    };
    return headerView;
    
}

//item 大小
- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kScreenW - 120 - 20)/3, 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RightProductClassCollectionViewCell *rightCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightCollectionCell" forIndexPath:indexPath];
    Manager *manager = [Manager shareInstance];
    NSArray *rightArr = [manager.productClassTreeArr[self.selectLeftInt] subItemArr];
    NSArray *rightDetailArr = [rightArr[indexPath.section] subItemArr];
    ClassModel *rightDetailModel = rightDetailArr[indexPath.row];
    [rightCell updateRightCellWithTitle:rightDetailModel.d_value];
    
    return rightCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    NSArray *rightArr = [manager.productClassTreeArr[self.selectLeftInt] subItemArr];
    NSArray *rightDetailArr = [rightArr[indexPath.section] subItemArr];
    ClassModel *rightDetailModel = rightDetailArr[indexPath.row];
    [self performSegueWithIdentifier:@"classToProductListVC" sender:rightDetailModel.d_code];

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
    if ([segue.identifier isEqualToString:@"classToProductListVC"]) {
        FuzzySearchModel *fuzzySearchModel = [FuzzySearchModel itemWithCode:sender name:@"" areaid:@"" pd:@"" suppliername:@"" level:@"" status:@"" price:@"" date:@""];
        ProductListViewController *productListsVC = [segue destinationViewController];
        productListsVC.tempFuzzySearchModel = fuzzySearchModel;
        
    }
    
    
}


@end
