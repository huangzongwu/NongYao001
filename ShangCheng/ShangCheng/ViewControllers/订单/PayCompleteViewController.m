//
//  PayCompleteViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/11.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "PayCompleteViewController.h"
#import "ProductDetailViewController.h"
@interface PayCompleteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation PayCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //发送通知到订单列表，刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self userInfo:nil];
    
}
- (IBAction)leftBarbuttonAction:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//继续购买
- (IBAction)goOnPayAction:(UIButton *)sender {
    //回到首页
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//查看订单
- (IBAction)lookOrderButtonAction:(UIButton *)sender {
    [self.tabBarController setSelectedIndex:3];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - collectionView Delegate -
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"payCompleteHeaderView" forIndexPath:indexPath];
    return headerView;
}

- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kScreenW/2 - 1, 100);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"payCompleteCell" forIndexPath:indexPath];
    return cell;
    
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
    
  
}


@end
