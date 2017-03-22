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
#import "SearchViewController.h"
#import "ProductListViewController.h"
#import "KongImageView.h"
@interface ClassViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)KongImageView *kongImageView;

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
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    [self.kongImageView.reloadAgainButton addTarget:self action:@selector(reloadAgainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kongImageView.frame = self.view.bounds;
    [self.view addSubview:self.kongImageView];
    
    //加载数据
    [self reloadAgainButtonAction:nil];
}


//空白页
- (void)isShowKongImageViewWithType:(KongType )kongType withKongMsg:(NSString *)msg {
    Manager *manager = [Manager shareInstance];
    if (manager.productClassTreeArr.count > 0) {
        [self.kongImageView hiddenKongView];
    }else {
        [self.kongImageView showKongViewWithKongMsg:msg withKongType:kongType];
    }
    
}

//重新加载按钮
- (void)reloadAgainButtonAction:(IndexButton *)sender {
    //请求分类数据
    Manager *manager = [Manager shareInstance];
    [manager httpProductClassTreeWithClassTreeSuccess:^(id successResult) {
        //看看是否显示空白页
        [self isShowKongImageViewWithType:KongTypeWithKongData withKongMsg:@"暂无分类"];

        
        [self.leftTableView reloadData];
        [self.rightCollectionView reloadData];
        
    } withClassTreeFali:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);

        [self isShowKongImageViewWithType:KongTypeWithNetError withKongMsg:@"网络错误"];
        
    }];

}



#pragma mark - 搜索 -
- (IBAction)searchAction:(UITapGestureRecognizer *)sender {
    UINavigationController *searchNav = [self.storyboard instantiateViewControllerWithIdentifier:@"searchNavigationController"];
    SearchViewController *searchVC = [searchNav.viewControllers objectAtIndex:0];
    searchVC.productOrPests = Product;
    [self presentViewController:searchNav animated:YES completion:nil];
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
    if (indexPath.row == self.selectLeftInt) {
        [leftCell updateLeftCellWithTitle:tempLeftModel.d_value withIsSelectItem:YES];//选中的cell
    }else{
        [leftCell updateLeftCellWithTitle:tempLeftModel.d_value withIsSelectItem:NO];//未选中的cell
    }
    
    return leftCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果选择了不同的分类，那么就刷新右边的collectionView
    if (self.selectLeftInt != indexPath.row) {
        self.selectLeftInt = indexPath.row;
        [self.rightCollectionView reloadData];
        
        //更新左边的选中颜色样式
        [self.leftTableView reloadData];
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
    
    return CGSizeMake((kScreenW*13/18 - 43-18)/3, 30);

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
    NSLog(@"%@",rightDetailModel.d_value);

    
    UINavigationController *searchNav = [self.storyboard instantiateViewControllerWithIdentifier:@"searchNavigationController"];
    //跳转到列表界面
    [searchNav.viewControllers[0] performSegueWithIdentifier:@"searchToListVC" sender:@[@"TypeProduct",rightDetailModel.d_value]];


    [self presentViewController:searchNav animated:NO completion:nil];
    
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
//    if ([segue.identifier isEqualToString:@"searchToListVC"]) {
//        ProductListViewController *productListVC = [segue destinationViewController];
//        productListVC.tempCode = sender;
//        productListVC.isSearchOrType = isType;
//    }
    
    
}


@end
