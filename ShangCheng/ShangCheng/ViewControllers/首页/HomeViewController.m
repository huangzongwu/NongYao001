//
//  HomeViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "HomeViewController.h"
#import "Manager.h"

#import "ImageCollectionReusableView.h"
#import "MaxSaleHotCollectionReusableView.h"
#import "HotCollectionReusableView.h"
#import "MainCollectionReusableView.h"
#import "CategoryCollectionViewCell.h"
#import "TodaySaleImageCollectionViewCell.h"
#import "DetailHorizontalCollectionViewCell.h"
#import "DetailVerticalCollectionViewCell.h"

#import "ProductDetailViewController.h"
@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"imageHeader"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MaxSaleHotCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"maxSaleHotFooter"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeader"];

    [self.collectionView registerNib:[UINib nibWithNibName:@"MainCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainHeader"];
    
    
    //网络请求首页数据
    [[Manager shareInstance] httpHomeProductWithCnum:@"3" withRnum:@"4" withSuccessHomeResult:^(id successResult) {
        if (successResult != nil) {
            //
            [self.collectionView reloadData];
        }
    } withFailHomeResult:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);
    }];
    
}


#pragma mark - collectionView Delegate -
//多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //八大分类，今日特价，人气热卖，详情
    NSLog(@"%ld", [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] count]);
    return 3 + [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] count];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 8;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        default:
        {
            ProductClassModel *tempClassModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:section-3];
            return tempClassModel.productArr.count;

        }
            break;
    }
}


//分区头部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return CGSizeMake(kScreenW, kScreenW/2);
            break;
        case 1:
            return CGSizeMake(kScreenW, 15);
            break;
        case 2:
            return CGSizeMake(kScreenW, 50+15);
            break;

        default:
        {
            /*
            //如果这个分区有数据才显示分区头
            ProductClassModel *tempClassModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:section-3];
            if (tempClassModel.productArr.count > 0) {
                return CGSizeMake(kScreenW, 70+15);

            }else{
                return CGSizeMake(kScreenW, 0);
            }
            */
            return CGSizeMake(kScreenW, 70+15);
        }
            break;
    }
}

//尾部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenW, 30);
    }else{
        return CGSizeMake(0, 0);
    }
}


//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    switch (indexPath.section) {
        case 0:
            //分类
            return CGSizeMake(kScreenW/4, kScreenW/4);
            break;
        case 1:
            //今日特价
            return CGSizeMake(kScreenW, kScreenW/4.7);
            break;
        case 2:
            //人气热卖
        {
            if (indexPath.row == 0) {
                return CGSizeMake(kScreenW/3-5, kScreenW/2);
            }else{
                return CGSizeMake(kScreenW*2/3, kScreenW/2);

            }
        }
            break;
        default:
            return CGSizeMake(kScreenW/2, kScreenW/2+50);

            break;
    }
    
}

//头尾部设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.section);
    switch (indexPath.section) {
        case 0:
        {
            if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
                ImageCollectionReusableView *imageHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"imageHeader" forIndexPath:indexPath];
                return imageHeader;

            }else{
                MaxSaleHotCollectionReusableView *maxSaleHotFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"maxSaleHotFooter" forIndexPath:indexPath];
                return maxSaleHotFooter;

            }
            
        }
            break;
        case 1: {
            UICollectionReusableView *spaceHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"spaceHeader" forIndexPath:indexPath];
            return spaceHeader;
        }
        case 2:
        {
            HotCollectionReusableView *hotHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeader" forIndexPath:indexPath];
//            hotHeader.backgroundColor = [UIColor yellowColor];

            return hotHeader;
        }

            break;

        default:
        {

            MainCollectionReusableView *mainHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainHeader" forIndexPath:indexPath];
            //            mainHeader.backgroundColor = [UIColor blueColor];
            
            //得到分类
            ProductClassModel *tempClassModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:indexPath.section-3];
            
            [mainHeader updateMainHomeCell:tempClassModel.productClassName withSection:indexPath.section];
            
            //更多按钮实现的方法
            mainHeader.morebuttonIndexBlock = ^(NSInteger moreButtonIndex){
                ProductClassModel *tempClassModel1 = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:moreButtonIndex-3];

                NSLog(@"%@--%@",tempClassModel1.productClassID,tempClassModel1.productClassName);
            };
            
            return mainHeader;

        }
            break;
    }
    
}


