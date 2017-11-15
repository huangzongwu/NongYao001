//
//  BannerShopViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "BannerShopViewController.h"
#import "BannerCellOneCollectionViewCell.h"
#import "BannerShopTwoCollectionViewCell.h"
#import "BannerCellThreeCollectionViewCell.h"
#import "BannerCellFourCollectionViewCell.h"
#import "BannerShopCollectionReusableView.h"
#import "Manager.h"
@interface BannerShopViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *bannerCollectionView;

@property (nonatomic,strong)NSArray *keyArr;
@property (nonatomic,strong)NSMutableDictionary *dataSourceDic;

@end

@implementation BannerShopViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册cell
    [self.bannerCollectionView registerNib:[UINib nibWithNibName:@"BannerCellOneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bannerCellOne"];
    [self.bannerCollectionView registerNib:[UINib nibWithNibName:@"BannerCellThreeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bannerCellThree"];
    [self.bannerCollectionView registerNib:[UINib nibWithNibName:@"BannerCellFourCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bannerCellFour"];

    self.keyArr = @[@"4",@"7",@"5",@"6",@"9",@"8",@"13"];
    
    for (NSString *tempKey in self.keyArr) {
        //网络请求活动列表数据
        Manager *manager = [Manager shareInstance];
        [manager httpActivityProductListWithType:tempKey withKeyword:@"" withPageIndex:1 withPageSize:@"6" withActivityListSuccess:^(id successResult) {
            [self.dataSourceDic setObject:successResult forKey:tempKey];
//            [self.dataSourceDic setValue:successResult forKey:tempKey];
            
            [self.bannerCollectionView reloadData];
        } withActivityFail:^(NSString *failResultStr) {
            
        }];
        
    }
    
    
    
    
   
    
    
    

    
}

#pragma mark - collectionView -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1 + self.keyArr.count + 2 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 || section == self.keyArr.count+1 || section == self.keyArr.count+2) {
        return 1;
    }else {
        //
        NSMutableArray *dataSorceArr = [self.dataSourceDic objectForKey:self.keyArr[section-1]];
        return dataSorceArr.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return CGSizeMake(kScreenW, 0);
    }else{
        
        return CGSizeMake(kScreenW, 70);
    }
}

    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenW, kScreenW/206*175);
    }else if (indexPath.section == self.keyArr.count + 1){
        return CGSizeMake(kScreenW, 565);
    }else if(indexPath.section == self.keyArr.count + 2){
        return CGSizeMake(kScreenW, 315);

    }else{
        return CGSizeMake((kScreenW-30)/2, (kScreenW-30)/2*205/128);
        
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BannerShopCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"bannerShopHeadView" forIndexPath:indexPath];
        [headerView updateBannerHeadViewWithTempSection:indexPath.section withTotalSection:1 + self.keyArr.count + 2];
        return headerView;
    }
    return 0;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BannerCellOneCollectionViewCell *bannerOneCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerCellOne" forIndexPath:indexPath];
        return bannerOneCell;
        
    }else if (indexPath.section == self.keyArr.count + 1){
        BannerCellThreeCollectionViewCell *bannerThreeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerCellThree" forIndexPath:indexPath];

        return bannerThreeCell;

    }else if(indexPath.section == self.keyArr.count + 2){
        BannerCellFourCollectionViewCell *bannerFourCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerCellFour" forIndexPath:indexPath];
        
        return bannerFourCell;
        
    }else {
        BannerShopTwoCollectionViewCell *bannerTwoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerShopCellTwo" forIndexPath:indexPath];
        return bannerTwoCell;
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
