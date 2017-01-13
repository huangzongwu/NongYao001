//
//  MineViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/1.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderCollectionReusableView.h"
#import "MineCollectionViewCellOne.h"
#import "MineCollectionViewCellTwo.h"
#import "MineCollectionViewCellThree.h"
#import "MineCollectionViewCellFour.h"
#import "Manager.h"
@interface MineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *mineCollectionView;

@property (nonatomic,strong)NSMutableArray *mineDataSource;

@end

@implementation MineViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，登陆成功
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logedInAction:) name:@"logedIn" object:nil];
        //通知，退出登录
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logOffAction:) name:@"logOff" object:nil];

        
    }
    return self;
}
//登录成功后的通知
- (void)logedInAction:(NSNotification *) sender {
    //登录了，需要刷新页面
    [self.mineCollectionView reloadData];
}
//退出登录后的通知
- (void)logOffAction:(NSNotification *) sender {
    [self.mineCollectionView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"mineDataSource" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    //解析得到返回结果
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    Manager *manager = [Manager shareInstance];
    
    //判断状态，现在是否登陆了，
    if ([manager isLoggedInStatus] == YES) {
        //已经登录
    }else {
        //未登录
    }
    //创建数据源//需要判断状态，是否登录了
    self.mineDataSource = [jsonDic objectForKey:@"delegateUser"];
    
    
}
#pragma mark - 头部的一些事件 -
//点击头像，如果没有登录，就登录，如果登录了就切换头像
- (IBAction)headerImageTap:(UITapGestureRecognizer *)sender {
    
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        //已经登录
    }else {
        //未登录,跳转到登录界面
        UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
    
    
}

//账户管理
- (IBAction)memberManager:(UIButton *)sender {
    //跳转到登录界面
    
}

#pragma mark - collectionView Delegate - 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.mineDataSource.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[self.mineDataSource objectAtIndex:section] count];
}

//分区头部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2 || section == 3) {
        //如果有这个分区有内容，才有这个分区头。否则就不要分区头
        if ([[self.mineDataSource objectAtIndex:section] count] > 0) {
            return CGSizeMake(kScreenW, 50);

        }else{
            return CGSizeMake(kScreenW, 0);

        }
    }else {
        return CGSizeMake(kScreenW, 0);
    }
    
}

//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(kScreenW, 150);
            break;
        case 1:
        case 2:
            return CGSizeMake(kScreenW/[[self.mineDataSource objectAtIndex:indexPath.section] count], kScreenW/[[self.mineDataSource objectAtIndex:indexPath.section] count]);
            break;
        case 3:
            return CGSizeMake(kScreenW/3, kScreenW/5);
            break;
        case 4:
            return CGSizeMake(kScreenW/4, kScreenW/4);
        default:
            return CGSizeMake(kScreenW, 0);
            break;
    }
    
}
//头部设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MineHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mineHeader" forIndexPath:indexPath];
        
        switch (indexPath.section) {
            case 1:
                [headerView updateHeaderCellWithTitleStr:@"我的订单" withButtonTitle:@"查看全部订单"];
                break;
            case 2:
                [headerView updateHeaderCellWithTitleStr:@"我的钱包" withButtonTitle:@"查看"];

                break;
            default:
                break;
        }
        
        headerView.headerCellButton.indexForButton = indexPath;
        
        
        
        return headerView;
    }
    return 0;
}

- (IBAction)headerButtoonAction:(IndexButton *)sender {
    NSLog(@"%ld",sender.indexForButton.section);
    
    switch (sender.indexForButton.section) {
        case 1:
        {
            //查看全部订单
            [self switchToOrderTabbarWithOrderType:1];
            
        }
            break;
            
        default:
            break;
    }
    
}


//设置collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *infoDic = [[self.mineDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    
    switch (indexPath.section) {
        case 0:
        {
            MineCollectionViewCellOne *cellOne = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellOne" forIndexPath:indexPath];
            [cellOne updateMineCollectionViewCellOne];
            
            return cellOne;
        }
            break;
        case 1:
        case 4:
        {
            MineCollectionViewCellTwo *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellTwo" forIndexPath:indexPath];
            [cellTwo updateCellWithHeaderImage:[infoDic objectForKey:@"info1"] withInfoStr:[infoDic objectForKey:@"info2"]];
            return cellTwo;
   
        }
            break;
        case 2:
        {
            if (indexPath.row < 3) {
                //上文字，下文字
                MineCollectionViewCellThree *cellThree = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellThree" forIndexPath:indexPath];
                [cellThree updateCellWithHeaderStr:[infoDic objectForKey:@"info1"] withInfoStr:[infoDic objectForKey:@"info2"]];
                return cellThree;
            }else {
                MineCollectionViewCellTwo *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellTwo" forIndexPath:indexPath];
                [cellTwo updateCellWithHeaderImage:[infoDic objectForKey:@"info1"] withInfoStr:[infoDic objectForKey:@"info2"]];

                return cellTwo;
            }
        }
            break;
        case 3:
        {
            MineCollectionViewCellFour *cellFour = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellFour" forIndexPath:indexPath];
            [cellFour updateCellWithInfoStr1:[infoDic objectForKey:@"info1"] withInfoStr2:[infoDic objectForKey:@"info2"]];
            return cellFour;
            
        }
            break;
        default:
            return 0;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld -- %ld",indexPath.section,indexPath.row);
    NSString *pushID = [[self.mineDataSource[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"pushId"];
    if (indexPath.section == 1 && indexPath.row < 3) {
        //直接跳转到订单
        [self switchToOrderTabbarWithOrderType:indexPath.row+2];
    }else {
        //如果有pushId的话，才跳转
        if (pushID.length > 0) {
            [self performSegueWithIdentifier:pushID sender:[collectionView cellForItemAtIndexPath:indexPath]];
            
        }

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 切换到订单页面 -
- (void)switchToOrderTabbarWithOrderType:(NSInteger )orderType {
    /*
     orderType 订单的类型
     1-全部  2-待付款  3-进行中  4-已完成
     */
    //发送通知到订单界面，切换订单类型
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mineToOrderListVC" object:self userInfo:@{@"orderType":[NSString stringWithFormat:@"%ld",orderType]}];
    [self.tabBarController setSelectedIndex:3];
    
}

#pragma mark - Navigation



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