//cellForItem
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld===%ld",indexPath.section,indexPath.row);
    Manager *manager = [Manager shareInstance];
    
    switch (indexPath.section) {
        case 0:
        {
            CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier1" forIndexPath:indexPath];
//            cell.backgroundView.backgroundColor = [UIColor grayColor];
            return cell;

        }
            break;
        case 1:
        {
            TodaySaleImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier2" forIndexPath:indexPath];
//            cell.backgroundView.backgroundColor = [UIColor grayColor];
            return cell;

        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                //纵向
                DetailVerticalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier4" forIndexPath:indexPath];

                ProductModel *tempModel = [[manager.homeDataSourceDic objectForKey:@"热销"] objectAtIndex:0];
                
                [cell updateDetailVerticalCollectionViewCell:tempModel];
                //            cell.backgroundView.backgroundColor = [UIColor grayColor];
                return cell;
            }else{
                //两个横向
                DetailHorizontalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier3" forIndexPath:indexPath];
                ProductModel *tempModel1 = [[manager.homeDataSourceDic objectForKey:@"热销"] objectAtIndex:1];
                ProductModel *tempModel2 = [[manager.homeDataSourceDic objectForKey:@"热销"] objectAtIndex:2];

                [cell updateDetailHorizontalCollectionViewCellWithUpModel:tempModel1 withDownModel:tempModel2];
                //            cell.backgroundView.backgroundColor = [UIColor grayColor];
                return cell;
            }
         

        }
            break;

        default:
        {
            //详情，都是纵向
            DetailVerticalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier4" forIndexPath:indexPath];
            
            //得到分类
            ProductClassModel *tempClassModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:indexPath.section-3];
            
            ProductModel *tempProductModel = tempClassModel.productArr[indexPath.row];
            [cell updateDetailVerticalCollectionViewCell:tempProductModel];
            
            return cell;
        }
            break;
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > 1) {
        
        [self performSegueWithIdentifier:@"homeToDetail" sender:indexPath];
    }
}
//人气热卖中上面的button
- (IBAction)upHotButtonAction:(DetailHorizontalButton *)sender {
    //index是2-1
    [self performSegueWithIdentifier:@"homeToDetail" sender:[NSIndexPath indexPathForItem:1 inSection:2]];
    
}
//人气热卖中下面的button
- (IBAction)downHotButtonAction:(DetailHorizontalButton *)sender {
    //index是2-2
    [self performSegueWithIdentifier:@"homeToDetail" sender:[NSIndexPath indexPathForItem:2 inSection:2]];
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
    
    NSIndexPath *selectIndex = sender;
    NSLog(@"%ld -- %ld",selectIndex.section ,selectIndex.row);
    
    
    
    //到详情页面
    if ([segue.identifier isEqualToString:@"homeToDetail"]) {
        //传值
        ProductDetailViewController *productDetailVC = [segue destinationViewController];

        //人气热卖
        if (selectIndex.section == 2) {
            ProductModel *hotProductModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"热销"] objectAtIndex:selectIndex.row];
            productDetailVC.productModel = hotProductModel;

        }
        //推荐产品
        if (selectIndex.section > 2) {
            //得到分类
            ProductClassModel *tempClassModel = [[[Manager shareInstance].homeDataSourceDic objectForKey:@"推荐"] objectAtIndex:selectIndex.section-3];
            
            ProductModel *tempProductModel = tempClassModel.productArr[selectIndex.row];
//            productDetailVC.productID = @"42DE00CD74E340D9B0527469593CA93C";
            productDetailVC.productModel = tempProductModel;
        }

    }
    
    
}


@end
